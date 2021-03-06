import 'dart:io';

import 'package:farmers_market/src/blocs/auth_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(context),
      );
    } else {
      return Scaffold(
        body: pageBody(context),
      );
    }
  }

  Widget pageBody(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    return Center(
      child: (Platform.isIOS)
          ? CupertinoButton(
              child: Text('LogOut'),
              onPressed: () => authBloc.logout(),
            )
          : FlatButton(
              onPressed: () => authBloc.logout(), child: Text('LogOut')),
    );
  }
}
