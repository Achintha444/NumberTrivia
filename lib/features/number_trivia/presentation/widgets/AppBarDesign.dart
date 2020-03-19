import 'package:flutter/material.dart';

import '../constants/theme_data.dart';

class AppBarDesign extends StatelessWidget implements PreferredSizeWidget {

  static final AppBar appBar = new AppBar();

  const AppBarDesign({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Text(
          'Number Trivia'.toUpperCase(),
          style: mainTextStyle,
        ),
      ),
      backgroundColor: Colors.white,
      bottomOpacity: 0.0,
      elevation: 0.0,
      iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
      actions: <Widget>[
        new Container(
          width: 50.0,
          height: 50.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: new NetworkImage("https://i.imgur.com/BoN9kdC.png"),
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

}

