part of localization;

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