part of collection_items;

class ShoppingItemsCollection extends ItemsCollectionBase<ShoppingItem> {
  static const _STORAGE_KEY = "SHOPPING_ITEMS";
  
  ShoppingItemsCollection(DataStorage dataStorage) : super(dataStorage);

  @override
  String getStorageKey() {
    return _STORAGE_KEY;
  }

  @override
  ShoppingItem createFromString(String text) {
    return ShoppingItem(text);
  }
}