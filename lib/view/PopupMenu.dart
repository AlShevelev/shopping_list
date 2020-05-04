part of view;

class PopupMenu extends StatelessWidget {
  final Function clearSuggestions;
  final Function clearCompleted;
  final Function clearAll;

  PopupMenu({this.clearSuggestions, this.clearCompleted, this.clearAll});
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuActions>(
      onSelected: (MenuActions action) {
        switch (action) {
          case MenuActions.CLEAR_SUGGESTIONS: clearSuggestions(context); break;
          case MenuActions.CLEAR_COMPLETED: clearCompleted(context); break;
          case MenuActions.CLEAR_ALL: clearAll(context); break;
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
    );
  }
}