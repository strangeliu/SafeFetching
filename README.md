# SafeFetching

This library offers a DSL (Domain Specific Language) to safely build predicates and requests to fetch a CoreData store. Also a wrapper around `NSFetchedResultsController` is offered to publish arrays of `NSManagedObject` to be used with a `NSDiffableDataSource`.

The documentation is built with docC. To read it, run *Product* → *Build Documentation* or hit **⇧⌃⌘D**. Also, the documentation archive is provided in the [release's assets](https://github.com/ABridoux/SafeFetching/releases). In a few days, the doc should be available online.

**Note**
This repository is a split of [CoreDataCandy](https://github.com/ABridoux/core-data-candy) to offer the fetching features alone

## Convenient and safe fetching

For any CoreData entity generated by Xcode, the only required step is to make it implement `Fetchable`.

```swift
final class RandomEntity: NSManagedObject {

    @NSManaged var score = 0.0
    @NSManaged  var name: String? = ""
}
```

```swift
extension RandomEntity: Fetchable {}
```

Then it's possible to use the DSL to build a request. The last step can either get the built request as `NSFetchRequest<RandomEntity>` or execute the request in the provided context.

```swift
RandomEntity.request()
    .all(after: 10)
    .where(\.score >= 15 || \.name != "Joe")
    .sorted(by: .ascending(\.score), .descending(\.name))
    .setting(\.returnsDistinctResults, to: true)
    .nsValue
```

```swift
RandomEntity.request()
    .all(after: 10)
    .where(\.score >= 15 || \.name != "Joe")
    .sorted(by: .ascending(\.score), .descending(\.name))
    .setting(\.returnsDistinctResults, to: true)
    .fetch(in: context) // returns [RandomEntity]
```

Advanced `NSPredicate` operators are also available like `BEGINSWITH` (`hasPrefix`). To use one, specified a key path followed by `*`:

```swift
RandomEntity.request()
    .all()
    .where(\.name * .hasPrefix("Do"))
    .nsValue
```

More about that in the documentation.

## Fetch update

When the entity type implements `Fetchable`, it's possible to call the static `updatePublisher` function to create a publisher backed by a `NSFetchedResultsController` that will emit arrays of the entity. This is especially useful when working with a `NSDiffableDataSource`.

```swift
let request = RandomEntity.request()
    .all(after: 10)
    .where(\.score >= 15 || \.name != "Joe")
    .sorted(by: .ascending(\.score), .descending(\.name))
    .nsValue

RandomEntity.updatePublisher(
    for: request
    in: context
) // emits [RandomEntity]
```
