// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: ActorID.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Actors open source project
//
// Copyright (c) 2018-2022 Apple Inc. and the Swift Distributed Actors project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.md for the list of Swift Distributed Actors project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

public struct _ProtoActorID {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var node: _ProtoUniqueNode {
    get {return _node ?? _ProtoUniqueNode()}
    set {_node = newValue}
  }
  /// Returns true if `node` has been explicitly set.
  public var hasNode: Bool {return self._node != nil}
  /// Clears the value of `node`. Subsequent reads from it will return its default value.
  public mutating func clearNode() {self._node = nil}

  public var path: _ProtoActorPath {
    get {return _path ?? _ProtoActorPath()}
    set {_path = newValue}
  }
  /// Returns true if `path` has been explicitly set.
  public var hasPath: Bool {return self._path != nil}
  /// Clears the value of `path`. Subsequent reads from it will return its default value.
  public mutating func clearPath() {self._path = nil}

  public var incarnation: UInt32 = 0

  public var metadata: Dictionary<String,Data> = [:]

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _node: _ProtoUniqueNode? = nil
  fileprivate var _path: _ProtoActorPath? = nil
}

public struct _ProtoActorPath {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var segments: [String] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct _ProtoUniqueNode {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var node: _ProtoNode {
    get {return _node ?? _ProtoNode()}
    set {_node = newValue}
  }
  /// Returns true if `node` has been explicitly set.
  public var hasNode: Bool {return self._node != nil}
  /// Clears the value of `node`. Subsequent reads from it will return its default value.
  public mutating func clearNode() {self._node = nil}

  public var nid: UInt64 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _node: _ProtoNode? = nil
}

public struct _ProtoNode {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var `protocol`: String = String()

  public var system: String = String()

  public var hostname: String = String()

  public var port: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension _ProtoActorID: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "ActorID"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "node"),
    2: .same(proto: "path"),
    3: .same(proto: "incarnation"),
    4: .same(proto: "metadata"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._node) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._path) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.incarnation) }()
      case 4: try { try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufString,SwiftProtobuf.ProtobufBytes>.self, value: &self.metadata) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._node {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if let v = self._path {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    if self.incarnation != 0 {
      try visitor.visitSingularUInt32Field(value: self.incarnation, fieldNumber: 3)
    }
    if !self.metadata.isEmpty {
      try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufString,SwiftProtobuf.ProtobufBytes>.self, value: self.metadata, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: _ProtoActorID, rhs: _ProtoActorID) -> Bool {
    if lhs._node != rhs._node {return false}
    if lhs._path != rhs._path {return false}
    if lhs.incarnation != rhs.incarnation {return false}
    if lhs.metadata != rhs.metadata {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension _ProtoActorPath: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "ActorPath"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "segments"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedStringField(value: &self.segments) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.segments.isEmpty {
      try visitor.visitRepeatedStringField(value: self.segments, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: _ProtoActorPath, rhs: _ProtoActorPath) -> Bool {
    if lhs.segments != rhs.segments {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension _ProtoUniqueNode: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "UniqueNode"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "node"),
    2: .same(proto: "nid"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._node) }()
      case 2: try { try decoder.decodeSingularUInt64Field(value: &self.nid) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._node {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if self.nid != 0 {
      try visitor.visitSingularUInt64Field(value: self.nid, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: _ProtoUniqueNode, rhs: _ProtoUniqueNode) -> Bool {
    if lhs._node != rhs._node {return false}
    if lhs.nid != rhs.nid {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension _ProtoNode: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "Node"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "protocol"),
    2: .same(proto: "system"),
    3: .same(proto: "hostname"),
    4: .same(proto: "port"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.`protocol`) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.system) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.hostname) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.port) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.`protocol`.isEmpty {
      try visitor.visitSingularStringField(value: self.`protocol`, fieldNumber: 1)
    }
    if !self.system.isEmpty {
      try visitor.visitSingularStringField(value: self.system, fieldNumber: 2)
    }
    if !self.hostname.isEmpty {
      try visitor.visitSingularStringField(value: self.hostname, fieldNumber: 3)
    }
    if self.port != 0 {
      try visitor.visitSingularUInt32Field(value: self.port, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: _ProtoNode, rhs: _ProtoNode) -> Bool {
    if lhs.`protocol` != rhs.`protocol` {return false}
    if lhs.system != rhs.system {return false}
    if lhs.hostname != rhs.hostname {return false}
    if lhs.port != rhs.port {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}