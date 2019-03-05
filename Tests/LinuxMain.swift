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

import XCTest

///
/// NOTE: This file was generated by generate_linux_tests.rb
///
/// Do NOT edit this file directly as it will be regenerated automatically when needed.
///

#if os(Linux) || os(FreeBSD)
   @testable import CSwiftDistributedActorsMailboxTests
   @testable import DistributedActorsConcurrencyHelpersTests
   @testable import SwiftDistributedActorsActorTestKitTests
   @testable import Swift Distributed ActorsActorTests

   XCTMain([
         testCase(ActorIsolationFailureHandlingTests.allTests),
         testCase(ActorLeakingTests.allTests),
         testCase(ActorLifecycleTests.allTests),
         testCase(ActorLoggingTests.allTests),
         testCase(ActorPathTests.allTests),
         testCase(ActorRefAdapterTests.allTests),
         testCase(ActorSystemTests.allTests),
         testCase(ActorTestProbeTests.allTests),
         testCase(AnonymousNamesGeneratorTests.allTests),
         testCase(BehaviorCanonicalizeTests.allTests),
         testCase(BehaviorTests.allTests),
         testCase(CMPSCLinkedQueueTests.allTests),
         testCase(CMailboxTests.allTests),
         testCase(ConcurrencyHelpersTests.allTests),
         testCase(DeadlineTests.allTests),
         testCase(DeathWatchTests.allTests),
         testCase(DispatcherTests.allTests),
         testCase(InterceptorTests.allTests),
         testCase(MPSCLinkedQueueTests.allTests),
         testCase(NIOExtensionTests.allTests),
         testCase(ParentChildActorTests.allTests),
         testCase(RemotingBasicsTests.allTests),
         testCase(RemotingHandshakeTests.allTests),
         testCase(RingBufferTests.allTests),
         testCase(SerializationTests.allTests),
         testCase(StashBufferTests.allTests),
         testCase(SupervisionTests.allTests),
         testCase(TimeAmountTests.allTests),
         testCase(TimeSpecTests.allTests),
         testCase(TimersTests.allTests),
         testCase(TraversalTests.allTests),
    ])
#endif
