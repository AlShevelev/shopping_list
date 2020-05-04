part of view;

class TodoList extends StatefulWidget {
  TodoList({Key key}) : super(key: key);
  
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  
  SuggestionsCollection _suggestions = SuggestionsCollection(SharedPreferencesDataStorage());
  FocusNode _keyboardFocusNode = FocusNode();
  
  ItemsCollection _items;
  ItemsCollection _completedItems;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  void _loadData() async {
    setState(() {
      _items = ShoppingItemsCollection(SharedPreferencesDataStorage());
      _completedItems = ShoppingCompletedItemsCollection(SharedPreferencesDataStorage());
    });
  }
 
  TextEditingController inputController = new TextEditingController();
  
  void _addItem(BuildContext context) async {
    String item = inputController.text;
    if (item.length > 0) {
      await _items.add(ShoppingItem(item));
      await _suggestions.add(SuggestionItem(item));
      
      setState(() {
        inputController.text = "";    // Reset input
      });
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).fabButtonHint,
      );
    }
  }
  
  void _completeItem(int index) async {
    await _completedItems.addToStart(await _items.removeAt(index));
    setState(() { });
  }
  
  void _uncompleteItem(int index) async {
    await _items.add(await _completedItems.removeAt(index));
    setState(() { });
  }
  
  void _clearCompleted(BuildContext context) {
    if (_completedItems.length > 0) {
      showConfirmationDialog(
          context: context,
          acceptAction: _processClearCompleted,
          text: AppLocalizations.of(context).menuClearCompletedQuery
      );
    } else {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context).menuClearCompletedHint
      );
    }
  }
  
  void _processClearCompleted() async {
    if(_completedItems.isNotEmpty) {
      await _completedItems.clear();
      setState(() { });
    }
  }

  void _clearAll(BuildContext context) {
    showConfirmationDialog(
      context: context,
      acceptAction: _processClearAll,
      text: AppLocalizations.of(context).menuClearAllQuery
    );
  }
  
  void _processClearAll() async {
    if (_completedItems.isNotEmpty) {
      await _completedItems.clear();
      setState(() { });
    }
  
    if(_items.isNotEmpty) {
      await _items.clear();
      setState(() { });
    }
  }

  void _clearSuggestions(BuildContext context) {
    showConfirmationDialog(
        context: context,
        acceptAction: (() async { await _suggestions.clear(); }),
        text: AppLocalizations.of(context).menuClearAutocompleteSuggestionsQuery
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).homePageTitle),
          actions: <Widget>[
            PopupMenu(
              clearSuggestions: _clearSuggestions,
              clearCompleted: _clearCompleted,
              clearAll: _clearAll,
            )
          ]),
      body: Stack(
        children: <Widget>[
          Container(
            child: ShoppingList(_items, _completedItems, _completeItem, _uncompleteItem),
            padding: EdgeInsets.only(bottom: 60),
          ),
          Positioned(
              bottom: 0.0,
              width: MediaQuery.of(context).size.width, // width 100%
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,                                  // Input field
                  ),
                  child: InputField(
                    inputController: inputController,
                    keyboardFocusNode: _keyboardFocusNode,
                    addItem: _addItem,
                    suggestions: _suggestions,
                  ))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(context),
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}