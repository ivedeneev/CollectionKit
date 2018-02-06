# CollectionKit


Framework to manage complex `UICollectionView` in declarative way and very few lines of code.
 Heavily inspired by https://github.com/maxsokolov/TableKit

# Features
 - [x] Type-safe generic cells
 - [x] No need to implement `UICollectionViewDataSource` and `UICollectionViewDelegate`
 - [x] Easy way to map your models into cells
 - [x] Convinient updations
 - [x] Supports cells from code and xibs and storyboard
 - [x] Supports custom section imlementations
 - [x] Register cells and reusable views automatically
 - [x] Fix scroll indicator clipping at iOS11 (http://www.openradar.me/34308893)

# Getting Started

See example

## Basic usage
 Create items
 ```swift
 let item1 = CollectionItem<CollectionCell>(item: "hello!")
 let item2 = CollectionItem<CollectionCell>(item: "im")
 let item3 = CollectionItem<CollectionCell>(item: "ColletionKit")
 let item4 = CollectionItem<ImageCell>(item: "greeting.png")
 ```

 Create section and put items in section
 ```swift
 let section = CollectionSection()
 ```

 Setup collection view
 ```swift
let collectionDirector = CollectionDirector(colletionView: self.collectionView)
let items = [item1, item2, item3, item4]
section += items
director += section
 ```

## Cell configuration
Cell must implement `ConfigurableCollectionCell` protocol. You need to specify cell size and configure methods:
```swift
extension CollectionCell : ConfigurableCollectionItem {
    static func estimatedSize(item: String?, collectionViewSize: CGSize) -> CGSize {
        return CGSize(width: collectionViewSize.width, height: 50)
    }

    func configure(item: String) {
        textLabel.text = item
    }
}
```

## Actions
Implement such actions like `didSelectItem` or `shouldHighlightItem` using functional syntax
```swift
let row = CollectionItem<CollectionCell>(item: "text")
    .onSelect({ (_) in
        print("i was tapped!")
    }).onDisplay({ (_) in
        print("i was displayed")
    })
```
Available actions:
- `onSelect`
- `onDeselect`
- `onDisplay`
- `onEndDisplay`
- `onHighlight`
- `onUnighlight`

## Section configuration
You can setup inter item spacing, line spacing and section insets using section object:
```swift
let section = CollectionSection()
section.minimumInterItemSpacing = 2
section.insetForSection = UIEdgeInsetsMake(0, 20, 0, 20)
section.lineSpacing = 2
```

## Updating
You can update collection view only by operating with section and item objects without any `IndexPath` mess: put usual operations in `performUpdates` block
```swift
self.director.performUpdates { [unowned self] in
    self.section.append(item: row)
    self.section.insert(item: row, at: 0)
    self.section.remove(item: item)
}
```

## Custom sections
You can provide your own section implementations using `AbstractCollectionSection` protocol. For example, you can use it for using `CollectionDirector` with `Realm.Results` and save `Results` lazy behaviour or implementing expandable sections
