library localization;

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

part 'AppLocalizationsDelegate.dart';

class AppLocalizations {
    AppLocalizations(this.locale);
    
    final Locale locale;
    
    static const _title = "title";
    static const _homePageTitle = "homePageTitle";
    static const _fabButtonHint = "fabButtonHint";

    static const _doIt = "doIt";
    static const _cancel = "cancel";

    static const _menuClearCompleted = "menuClearCompleted";
    static const _menuClearCompletedQuery = "menuClearCompletedQuery";
    static const _menuClearCompletedHint = "menuClearCompletedHint";
    static const _menuClearAutocompleteSuggestions = "menuClearAutocompleteSuggestions";
    static const _menuClearAutocompleteSuggestionsQuery = "menuClearAutocompleteSuggestionsQuery";
    static const _menuClearAll = "menuClearAll";
    static const _menuClearAllQuery = "menuClearAllQuery";

    static const _newItemHint = "newItemHint";

    static AppLocalizations of(BuildContext context) {
        return Localizations.of<AppLocalizations>(context, AppLocalizations);
    }
    
    static Map<String, Map<String, String>> _localizedValues = {
        "en": {
            _title: "Let\'s shopping! - a simple shopping list",
            _homePageTitle: "Shopping list",
            _fabButtonHint: "Add some text to add a new item",
            _doIt: "Do it!",
            _cancel: "Cancel",
            _menuClearCompleted: "Clear completed",
            _menuClearCompletedQuery: "Are you sure you want to remove all completed items?",
            _menuClearCompletedHint: "This will only clear completed entries. Tap an entry to mark it as completed.",
            _menuClearAutocompleteSuggestions: "Clear autocomplete hints",
            _menuClearAutocompleteSuggestionsQuery: "Are you sure you want to clear autocomplete hints?",
            _menuClearAll: "Clear all",
            _menuClearAllQuery: "Are you sure you want to clear the list?",
            _newItemHint: "New item..."
        },
        
        "ru": {
            _title: "В магазин! - простой список покупок",
            _homePageTitle: "Список покупок",
            _fabButtonHint: "Введите текст покупки, чтобы добавить его в список",
            _doIt: "Да!",
            _cancel: "Отмена",
            _menuClearCompleted: "Удалить завершенные покупки",
            _menuClearCompletedQuery: "Вы уверены, что хотите удалить все завершенные покупки?",
            _menuClearCompletedHint: "Нет завершенных покупок в списке - ничего не будет удалено",
            _menuClearAutocompleteSuggestions: "Очистить список подсказок",
            _menuClearAutocompleteSuggestionsQuery: "Вы уверены, что хотите очистить список подсказок?",
            _menuClearAll: "Удалить все",
            _menuClearAllQuery: "Вы уверены, что хотите очистить список?",
            _newItemHint: "Новая покупка..."
        },
    };

    String operator [](String code) => _localizedValues[locale.languageCode][code];
    
    String get title => this[_title];
    String get homePageTitle => this[_homePageTitle];
    String get fabButtonHint => this[_fabButtonHint];
    String get doIt => this[_doIt];
    String get cancel => this[_cancel];
    String get menuClearCompleted => this[_menuClearCompleted];
    String get menuClearCompletedQuery => this[_menuClearCompletedQuery];
    String get menuClearCompletedHint => this[_menuClearCompletedHint];
    String get menuClearAutocompleteSuggestions => this[_menuClearAutocompleteSuggestions];
    String get menuClearAutocompleteSuggestionsQuery => this[_menuClearAutocompleteSuggestionsQuery];
    String get menuClearAll => this[_menuClearAll];
    String get menuClearAllQuery => this[_menuClearAllQuery];
    String get newItemHint => this[_newItemHint];
}