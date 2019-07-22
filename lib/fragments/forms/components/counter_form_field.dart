import 'package:flutter/material.dart';

/// A form field holding an integer with buttons to increment and decrement the
/// value stored in the field.
class CounterFormField extends FormField<int> {
  CounterFormField({
    Key key,
    FormFieldSetter<int> onSaved,
    FormFieldValidator<int> validator,
    int initialValue = 0,
    bool autovalidate = false,
    bool enabled = true,
    String title,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            enabled: enabled,
            builder: (FormFieldState<int> state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        title ?? "",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.red,
                            iconSize: 28.0,
                            onPressed: () {
                              state.didChange(state.value - 1);
                            },
                          ),
                          Text(state.value.toString()),
                          IconButton(
                            icon: Icon(Icons.add_circle),
                            color: Colors.lightGreen,
                            iconSize: 28.0,
                            onPressed: () {
                              state.didChange(state.value + 1);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        )
                      : Container()
                ],
              );
            });

  @override
  _CounterFormFieldState createState() => _CounterFormFieldState();
}

class _CounterFormFieldState extends FormFieldState<int> {}
