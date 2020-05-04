library dto;

part 'MenuActions.dart';
part 'ShoppingItem.dart';
part 'SuggestionItem.dart';

abstract class CollectionItem {
  final String text;

  CollectionItem(this.text);
}