//
// SafeFetching
// Copyright © 2021-present Alexis Bridoux.
// MIT license, see LICENSE file for details

import CoreData

extension Builders {

    /// `RequestBuilder` with no target
    public struct PreRequest<Entity: NSManagedObject, Step: RequestBuilderStep, Fetched: Fetchable> {
        var request: NSFetchRequest<Entity>
    }

    public struct Request<Entity: NSManagedObject, Step: RequestBuilderStep, Output: FetchResult> {

        public typealias FetchRequest = NSFetchRequest<Entity>

        let request: FetchRequest

        public var nsValue: FetchRequest { request }
    }
}

extension Builders.Request where Output.Fetched == Entity {

    /// Execute the fetch request in the context, using `Fetchable.context` if no context is provided
    public func fetch(in context: NSManagedObjectContext) throws -> Output {
        Output(results: try context.fetch(request))
    }
}
