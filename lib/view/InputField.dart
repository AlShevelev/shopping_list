part of view;

class InputField extends StatelessWidget {
  final TextEditingController inputController;
  final FocusNode keyboardFocusNode;
  final Function addItem;
  final SuggestionsCollection suggestions;
  
  InputField({this.inputController, this.keyboardFocusNode, this.addItem, this.suggestions});
  
  @override
  Widget build(BuildContext context) {
    return TypeAheadField(                                // Suggestions list
      textFieldConfiguration: TextFieldConfiguration(
        controller: inputController,
        textCapitalization: TextCapitalization.sentences,
        onSubmitted: (dynamic x) => addItem(context),
        autofocus: true,
        focusNode: keyboardFocusNode,
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
          return suggestions.get(pattern).map((v) => v.text).toList();
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
        addItem(context);
        if (!keyboardFocusNode.hasFocus) {
          FocusScope.of(context).requestFocus(keyboardFocusNode);
        }
      },
    );
  }
}