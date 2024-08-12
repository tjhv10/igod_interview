import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'text_bloc.dart';

/// [CustomSwitch]
/// --------------
/// A custom switch widget that toggles between two text states based on the 
/// current state of the [TextBloc].
///
/// This widget listens to [TextBloc] and updates the UI based on the 
/// [TextLoadSuccess] state. The switch changes its position and text when 
/// tapped, triggering [Text1Selected] or [Text2Selected] events in the bloc.
class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key});

  // Constant value for the opacity of the switch components.
  static const double _opacity = 0.58;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextBloc, TextState>(
      builder: (context, textState) {
        if (textState is TextLoadSuccess) {
          // Determine if the switch is toggled to the second text.
          final bool isSwitched = textState.isText2Selected;

          return GestureDetector(
            onTap: () {
              // Toggle the text selection state.
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
                  _buildAnimatedAlign(isSwitched),
                  _buildCenterText(isSwitched),
                ],
              ),
            ),
          );
        }

        // Return an empty widget if the state is not `TextLoadSuccess`.
        return const SizedBox.shrink();
      },
    );
  }

  /// [_buildAnimatedAlign]
  /// ---------------------
  /// Creates the animated alignment for the switch's circular handle.
  Widget _buildAnimatedAlign(bool isSwitched) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 250),
      alignment: isSwitched ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          width: 30,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFAC9D71).withOpacity(_opacity),
          ),
        ),
      ),
    );
  }

  /// [_buildCenterText]
  /// ------------------
  /// Creates the centered text inside the switch based on the selected state.
  Widget _buildCenterText(bool isSwitched) {
    return Center(
      child: Text(
        isSwitched ? 'Text 2' : 'Text 1',
        style: TextStyle(
          color: const Color(0xFFAC9D71).withOpacity(_opacity),
          fontSize: 10,
        ),
      ),
    );
  }
}
