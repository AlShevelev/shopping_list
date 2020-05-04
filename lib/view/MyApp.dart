library view;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shoppinglist/shared/localization/AppLocalizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppinglist/dto/CollectionItem.dart';
import 'package:shoppinglist/model/collections/ItemsCollection.dart';
import 'package:shoppinglist/model/data_storage/DataStorage.dart';
import 'package:shoppinglist/shared/helpers/AlertDialogs.dart';

part 'TodoList.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [Locale("en"), Locale("ru")],
      onGenerateTitle: (context) => AppLocalizations.of(context).title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TodoList(),
    );
  }
}
