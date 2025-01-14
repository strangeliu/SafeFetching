//
// SafeFetching
// Copyright © 2021-present Alexis Bridoux.
// MIT license, see LICENSE file for details

import CoreData

public protocol Fetchable: NSManagedObject {}

extension Fetchable {

    /// `NSFetchRequest` to fetch the entity
    public static func newFetchRequest() -> NSFetchRequest<Self> { .init(entityName: entity().name ?? String(describing: Self.self)) }

    public static func request() -> Builders.PreRequest<Self, CreationStep, Self> {
        Builders.PreRequest(request: newFetchRequest())
    }
}
