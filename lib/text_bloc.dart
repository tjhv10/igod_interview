import 'package:flutter_bloc/flutter_bloc.dart';

// Text Events
abstract class TextEvent {}

class TextFetched extends TextEvent {}

class Text1Selected extends TextEvent {}

class Text2Selected extends TextEvent {}

// Text States
abstract class TextState {}

class TextLoadInProgress extends TextState {}

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

class TextLoadFailure extends TextState {}

// TextBloc
class TextBloc extends Bloc<TextEvent, TextState> {
  TextBloc() : super(TextLoadInProgress()) {
    on<TextFetched>(_onTextFetched);
    on<Text1Selected>(_onText1Selected);
    on<Text2Selected>(_onText2Selected);
  }

  Future<void> _onTextFetched(TextFetched event, Emitter<TextState> emit) async {
    emit(TextLoadInProgress());
    try {
      // Replace this with actual data fetching logic
      final text1 = 'Headline 1\n\n${List.generate(100, (index) => 'This is line $index of text 1.').join('\n')}';
      final text2 = 'Headline 2\n\n${List.generate(100, (index) => 'This is line $index of text 2.').join('\n')}';

      emit(TextLoadSuccess(text1: text1, text2: text2));
    } catch (_) {
      emit(TextLoadFailure());
    }
  }

  void _onText1Selected(Text1Selected event, Emitter<TextState> emit) {
    final currentState = state;
    if (currentState is TextLoadSuccess) {
      emit(TextLoadSuccess(
        text1: currentState.text1,
        text2: currentState.text2,
        isText2Selected: false,
      ));
    }
  }

  void _onText2Selected(Text2Selected event, Emitter<TextState> emit) {
    final currentState = state;
    if (currentState is TextLoadSuccess) {
      emit(TextLoadSuccess(
        text1: currentState.text1,
        text2: currentState.text2,
        isText2Selected: true,
      ));
    }
  }
}
