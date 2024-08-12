import 'package:flutter_bloc/flutter_bloc.dart';

/// [TextEvent]
/// -------------
/// The abstract class representing events for the TextBloc.
abstract class TextEvent {}

/// [TextFetched]
/// -------------
/// Event to fetch the texts.
class TextFetched extends TextEvent {}

/// [Text1Selected]
/// -------------
/// Event triggered when Text 1 is selected.
class Text1Selected extends TextEvent {}

/// [Text2Selected]
/// -------------
/// Event triggered when Text 2 is selected.
class Text2Selected extends TextEvent {}

/// [TextState]
/// -------------
/// The abstract class representing the state of the text.
abstract class TextState {}

/// [TextLoadInProgress]
/// -------------
/// State representing that the text is currently loading.
class TextLoadInProgress extends TextState {}

/// [TextLoadSuccess]
/// -------------
/// State representing that the text has loaded successfully.
class TextLoadSuccess extends TextState {
  final String text1;
  final String text2;
  final bool isText2Selected;

  TextLoadSuccess({
    required this.text1,
    required this.text2,
    this.isText2Selected = false,
  });
}

/// [TextLoadFailure]
/// -------------
/// State representing that the text loading has failed.
class TextLoadFailure extends TextState {}

/// [TextBloc]
/// -------------
/// The BLoC class to handle text-related events and states.
class TextBloc extends Bloc<TextEvent, TextState> {
  TextBloc() : super(TextLoadInProgress()) {
    on<TextFetched>(_onTextFetched);
    on<Text1Selected>(_onText1Selected);
    on<Text2Selected>(_onText2Selected);
  }

  /// [_onTextFetched]
  /// -------------
  /// Handles the `TextFetched` event, fetching the texts and updating the state.
  Future<void> _onTextFetched(TextFetched event, Emitter<TextState> emit) async {
    emit(TextLoadInProgress());
    try {
      final String text1 = List.generate(
        50,
        (index) => 'This is line $index of text 1.',
      ).join('\n');

      final String text2 = List.generate(
        50,
        (index) => 'This is line $index of text 2.',
      ).join('\n');

      emit(TextLoadSuccess(text1: text1, text2: text2));
    } catch (_) {
      emit(TextLoadFailure());
    }
  }

  /// [_onText1Selected]
  /// -------------
  /// Handles the `Text1Selected` event, setting the selected text to Text 1.
  void _onText1Selected(Text1Selected event, Emitter<TextState> emit) {
    final TextState currentState = state;
    if (currentState is TextLoadSuccess) {
      emit(TextLoadSuccess(
        text1: currentState.text1,
        text2: currentState.text2,
        isText2Selected: false,
      ));
    }
  }

  /// [_onText2Selected]
  /// -------------
  /// Handles the `Text2Selected` event, setting the selected text to Text 2.
  void _onText2Selected(Text2Selected event, Emitter<TextState> emit) {
    final TextState currentState = state;
    if (currentState is TextLoadSuccess) {
      emit(TextLoadSuccess(
        text1: currentState.text1,
        text2: currentState.text2,
        isText2Selected: true,
      ));
    }
  }
}
