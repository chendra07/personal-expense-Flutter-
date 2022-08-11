import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final String title;
  final bool currentSwitch;
  final Function _switchHandler;

  const CustomSwitch(this.title, this.currentSwitch, this._switchHandler);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
        Switch.adaptive(
          activeColor: Theme.of(context).primaryColor,
          value: currentSwitch,
          onChanged: _switchHandler,
        )
      ],
    );
  }
}
