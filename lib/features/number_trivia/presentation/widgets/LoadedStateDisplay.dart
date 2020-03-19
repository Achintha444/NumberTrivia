import 'package:flutter/material.dart';

import '../../domain/entities/NumberTrivia.dart';

class LoadedStateDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const LoadedStateDisplay({Key key, @required this.numberTrivia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      height: (MediaQuery.of(context).size.height) / 2,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              numberTrivia.getNumber.toString(),
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  this.numberTrivia.getText,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

