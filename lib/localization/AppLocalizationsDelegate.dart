import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'AppLocalizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
    const AppLocalizationsDelegate();
    
    @override
    bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);
    
    @override
    Future<AppLocalizations> load(Locale locale) {
        return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
    }
    
    @override
    bool shouldReload(AppLocalizationsDelegate old) => true;
}