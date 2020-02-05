//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Actors open source project
//
// Copyright (c) 2020 Apple Inc. and the Swift Distributed Actors project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.md for the list of Swift Distributed Actors project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

@testable import DistributedActors
import DistributedActorsTestKit
import Foundation
import XCTest

final class OpLogClusterReceptionistClusteredTests: ClusteredNodesTestBase {
    override func configureLogCapture(settings: inout LogCapture.Settings) {
        settings.excludeActorPaths = [
            "/system/cluster/swim",
            "/system/cluster/gossip",
            "/system/replicator",
            "/system/cluster",
            "/system/clusterEvents",
            "/system/cluster/leadership",
        ]
        settings.excludeGrep = [
            "timer",
        ]
    }

    let stopOnMessage: Behavior<String> = .receive { context, _ in
        context.log.warning("Stopping...")
        return .stop
    }

    override func configureActorSystem(settings: inout ActorSystemSettings) {
        settings.cluster.receptionist.implementation = .opLogSync
        settings.cluster.receptionist.ackPullReplicationIntervalSlow = .milliseconds(300)
    }

    func test_opLogClusterReceptionist_shouldReplicateRegistrations() throws {
        try shouldNotThrow {
            let (local, remote) = setUpPair()
            let testKit: ActorTestKit = self.testKit(local)
            try self.joinNodes(node: local, with: remote)

            let probe = testKit.spawnTestProbe(expecting: String.self)
            let registeredProbe = testKit.spawnTestProbe("registered", expecting: Receptionist.Registered<String>.self)

            let ref: ActorRef<String> = try local.spawn(
                .anonymous,
                .receiveMessage {
                    probe.tell("received:\($0)")
                    return .same
                }
            )

            let key = Receptionist.RegistrationKey(String.self, id: "test")

            // subscribe on `remote`
            let subscriberProbe = testKit.spawnTestProbe(expecting: Receptionist.Listing<String>.self)
            remote.receptionist.subscribe(key: key, subscriber: subscriberProbe.ref)
            _ = try subscriberProbe.expectMessage()

            // register on `local`
            local.receptionist.register(ref, key: key, replyTo: registeredProbe.ref)
            _ = try registeredProbe.expectMessage()

            let listing = try subscriberProbe.expectMessage()
            listing.refs.count.shouldEqual(1)
            guard let registeredRef = listing.refs.first else {
                throw subscriberProbe.error("listing contained no entries, expected 1")
            }
            registeredRef.tell("test")

            try probe.expectMessage("received:test")
        }
    }

    func test_opLogClusterReceptionist_shouldSyncPeriodically() throws {
        try shouldNotThrow {
            let (local, remote) = setUpPair {
                $0.cluster.receptionist.ackPullReplicationIntervalSlow = .seconds(1)
            }

            let probe = self.testKit(local).spawnTestProbe(expecting: String.self)
            let registeredProbe = self.testKit(local).spawnTestProbe(expecting: Receptionist.Registered<String>.self)
            let lookupProbe = self.testKit(local).spawnTestProbe(expecting: Receptionist.Listing<String>.self)

            let ref: ActorRef<String> = try local.spawn(
                .anonymous,
                .receiveMessage {
                    probe.tell("received:\($0)")
                    return .same
                }
            )

            let key = Receptionist.RegistrationKey(String.self, id: "test")

            remote.receptionist.tell(Receptionist.Subscribe(key: key, subscriber: lookupProbe.ref))

            _ = try lookupProbe.expectMessage()

            local.receptionist.tell(Receptionist.Register(ref, key: key, replyTo: registeredProbe.ref))
            _ = try registeredProbe.expectMessage()

            local.cluster.join(node: remote.cluster.node.node)
            try assertAssociated(local, withExactly: remote.settings.cluster.uniqueBindNode)

            let listing = try lookupProbe.expectMessage()
            listing.refs.count.shouldEqual(1)
            guard let registeredRef = listing.refs.first else {
                throw lookupProbe.error("listing contained no entries, expected 1")
            }
            registeredRef.tell("test")

            try probe.expectMessage("received:test")
        }
    }

