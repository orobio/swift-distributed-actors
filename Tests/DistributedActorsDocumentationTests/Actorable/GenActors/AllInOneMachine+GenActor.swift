// ==== ------------------------------------------------------------------ ====
// === DO NOT EDIT: Generated by GenActors                     
// ==== ------------------------------------------------------------------ ====

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

// tag::imports[]

import DistributedActors

// end::imports[]

import DistributedActorsTestKit
import XCTest

// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Generated AllInOneMachine messages 

/// DO NOT EDIT: Generated AllInOneMachine messages
extension AllInOneMachine {

    public enum Message { 
        case clean 
        case diagnostics(/*TODO: MODULE.*/GeneratedActor.Messages.Diagnostics) 
        case coffeeMachine(/*TODO: MODULE.*/GeneratedActor.Messages.CoffeeMachine) 
    }
    
    /// Performs boxing of GeneratedActor.Messages.Diagnostics messages such that they can be received by Actor<AllInOneMachine>
    public static func _boxDiagnostics(_ message: GeneratedActor.Messages.Diagnostics) -> AllInOneMachine.Message {
        .diagnostics(message)
    } 
    
    /// Performs boxing of GeneratedActor.Messages.CoffeeMachine messages such that they can be received by Actor<AllInOneMachine>
    public static func _boxCoffeeMachine(_ message: GeneratedActor.Messages.CoffeeMachine) -> AllInOneMachine.Message {
        .coffeeMachine(message)
    } 
    
}
// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Generated AllInOneMachine behavior

extension AllInOneMachine {

    public static func makeBehavior(instance: AllInOneMachine) -> Behavior<Message> {
        return .setup { _context in
            let context = Actor<AllInOneMachine>.Context(underlying: _context)
            var instance = instance

            /* await */ instance.preStart(context: context)

            return Behavior<Message>.receiveMessage { message in
                switch message { 
                
                case .clean:
                    instance.clean()
 
                
                case .diagnostics(.printDiagnostics):
                    instance.printDiagnostics()
 
                case .coffeeMachine(.makeCoffee(let _replyTo)):
                    let result = instance.makeCoffee()
                    _replyTo.tell(result)
 
                }
                return .same
            }.receiveSignal { _context, signal in 
                let context = Actor<AllInOneMachine>.Context(underlying: _context)

                switch signal {
                case is Signals.PostStop: 
                    instance.postStop(context: context)
                    return .same
                case let terminated as Signals.Terminated:
                    switch instance.receiveTerminated(context: context, terminated: terminated) {
                    case .unhandled: 
                        return .unhandled
                    case .stop: 
                        return .stop
                    case .ignore: 
                        return .same
                    }
                default:
                    return .unhandled
                }
            }
        }
    }
}
// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: Extend Actor for AllInOneMachine

extension Actor where A.Message == AllInOneMachine.Message {

 

}