part of view;

class ShoppingList extends StatelessWidget {
  final ItemsCollection _items;
  final ItemsCollection _completedItems;
  final Function _onItemClick;
  final Function _onCompleteItemClick;
  
  ShoppingList(this._items, this._completedItems, this._onItemClick, this._onCompleteItemClick);
  
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: _items.length + _completedItems.length,
      itemBuilder: (context, index) {
        if (index < _items.length) {
          return ListItem(index, _items[index].text, _onItemClick);
        } else {
          int completedIndex = index - _items.length;
          return CompletedListItem(completedIndex, _completedItems[completedIndex].text, _onCompleteItemClick);
        }
      },
    );
  }
}