    func test_opLogClusterReceptionist_shouldMergeEntriesOnSync() throws {
        try shouldNotThrow {
            let (local, remote) = setUpPair {
                $0.cluster.receptionist.ackPullReplicationIntervalSlow = .seconds(1)
            }

            let registeredProbe = self.testKit(local).spawnTestProbe("registeredProbe", expecting: Receptionist.Registered<String>.self)
            let localLookupProbe = self.testKit(local).spawnTestProbe("localLookupProbe", expecting: Receptionist.Listing<String>.self)
            let remoteLookupProbe = self.testKit(remote).spawnTestProbe("remoteLookupProbe", expecting: Receptionist.Listing<String>.self)

            let behavior: Behavior<String> = .receiveMessage { _ in
                .same
            }

            let refA: ActorRef<String> = try local.spawn("refA", behavior)
            let refB: ActorRef<String> = try local.spawn("refB", behavior)
            let refC: ActorRef<String> = try remote.spawn("refC", behavior)
            let refD: ActorRef<String> = try remote.spawn("refD", behavior)

            let key = Receptionist.RegistrationKey(String.self, id: "test")

            local.receptionist.tell(Receptionist.Register(refA, key: key, replyTo: registeredProbe.ref))
            _ = try registeredProbe.expectMessage()

            local.receptionist.tell(Receptionist.Register(refB, key: key, replyTo: registeredProbe.ref))
            _ = try registeredProbe.expectMessage()

            remote.receptionist.tell(Receptionist.Register(refC, key: key, replyTo: registeredProbe.ref))
            _ = try registeredProbe.expectMessage()

            remote.receptionist.tell(Receptionist.Register(refD, key: key, replyTo: registeredProbe.ref))
            _ = try registeredProbe.expectMessage()

            local.receptionist.tell(Receptionist.Subscribe(key: key, subscriber: localLookupProbe.ref))
            _ = try localLookupProbe.expectMessage()

            remote.receptionist.tell(Receptionist.Subscribe(key: key, subscriber: remoteLookupProbe.ref))
            _ = try remoteLookupProbe.expectMessage()

            local.cluster.join(node: remote.cluster.node.node)
            try assertAssociated(local, withExactly: remote.settings.cluster.uniqueBindNode)

            let localListing = try localLookupProbe.expectMessage()
            localListing.refs.count.shouldEqual(4)

            let remoteListing = try remoteLookupProbe.expectMessage()
            remoteListing.refs.count.shouldEqual(4)
        }
    }

    func test_clusterReceptionist_shouldRemoveRemoteRefsWhenNodeDies() throws {
        try shouldNotThrow {
            let (first, second) = setUpPair {
                $0.cluster.receptionist.ackPullReplicationIntervalSlow = .seconds(1)
            }

            let registeredProbe = self.testKit(first).spawnTestProbe(expecting: Receptionist.Registered<String>.self)
            let remoteLookupProbe = self.testKit(second).spawnTestProbe(expecting: Receptionist.Listing<String>.self)

            let refA: ActorRef<String> = try first.spawn(.anonymous, self.stopOnMessage)
            let refB: ActorRef<String> = try first.spawn(.anonymous, self.stopOnMessage)

            let key = Receptionist.RegistrationKey(String.self, id: "test")

            first.receptionist.register(refA, key: key, replyTo: registeredProbe.ref)
            _ = try registeredProbe.expectMessage()

            first.receptionist.register(refB, key: key, replyTo: registeredProbe.ref)
            _ = try registeredProbe.expectMessage()

            second.receptionist.subscribe(key: key, subscriber: remoteLookupProbe.ref)
            _ = try remoteLookupProbe.expectMessage()

            first.cluster.join(node: second.cluster.node.node)
            try assertAssociated(first, withExactly: second.settings.cluster.uniqueBindNode)

            let remoteListing = try remoteLookupProbe.expectMessage()
            remoteListing.refs.count.shouldEqual(2)

            refA.tell("stop")
            refB.tell("stop")

            let refs = try remoteLookupProbe.expectMessage().refs
            refs.shouldBeEmpty()
        }
    }

