![Swift](https://github.com/janodev/collection/workflows/Swift/badge.svg?branch=master)

A UICollectionView-based screen that displays heterogeneous cells of unknown type.

To display a new kind of cell just add the Swift file for the cell and change the data source data. You don’t need to touch the screen.

## Installation

Add this package:
```
.package(url: "git@github.com:janodev/collection.git", from: "1.0.0"),
```

## Usage

- To create new cells base your code in an existing [header](https://github.com/janodev/collection/blob/master/sources/main/cells/header/HeaderViewCell.swift) or [row](https://github.com/janodev/collection/blob/master/sources/main/cells/row/RowViewCell.swift):

```swift
class ModalStyleCell: ViewCell<ModalStyleView> {}

final class ModalStyleView: RowView {
    override public func configure(_ model: Model) {
        guard let style = model as? ModalStyleModel else { return }
        //...configure with model
    }
}
```

- To create a screen with default settings instantiate CollectionViewController:

```swift
let controller = CollectionViewController(sections: [Section(title: "UIModalPresentationStyle", rows: [])
controller.output = { [weak self] output in /* handle cell click */ }
```

You may inspect the code from the [example project](https://github.com/janodev/collection/tree/master/example).

## Design

A collection is a good way to create data driven screens with heterogeneous elements. Think Instagram, where you have header, photo, description, comments, buttons, etc. 

However there is an obstacle to implement this: Swift must know all types at compilation time, which is why arrays are covariant. *Covariance* is the property of admiting a type or subclasses of it. For instance, Array<Animal> may contain `animal` or `cat`, but not fruits. This is because `cat` is a subclass of animal but a `banana` is something else entirely.

So, if you want an heterogeneous array in Swift you may have at most an array of a superclass:
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

![RowModel](https://raw.githubusercontent.com/janodev/collection/main/docs/CatViewCell.png)

Given a `Cat` model, the datasource gets the reuseIdentifier from the model:
```swift
let model = sections[indexPath.section].rows[indexPath.row]
let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier(), for: indexPath)
if let cell = cell as? Configurable {
    cell.configure(model)
}
```
This creates an inconvenience, any time the controller receives new data, it iterates once to register new cells.

Model and cell know each other, so a cell for a given reuseIdentifier knows what type it should be casting the model to:
```swift
public func configure(_ model: Model) {
    guard let catModel = model as? Cat else {
        log.error("Expected a Cat model, but got a \(model)")
        return
    }
    ...
}
```

What about using generics? well, generics in Swift are invariant so you can’t pass arbitrary unknown types. You can do [this](https://gist.github.com/janodev/7541cb4ac5f9878f30c3902ed51d523c), and add another generic type as a header, and even an initializer with a variadic parameter. But it‘s only useful for simple cases.

### Header and row

The base header and cell won’t limit your design since you can use any view and model. Both are based on this design.

![Provided Header](https://raw.githubusercontent.com/janodev/collection/main/docs/provided-header.png)

### CollectionViewController

![CollectionViewController](https://raw.githubusercontent.com/janodev/collection/main/docs/CollectionViewController.png)
