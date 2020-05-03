
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist/localization/AppLocalizations.dart';

void showConfirmationDialog({BuildContext context, Function acceptAction, String title, String text}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Widget titleWidget;
      if(title != null) {
        titleWidget = new Text(title);
      }
      
      return AlertDialog(
        title: titleWidget,
        content: new Text(text),
        actions: <Widget>[
          new FlatButton(
            child: new Text(AppLocalizations.of(context).doIt),
            onPressed: () {
              acceptAction();
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text(AppLocalizations.of(context).cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}