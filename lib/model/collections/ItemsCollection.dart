library collection_items;

import 'package:shoppinglist/dto/CollectionItem.dart';
import 'package:shoppinglist/model/data_storage/DataStorage.dart';
import '../data_storage/DataStorage.dart';

part 'ItemsCollectionBase.dart';
part 'ShoppingCompletedItemsCollection.dart';
part 'ShoppingItemsCollection.dart';
part 'SuggestionsCollection.dart';

abstract class ItemsCollection<T extends CollectionItem> {
  int get length;
  
  bool get isNotEmpty;
  
  T operator [](int index);
  
  Future<void> add(T item) async {}
  
  Future<void> addToStart(T item) async {}
  
  // ignore: missing_return
  Future<T> removeAt(int index) async {}
  
  Future<void> clear() async {}
}