# CollectionKit

Framework to manage complex `UICollectionView` in declarative way and very few lines of code.
 Heavily inspired by https://github.com/maxsokolov/TableKit

# Features
 - [x] Type-safe generic cells
 - [x] No need to implement `UICollectionViewDataSource` and `UICollectionViewDelegate`
 - [x] Easy way to map your models into cells
 - [x] Updating without `performBatchUpdates` or whatever
 - [x] Supports infinite feeds [soon]
 - [x] Supports cells from code and xibs and storyboard

# Getting Started

See example

# Basic usage
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
