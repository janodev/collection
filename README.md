![Swift](https://github.com/j4n0/collection/workflows/Swift/badge.svg?branch=master)

A reusable collection view controller where each row may be a different cell.

## Installation

Package and dependencies:
```
.package(url: "git@github.com:j4n0/collection.git", from: "1.0.0"),

.package(url: "git@github.com:j4n0/autolayout.git", from: "1.0.0"),
.package(url: "git@github.com:j4n0/log.git", from: "1.0.0"),
.package(url: "git@github.com:apple/swift-log.git", from: "1.2.0")
```

## Usage

- To create new headers and rows, copy paste the existing [Header](https://github.com/j4n0/collection/tree/master/sources/cells/header) or [subclass](https://github.com/j4n0/collection/blob/master/example/sources/main/table/ModalStyleCell.swift) an existing one.
- To create a controller [subclass](https://github.com/j4n0/collection/blob/master/example/sources/main/table/ModalStylesViewController.swift) or instantiate CollectionViewController. [Example](https://github.com/j4n0/collection/blob/master/example/sources/main/table/ModalStylesViewController.swift).

```swift
let controller = CollectionViewController(sections: [Section(title: "UIModalPresentationStyle", rows: [])
controller.output = { [weak self] output in /* handle cell click */ }
```

You may inspect the code from the [example project](https://github.com/j4n0/collection/tree/master/example).

## Design

A collection is a good way to create data driven screens with heterogeneous elements. Think Instagram, where you have header, photo, description, comments, buttons, etc. However there is an obstacle to implement this: Swift must know all types at compilation time, which is why arrays are covariant.

*Covariance* is the property of admiting a type of subclasses of it. For instance, Array<Animal> may contain `animal` or `cat`, but not fruits –`cat` is a subclass of animal but a `banana` is something else entirely.

So, if you want an heterogeneous array in Swift you may have at most 
```swift
protocol Model {}
struct Cat: Model {}
struct Banana: Model {}
let models: [Model] = [Cat(), Banana()]
```
This poses a problem: what is the exact type you get from the Array? you don’t know. You have to cast to a known type and see if you are right. This is the approach taken by `Codable`: it casts to all known JSON types until it is successful.

You may think “enums are an alternative way that avoids casting”. Of course:
```swift
enum Model { case banana, cat }
let models: [Model] = [.cat, .banana]
```
However, you are restricted in the number of types. I wanted this to work with an unknown array of arbitrary types. Obviously I can’t check the underlying model against infinite types, so the solution is to tie model and cell. Basically this:

![RowModel](https://github.com/j4n0/collection/blob/master/docs/CatViewCell.png)

Given a `Cat` model, the datasource will do:
```swift
let model = sections[indexPath.section].rows[indexPath.row]
let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier(), for: indexPath)
if let cell = cell as? Configurable {
    cell.configure(model)
}
```
and the cell will do
```swift
public func configure(_ model: Model) {
    guard let catModel = model as? Cat else {
        log.error("Expected a Cat model, but got a \(model)")
        return
    }
    ...
}
```

What about generics? well, generics in Swift are invariant so you can’t pass arbitrary unknown types. You can do [this](https://gist.github.com/j4n0/7541cb4ac5f9878f30c3902ed51d523c), and add another generic type as a header, and even an initializer with a variadic parameter. It‘s useful for simple cases.

### Header and row

You may base your own model/cells on the existing header:

![Provided Header](https://github.com/j4n0/collection/blob/master/docs/provided-header.png)

### CollectionViewController

![CollectionViewController](https://github.com/j4n0/collection/blob/master/docs/CollectionViewController.png)
