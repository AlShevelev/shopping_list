
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppinglist/dto/MenuActions.dart';
import 'package:shoppinglist/dto/ShoppingItem.dart';
import 'package:shoppinglist/dto/SuggestionItem.dart';
import 'package:shoppinglist/model/collections/ItemsCollection.dart';
import 'package:shoppinglist/model/collections/ShoppingCompletedItemsCollection.dart';
import 'package:shoppinglist/model/collections/ShoppingItemsCollection.dart';
import 'package:shoppinglist/model/data_storage/SharedPreferencesDataStorage.dart';
import 'package:shoppinglist/shared/helpers/AlertDialogs.dart';
import 'package:shoppinglist/shared/localization/AppLocalizations.dart';

import '../model/collections/SuggestionsCollection.dart';

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

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.builder(
      itemCount: _items.length + _completedItems.length,
      itemBuilder: (context, index) {
        if (index < _items.length) {
          return _buildListItem(index, _items[index].text);
        } else {
          int completedIndex = index - _items.length;
          return _buildCompletedListItem(
              completedIndex, _completedItems[completedIndex].text);
        }
      },
    );
  }
  
  // Build a single todo item
  Widget _buildListItem(int itemIndex, String todoText) {
    return new CheckboxListTile(
        value: false,
        controlAffinity: ListTileControlAffinity.leading,
        title: new Text(todoText),
        onChanged: (newValue) => _completeItem(itemIndex)
    );
  }
  
  // Build a single completed todo item
  Widget _buildCompletedListItem(int itemIndex, String todoText) {
    return new CheckboxListTile(
      value: true,
      controlAffinity: ListTileControlAffinity.leading,
      title: new Text(
        todoText,
        style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)
      ),
      onChanged: (newValue) => _uncompleteItem(itemIndex),
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
                        return _suggestions.get(pattern).map((v) => v.text).toList();
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