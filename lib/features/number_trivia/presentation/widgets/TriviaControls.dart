import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/numbertrivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //* TextBox
        Container(
          height: 60,
          child: TextField(
            controller: this.controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input a Number',
            ),
            onChanged: (val) {
              this.inputString = val;
            },
            onSubmitted: (_) {
              _dispatchConcrete();
            },
          ),
        ),

        //* Buttons
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text('Search'),
                  color: Theme.of(context).accentColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: _dispatchConcrete,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
              ),
              Expanded(
                child: RaisedButton(
                  child: Text('Get Random Trivia'),
                  color: Theme.of(context).primaryColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: _dispatchRandom,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumbertriviaBloc>(context).dispatch(
      GetTriviaForConcreteNumber(this.inputString),
    );
  }

  void _dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumbertriviaBloc>(context).dispatch(
      GetTriviaForRandomNumber(),
    );
  }
}

