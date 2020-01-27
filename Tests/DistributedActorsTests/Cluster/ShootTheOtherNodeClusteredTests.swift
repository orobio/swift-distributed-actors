//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Actors open source project
//
// Copyright (c) 2018-2019 Apple Inc. and the Swift Distributed Actors project authors
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
import NIO
import XCTest

final class ShootTheOtherNodeClusteredTests: ClusteredNodesTestBase {
    override func configureLogCapture(settings: inout LogCapture.Settings) {
        settings.excludeGrep = [
            "TimerKey",
        ]
        settings.excludeActorPaths = [
            "/system/cluster/swim",
        ]
        settings.minimumLogLevel = .info
    }

    func test_shootOtherNodeShouldTerminateIt() throws {
        let (local, remote) = self.setUpPair()

        // also assures they are associated
        try self.joinNodes(node: local, with: remote, ensureWithin: .seconds(5), ensureMembers: .up)

        let remoteAssociationControlState0 = local._cluster!.associationRemoteControl(with: remote.cluster.node)
        guard case ClusterShell.AssociationRemoteControlState.associated(let remoteControl0) = remoteAssociationControlState0 else {
            throw Boom("Expected the association to exist for \(remote.cluster.node)")
        }

        ClusterShell.shootTheOtherNodeAndCloseConnection(system: local, targetNodeRemoteControl: remoteControl0)

        // the remote should get the "shot" and become down asap
        try self.testKit(local).eventually(within: .seconds(3)) {
            // we do NOT failTest:, since we are in an eventuallyBlock and are waiting for the logs to happen still
            // the eventually block will escalate the thrown errors if they do not cease within the time limit.
            try self.capturedLogs(of: remote).shouldContain(prefix: "Received .restInPeace", failTest: false)
            try self.capturedLogs(of: remote).shouldContain(prefix: "Self node was marked [.down]", failTest: false)
        }
    }
}