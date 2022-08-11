import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum ModeButton {
  Flat,
  Elevated,
  Bordered,
}

class CustomButton extends StatelessWidget {
  final String title;
  final ModeButton mode;
  final Function _onPressed;

  const CustomButton(this.title, this.mode, this._onPressed);

  Widget _customStyleText(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            color: mode == ModeButton.Flat
                ? null
                : Theme.of(context).colorScheme.primary,
            child: _customStyleText(title),
            onPressed: _onPressed,
          )
        : mode == ModeButton.Flat
            ? TextButton(
                onPressed: _onPressed,
                child: _customStyleText(title),
              )
            : mode == ModeButton.Elevated
                ? ElevatedButton(
                    child: _customStyleText(title),
                    onPressed: _onPressed,
                  )
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: _customStyleText(title),
                    onPressed: _onPressed,
                  );
    ;
  }
}
