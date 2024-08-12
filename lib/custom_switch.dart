import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'switch_bloc.dart'; // Import the SwitchBloc file
import 'text_bloc.dart'; // Import the TextBloc file

/// [CustomSwitch]
/// -------------
/// A custom switch widget that toggles between two texts.
/// The widget responds to the state of the [TextBloc] and [SwitchBloc].
class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    const double opacity = 0.58;

    return BlocBuilder<TextBloc, TextState>(
      builder: (BuildContext context, TextState textState) {
        if (textState is TextLoadSuccess) {
          final bool isSwitched = textState.isText2Selected;

          return BlocBuilder<SwitchBloc, SwitchState>(
            builder: (BuildContext context, SwitchState switchState) {
              return GestureDetector(
                onTap: () {
                  context.read<TextBloc>().add(
                      isSwitched ? Text1Selected() : Text2Selected());
                },
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 250),
                        alignment: isSwitched
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            width: 30,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFAC9D71).withOpacity(opacity),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          isSwitched ? 'Text 2' : 'Text 1',
                          style: TextStyle(
                            color: const Color(0xFFAC9D71).withOpacity(opacity),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
