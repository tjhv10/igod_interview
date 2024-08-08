import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class SwitchEvent {}

class ToggleSwitch extends SwitchEvent {}

// States
abstract class SwitchState {
  final bool isSwitched;
  final String text;

  SwitchState(this.isSwitched, this.text);
}

class SwitchOnState extends SwitchState {
  SwitchOnState() : super(true, "Text 2");
}

class SwitchOffState extends SwitchState {
  SwitchOffState() : super(false, "Text 1");
}

// BLoC
class SwitchBloc extends Bloc<SwitchEvent, SwitchState> {
  SwitchBloc() : super(SwitchOffState()) {
    on<ToggleSwitch>((event, emit) {
      if (state.isSwitched) {
        emit(SwitchOffState());
      } else {
        emit(SwitchOnState());
      }
    });
  }
}
