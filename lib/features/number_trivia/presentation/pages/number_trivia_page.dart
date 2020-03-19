import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/numbertrivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTrivaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: Drawer(),
      appBar: AppBarDesign(),
      
      body: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  BlocProvider<NumbertriviaBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      builder: (context) => sl<NumbertriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              //* Top Half
              BlocBuilder<NumbertriviaBloc, NumbertriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return EmptyStateDisplay(
                      message: 'Start Searching',
                    );
                  } else if (state is Loading) {
                    return LoadingStateDisplay();
                  } else if (state is Loaded) {
                    return LoadedStateDisplay(numberTrivia: state.numberTrivia);
                  } else if (state is Error) {
                    return EmptyStateDisplay(
                      message: state.message,
                    );
                  }
                },
              ),

              //* Bottom Half
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}

