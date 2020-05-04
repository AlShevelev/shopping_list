part of collection_items;

class SuggestionsCollection extends ItemsCollectionBase<SuggestionItem> {
  static const _STORAGE_KEY = "SUGGESTIONS";
  
  int limit = 3;

  SuggestionsCollection(DataStorage dataStorage): super(dataStorage);

  // Get suggestions for a query
  List<SuggestionItem> get(String query) {
    return items
        .where((x) => x.text.toLowerCase().startsWith(query.toLowerCase()))
        .take(limit)
        .toList();
  }

  @override
  SuggestionItem createFromString(String text) {
    return SuggestionItem(text);
  }

  @override
  String getStorageKey() {
    return _STORAGE_KEY;
  }
}