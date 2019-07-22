import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text field widget that only allows integes
class NumberFormField extends StatefulWidget {
  final FormFieldValidator<int> validator;
  final FormFieldSetter<int> onSaved;
  final String noNumberMessage;
  final InputDecoration decoration;

  static const String DEFAULT_NO_NUMBER_MESSAGE = "Please enter a valid number";

  NumberFormField({
    this.decoration = const InputDecoration(),
    this.validator,
    this.onSaved,
    this.noNumberMessage = DEFAULT_NO_NUMBER_MESSAGE,
  });

  @override
  _NumberFormFieldState createState() => _NumberFormFieldState();
}

class _NumberFormFieldState extends State<NumberFormField> {
  /// Determines whether the given [value] is an integer.
  bool _isInt(String value) {
    try {
      return (value.isNotEmpty && int.parse(value) != null);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: widget.decoration.copyWith(counterText: ''),
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
      maxLength: 18,
      maxLengthEnforced: true,
      validator: (String value) {
        if (!_isInt(value))
          return widget.noNumberMessage ??
              NumberFormField.DEFAULT_NO_NUMBER_MESSAGE;
        if (widget.validator != null) return widget.validator(int.parse(value));
      },
      onSaved: (String value) {
        if (_isInt(value) && widget.onSaved != null)
          widget.onSaved(int.parse(value));
      },
    );
  }
}
