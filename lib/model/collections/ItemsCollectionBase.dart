part of collection_items;

abstract class ItemsCollectionBase<T extends CollectionItem> implements ItemsCollection<T> {
  final DataStorage _dataStorage;

  List<T> items = [];
  
  int get length => items.length;

  bool get isNotEmpty => items.isNotEmpty;
  
  T operator [](int index) => items[index];

  ItemsCollectionBase(this._dataStorage) {
    _load(getStorageKey());
  }

  @override
  Future<void> add(T item) async {
    if (!items.contains(item)) {
      items.add(item);
      await _save(getStorageKey());
    }
  }

  @override
  Future<void> addToStart(T item) async {
    if (!items.contains(item)) {
      items.insert(0, item);
      await _save(getStorageKey());
    }
  }

  @override
  Future<T> removeAt(int index) async {
    T removedItem = items.removeAt(index);
    await _save(getStorageKey());
    return Future.value(removedItem);
  }

  @override
  Future<void> clear() async {
    items.clear();
    await _save(getStorageKey());
  }

  void _load(String storageKey) async {
    items = await _dataStorage
        .loadStringsList(storageKey)
        .then((list) => list.map((v) => createFromString(v)).toList());
  }

  Future<void> _save(String storageKey) async {
    await _dataStorage.saveStringsList(storageKey, items.map((v) => v.text).toList());
  }
  
  String getStorageKey();
  
  T createFromString(String text);
}