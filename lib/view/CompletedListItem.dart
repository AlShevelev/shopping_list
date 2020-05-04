part of view;

class CompletedListItem extends ListItem {
  CompletedListItem(itemIndex, text, onItemClick): super(itemIndex, text, onItemClick);
  
  @override
  Widget build(BuildContext context) {
    return new CheckboxListTile(
        value: true,
        controlAffinity: ListTileControlAffinity.leading,
        title: new Text(
            _text,
            style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)
        ),
        onChanged: (newValue) => _onItemClick(_itemIndex)
    );
  }
}