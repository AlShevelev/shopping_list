
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppinglist/dto/MenuActions.dart';
import 'package:shoppinglist/helpers/AlertDialogs.dart';
import 'package:shoppinglist/localization/AppLocalizations.dart';

import '../suggestions.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key}) : super(key: key);
  
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> _items = [];
  List<String> _completedItems = [];
  
  Suggestions _suggestions = Suggestions();
  FocusNode _keyboardFocusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _items = prefs.getStringList("items") ?? [];
      _completedItems = prefs.getStringList("completedItems") ?? [];
    });
  }
  
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("items", _items);
    prefs.setStringList("completedItems", _completedItems);
  }
  
  TextEditingController inputController = new TextEditingController();
  void _addItem(BuildContext context) {
    String item = inputController.text;
    if (item.length > 0) {
      setState(() {
        _items.add(item);
        _suggestions.add(item);
        
        // Reset input
        inputController.text = "";
      });
      _saveData();
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).fabButtonHint,
      );
    }
  }
  
  void _completeItem(int index) {
    setState(() {
      _completedItems.insert(0, _items.removeAt(index));
    });
    _saveData();
  }
  
  void _uncompleteItem(int index) {
    setState(() {
      _items.add(_completedItems.removeAt(index));
    });
    _saveData();
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
  
  void _processClearCompleted() {
    setState(() {
      _completedItems.clear();
    });
    _saveData();
  }

  void _clearAll(BuildContext context) {
    showConfirmationDialog(
      context: context,
      acceptAction: _processClearAll,
      text: AppLocalizations.of(context).menuClearAllQuery
    );
  }
  
  void _processClearAll() {
    bool cleared = false;
    if (_completedItems.isNotEmpty) {
      setState(() {
        _completedItems.clear();
      });
      cleared = true;
    }
  
    if(_items.isNotEmpty) {
      setState(() {
        _items.clear();
      });
      cleared = true;
    }
  
    if(cleared) {
      _saveData();
    }
  }

  void _clearSuggestions(BuildContext context) {
    showConfirmationDialog(
        context: context,
        acceptAction: () => _suggestions.clear(),
        text: AppLocalizations.of(context).menuClearAutocompleteSuggestionsQuery
    );
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.builder(
      itemCount: _items.length + _completedItems.length,
      itemBuilder: (context, index) {
        if (index < _items.length) {
          return _buildListItem(index, _items[index]);
        } else {
          int completedIndex = index - _items.length;
          return _buildCompletedListItem(
              completedIndex, _completedItems[completedIndex]);
        }
      },
    );
  }
  
  // Build a single todo item
  Widget _buildListItem(int itemIndex, String todoText) {
    return new ListTile(
        title: new Text(todoText), onTap: () => _completeItem(itemIndex));
  }
  
  // Build a single completed todo item
  Widget _buildCompletedListItem(int itemIndex, String todoText) {
    return new ListTile(
      title: new Text(
        todoText,
        style: TextStyle(
            color: Colors.grey, decoration: TextDecoration.lineThrough),
      ),
      onTap: () => _uncompleteItem(itemIndex),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).homePageTitle),
          actions: <Widget>[
            PopupMenuButton<MenuActions>(
              onSelected: (MenuActions action) {
                switch (action) {
                  case MenuActions.CLEAR_SUGGESTIONS: _clearSuggestions(context); break;
                  case MenuActions.CLEAR_COMPLETED: _clearCompleted(context); break;
                  case MenuActions.CLEAR_ALL: _clearAll(context); break;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<MenuActions>(
                    child: Text(AppLocalizations.of(context).menuClearAutocompleteSuggestions),
                    value: MenuActions.CLEAR_SUGGESTIONS,
                  ),
                  PopupMenuItem<MenuActions>(
                    child: Text(AppLocalizations.of(context).menuClearCompleted),
                    value: MenuActions.CLEAR_COMPLETED,
                  ),
                  PopupMenuItem<MenuActions>(
                    child: Text(AppLocalizations.of(context).menuClearAll),
                    value: MenuActions.CLEAR_ALL,
                  ),
                ];
              },
            )
          ]),
      body: Stack(
        children: <Widget>[
          Container(
            child: _buildTodoList(),
            padding: EdgeInsets.only(bottom: 60),
          ),
          Positioned(
              bottom: 0.0,
              width: MediaQuery.of(context).size.width, // width 100%
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,                                  // Input field
                  ),
                  child: TypeAheadField(                                // Suggestions list
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: inputController,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (dynamic x) => _addItem(context),
                      autofocus: true,
                      focusNode: _keyboardFocusNode,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).newItemHint,
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black26,
                          )
                        )
                      ),
                    ),
                    suggestionsBoxVerticalOffset: 0,
                    direction: AxisDirection.up,
                    hideOnEmpty: true,
                    suggestionsCallback: (pattern) {
                      if (pattern.length > 0) {
                        return _suggestions.get(pattern);
                      } else {
                        return [];
                      }
                    },
                    debounceDuration: Duration(milliseconds: 100),
                    itemBuilder: (context, suggestion) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                            )
                          ]
                        ),
                        child: ListTile(
                          title: Text(
                            suggestion
                          ),
                        ),
                      );
                    },
                    transitionBuilder:
                        (context, suggestionsBox, animationController) =>
                    suggestionsBox, // no animation
                    onSuggestionSelected: (suggestion) {
                      inputController.text = suggestion;
                      _addItem(context);
                      if (!_keyboardFocusNode.hasFocus) {
                        FocusScope.of(context).requestFocus(_keyboardFocusNode);
                      }
                    },
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