import 'package:flutter_bloc/flutter_bloc.dart';

/// [SwitchEvent]
/// -------------
/// The abstract class representing events for the SwitchBloc.
abstract class SwitchEvent {}

/// [ToggleSwitch]
/// -------------
/// Event to toggle the switch state.
class ToggleSwitch extends SwitchEvent {}

/// [SwitchState]
/// -------------
/// The abstract class representing the state of the switch.
abstract class SwitchState {
  final bool isSwitched;
  final String text;

  SwitchState(this.isSwitched, this.text);
}

/// [SwitchOnState]
/// -------------
/// State representing the switch being on.
class SwitchOnState extends SwitchState {
  SwitchOnState() : super(true, "Text 2");
}

/// [SwitchOffState]
/// -------------
/// State representing the switch being off.
class SwitchOffState extends SwitchState {
  SwitchOffState() : super(false, "Text 1");
}

/// [SwitchBloc]
/// -------------
/// The BLoC class to handle switch-related events and states.
class SwitchBloc extends Bloc<SwitchEvent, SwitchState> {
  SwitchBloc() : super(SwitchOffState()) {
    on<ToggleSwitch>(_onToggleSwitch);
  }

  /// [_onToggleSwitch]
  /// -------------
  /// Handles the `ToggleSwitch` event, toggling the switch state.
  void _onToggleSwitch(ToggleSwitch event, Emitter<SwitchState> emit) {
    if (state.isSwitched) {
      emit(SwitchOffState());
    } else {
      emit(SwitchOnState());
    }
  }
}