    func test_clusterReceptionist_shouldRemoveRefFromAllListingsItWasRegisteredWith_ifTerminates() throws {
        try shouldNotThrow {
            let (first, second) = setUpPair {
                $0.cluster.receptionist.ackPullReplicationIntervalSlow = .milliseconds(200)
            }
            first.cluster.join(node: second.cluster.node.node)
            try assertAssociated(first, withExactly: second.settings.cluster.uniqueBindNode)

            let firstKey: Receptionist.RegistrationKey<String> = .init(String.self, id: "first")
            let extraKey: Receptionist.RegistrationKey<String> = .init(String.self, id: "extra")

            let ref = try first.spawn("hi", self.stopOnMessage)
            first.receptionist.register(ref, key: firstKey)
            first.receptionist.register(ref, key: extraKey)

            let p1f = self.testKit(first).spawnTestProbe("p1f", expecting: Receptionist.Listing<String>.self)
            let p1e = self.testKit(first).spawnTestProbe("p1e", expecting: Receptionist.Listing<String>.self)
            let p2f = self.testKit(second).spawnTestProbe("p2f", expecting: Receptionist.Listing<String>.self)
            let p2e = self.testKit(second).spawnTestProbe("p2e", expecting: Receptionist.Listing<String>.self)

            // ensure the ref is registered and known under both keys to both nodes
            first.receptionist.subscribe(key: firstKey, subscriber: p1f.ref)
            first.receptionist.subscribe(key: extraKey, subscriber: p1e.ref)

            second.receptionist.subscribe(key: firstKey, subscriber: p2f.ref)
            second.receptionist.subscribe(key: extraKey, subscriber: p2e.ref)

            func expectListingOnAllProbes(expected: Set<ActorRef<String>>) throws {
                _ = try p1f.fishForMessages(within: .seconds(3)) {
                    if $0.refs == expected { return .catchComplete }
                    else { return .ignore }
                }
                _ = try p1e.fishForMessages(within: .seconds(3)) {
                    if $0.refs == expected { return .catchComplete }
                    else { return .ignore }
                }

                _ = try p2f.fishForMessages(within: .seconds(3)) {
                    if $0.refs == expected { return .catchComplete }
                    else { return .ignore }
                }
                _ = try p2e.fishForMessages(within: .seconds(3)) {
                    if $0.refs == expected { return .catchComplete }
                    else { return .ignore }
                }
            }

            try expectListingOnAllProbes(expected: [ref])

            // terminate it
            ref.tell("stop!")

            // it should be removed from all listings; on both nodes, for all keys
            try expectListingOnAllProbes(expected: [])
        }
    }

    func test_clusterReceptionist_shouldRemoveActorsOfTerminatedNodeFromListings_onNodeCrash() throws {
        try shouldNotThrow {
            let (first, second) = setUpPair {
                $0.cluster.receptionist.ackPullReplicationIntervalSlow = .milliseconds(200)
            }
            first.cluster.join(node: second.cluster.node.node)
            try assertAssociated(first, withExactly: second.settings.cluster.uniqueBindNode)

            let key: Receptionist.RegistrationKey<String> = .init(String.self, id: "first")

            let ref = try first.spawn("hi", self.stopOnMessage)
            first.receptionist.register(ref, key: key)

            let p1 = self.testKit(first).spawnTestProbe("p1", expecting: Receptionist.Listing<String>.self)
            let p2 = self.testKit(second).spawnTestProbe("p2", expecting: Receptionist.Listing<String>.self)

            // ensure the ref is registered and known under both keys to both nodes
            first.receptionist.subscribe(key: key, subscriber: p1.ref)
            second.receptionist.subscribe(key: key, subscriber: p2.ref)

            func expectListingOnAllProbes(expected: Set<ActorRef<String>>) throws {
                _ = try p1.fishForMessages(within: .seconds(3)) {
                    if $0.refs == expected { return .catchComplete }
                    else { return .ignore }
                }

                _ = try p2.fishForMessages(within: .seconds(3)) {
                    if $0.refs == expected { return .catchComplete }
                    else { return .ignore }
                }
            }

            try expectListingOnAllProbes(expected: [ref])

            // crash the second node
            second.shutdown()

            // it should be removed from all listings; on both nodes, for all keys
            _ = try p1.fishForMessages(within: .seconds(3)) {
                if $0.refs == [] { return .catchComplete }
                else { return .ignore }
            }
        }
    }

    func test_clusterReceptionist_shouldSpreadInformationAmongManyNodes() throws {
        try shouldNotThrow {
            let (first, second) = setUpPair {
                $0.cluster.receptionist.ackPullReplicationIntervalSlow = .milliseconds(200)
            }
            let third = setUpNode("third")
            let fourth = setUpNode("fourth")

            try self.joinNodes(node: first, with: second)
            try self.joinNodes(node: first, with: third)
            try self.joinNodes(node: fourth, with: second)

            let key: Receptionist.RegistrationKey<String> = .init(String.self, id: "key")

            let ref = try first.spawn("hi", self.stopOnMessage)
            first.receptionist.register(ref, key: key)

            func expectListingContainsRef(on system: ActorSystem) throws {
                let p = self.testKit(system).spawnTestProbe("p", expecting: Receptionist.Listing<String>.self)
                system.receptionist.subscribe(key: key, subscriber: p.ref)

                _ = try p.fishForMessages(within: .seconds(3)) {
                    if $0.refs == [ref] { return .catchComplete }
                    else { return .ignore }
                }
            }

            try expectListingContainsRef(on: first)
            try expectListingContainsRef(on: second)
            try expectListingContainsRef(on: third)
            try expectListingContainsRef(on: fourth)
        }
    }
}