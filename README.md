# CollectionKit


Framework to manage complex `UICollectionView` in declarative way and very few lines of code.
Heavily inspired by https://github.com/maxsokolov/TableKit and https://github.com/Instagram/IGListKit


# WARNING

Development still in progress. Some changes may affect backward compatibility


# Installation
Via CocoaPods: `pod 'IVCollectionKit'`
Via Carthage `github "ivedeneev/CollectionKit"`
Via Swift Package Manager: `Coming soon`

# Features
 - [x] Declarative `UICollectionView` management
 - [x] No need to implement `UICollectionViewDataSource` and `UICollectionViewDelegate`
 - [x] Easy way to map your models into cells
 - [x] Auto diffing
 - [x] Supports cells & reusable views from code and xibs and storyboard
 - [x] Flexible
 - [x] Register cells and reusable views automatically
 - [x] Fix scroll indicator clipping at iOS11 (http://www.openradar.me/34308893)

# Getting Started

Key concepts of `CollectionKit` are `Section`, `Item` and `Director`. 
`Item` is responsible for `UICollectionViewCell` configuration, size and actions
`Section` is responsible for group of items and provides information for each item, header/footer and all kind of insets/margins: section insets, minimum inter item spacing and line spacing
`Director` is responsible for providing all information, needed for `UICollectionView` and its updations

## Basic usage

Setup UICollectionView and director: 

 Setup collection view
 ```swift
collectionView = UICollectionView(frame: view.bounds, colletionViewLayout: UICollectionViewFlowLayout())
collectionDirector = CollectionDirector(colletionView: collectionView)
 ```

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
 let items = [item1, item2, item3, item4]
section += items
director += section
 ```

 Put section in director and reload director
 ```swift
director += section
director.reload()
 ``` 

## Cell configuration
Cell must implement `ConfigurableCollectionCell` protocol. You need to specify cell size and configuration methods:
```swift
extension CollectionCell : ConfigurableCollectionItem {
    static func estimatedSize(item: String, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
        return CGSize(width: boundingSize.width - 40, height: 44)
    }

    func configure(item: String) {
        textLabel.text = item
    }
}

Note, that `contentInsets` value of collection view is respected in `boundingSize` parameter
```
### "Auto sizing cells"

Framework doesnt support auto-sizing cells, but you can adjust cell width and height to collection view dimensions

```swift
let item = CollectionItem<CollectionCell>(item: "text").adjustsWidth(true)
```

It means that width of this cell will be equal to `collectionView.bounds.width` minus collectionView content insets and section insets. width from `estimatedSize` method is ignored for this case. `adjustsHeight(Bool)` method has same logic, but for vertical insets.


### Cell actions
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
Also you can set section header and footer:
```swift
section.headerItem = CollectionHeaderFooterView<SectionHeader>(item: "This is header")
section.footerItem = CollectionHeaderFooterView<SectionHeader>(item: "This is f00ter")
```

## Updating & reloading

`IVCollectionKit` provides 2 ways for updatung `UICollectionView` content:
- reload (using `reloadData`)
- animated updates(using `performBatchUpdates`)

Note, that all models, that you use in `CollectionItem` initializations should conform `Hashable` protocol. Framework provides fallback for non-hashable models, but it may cause unexpected behaviour during animated updates.
```swift
director.performUpdates()
director.performUpdates { finished: Bool in
    print()
}
```

## Custom sections
You can provide your own section implementation using `AbstractCollectionSection` protocol. For example, you can use it for using `CollectionDirector` with `Realm.Results` and save `Results` lazy behaviour or implementing expandable sections (see exapmles). Also you can create subclass of `CollectionSection` if you dont need radically different behaviour 

## UIScrollViewDelegate
If you need to implement `UISrollViewDelegate` methods for your collection view (e.g pagination support) you can use `scrollDelegate` property

```swift
final class ViewController: UIViewController, UIScrollViewDelegate {
    var director: CollectionDirector!
    ...
    
    private func setupDirector() {
        director.scrollDelegate = self
    }
}
```
