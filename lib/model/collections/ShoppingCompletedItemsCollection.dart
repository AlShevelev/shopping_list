
import 'package:shoppinglist/dto/ShoppingItem.dart';
import 'package:shoppinglist/model/data_storage/DataStorage.dart';

import 'ItemsCollectionBase.dart';

class ShoppingCompletedItemsCollection extends ItemsCollectionBase<ShoppingItem> {
  static const _STORAGE_KEY = "SHOPPING_ITEMS_COMPLETED";
  
  ShoppingCompletedItemsCollection(DataStorage dataStorage) : super(dataStorage);
  
  @override
  String getStorageKey() {
    return _STORAGE_KEY;
  }

  @override
  ShoppingItem createFromString(String text) {
    return ShoppingItem(text);
  }
}