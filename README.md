# CollectionKit


Framework to manage complex `UICollectionView` in declarative way and very few lines of code.
Heavily inspired by https://github.com/maxsokolov/TableKit and https://github.com/Instagram/IGListKit


# WARNING

Development still in progress. Some changes may affect backward compatibility


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
Cell must implement `ConfigurableCollectionCell` protocol. You need to specify cell size and configure methods:
```swift
extension CollectionCell : ConfigurableCollectionItem {
    static func estimatedSize(item: String?, boundingSize: CGSize) -> CGSize {
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
