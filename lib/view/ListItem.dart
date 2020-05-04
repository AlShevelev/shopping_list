part of view;

class ListItem extends StatelessWidget {
  final int _itemIndex;
  final String _text;
  final Function _onItemClick;

  ListItem(this._itemIndex, this._text, this._onItemClick);
  
  @override
  Widget build(BuildContext context) {
    return new CheckboxListTile(
        value: false,
        controlAffinity: ListTileControlAffinity.leading,
        title: new Text(_text),
        onChanged: (newValue) => _onItemClick(_itemIndex)
    );
  }
}