// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetMyTodosQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getMyTodos {
      todos(limit: 40) {
        __typename
        id
        title
        created_at
        is_completed
      }
    }
    """

  public let operationName: String = "getMyTodos"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("todos", arguments: ["limit": 40], type: .nonNull(.list(.nonNull(.object(Todo.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(todos: [Todo]) {
      self.init(unsafeResultMap: ["__typename": "query_root", "todos": todos.map { (value: Todo) -> ResultMap in value.resultMap }])
    }

    /// fetch data from the table: "todos"
    public var todos: [Todo] {
      get {
        return (resultMap["todos"] as! [ResultMap]).map { (value: ResultMap) -> Todo in Todo(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Todo) -> ResultMap in value.resultMap }, forKey: "todos")
      }
    }

    public struct Todo: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["todos"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(Int.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("created_at", type: .nonNull(.scalar(String.self))),
          GraphQLField("is_completed", type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int, title: String, createdAt: String, isCompleted: Bool) {
        self.init(unsafeResultMap: ["__typename": "todos", "id": id, "title": title, "created_at": createdAt, "is_completed": isCompleted])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: Int {
        get {
          return resultMap["id"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var createdAt: String {
        get {
          return resultMap["created_at"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "created_at")
        }
      }

      public var isCompleted: Bool {
        get {
          return resultMap["is_completed"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "is_completed")
        }
      }
    }
  }
}
