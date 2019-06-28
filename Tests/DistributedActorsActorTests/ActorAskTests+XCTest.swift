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

extension ActorAskTests {

   static var allTests : [(String, (ActorAskTests) -> () throws -> Void)] {
      return [
                ("test_ask_shouldSucceedIfResponseIsReceivedBeforeTimeout", test_ask_shouldSucceedIfResponseIsReceivedBeforeTimeout),
                ("test_ask_shouldFailIfResponseIsNotReceivedBeforeTimeout", test_ask_shouldFailIfResponseIsNotReceivedBeforeTimeout),
                ("test_ask_shouldCompleteWithFirstResponse", test_ask_shouldCompleteWithFirstResponse),
                ("test_askResult_shouldBePossibleTo_contextAwaitOn", test_askResult_shouldBePossibleTo_contextAwaitOn),
                ("test_askResult_whenContextAwaitedOn_shouldRespectTimeout", test_askResult_whenContextAwaitedOn_shouldRespectTimeout),
                ("test_ask_onDeadLetters_shouldPutMessageIntoDeadLetters", test_ask_onDeadLetters_shouldPutMessageIntoDeadLetters),
           ]
   }
}
