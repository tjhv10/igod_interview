import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => TextBloc()..add(FetchTexts()),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAC9D71).withOpacity(0.42),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(''), // You can replace this with your app title
            BlocBuilder<TextBloc, TextState>(
              builder: (context, state) {
                bool isSwitched = state is Text2Selected;
                return Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    if (value) {
                      context.read<TextBloc>().add(ShowText2());
                    } else {
                      context.read<TextBloc>().add(ShowText1());
                    }
                  },
                  activeTrackColor: Colors.white,
                  activeColor: const Color(0xFFAC9D71).withOpacity(0.42),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAC9D71).withOpacity(0.42),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(64.0),
                ),
                child: const Text('1', style: TextStyle(fontSize: 24)),
                onPressed: () {
                  context.read<TextBloc>().add(ShowText1());
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAC9D71),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(64.0),
                ),
                child: const Text('2', style: TextStyle(fontSize: 24)),
                onPressed: () {
                  context.read<TextBloc>().add(ShowText2());
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<TextBloc, TextState>(
        builder: (context, state) {
          if (state is TextLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TextLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(state.currentText),
            );
          } else if (state is TextError) {
            return const Center(child: Text('Failed to load texts'));
          } else {
            return const Center(child: Text('Unexpected error'));
          }
        },
      ),
    );
  }
}

abstract class TextEvent {}

class FetchTexts extends TextEvent {}

class ShowText1 extends TextEvent {}

class ShowText2 extends TextEvent {}

abstract class TextState {}

class TextLoading extends TextState {}

class TextLoaded extends TextState {
  final String currentText;
  final String text1;
  final String text2;
  final bool isText1;

  TextLoaded({required this.currentText, required this.text1, required this.text2, required this.isText1});
}

class TextError extends TextState {}

class Text1Selected extends TextLoaded {
  Text1Selected({required super.currentText, required super.text1, required super.text2})
      : super(isText1: true);
}

class Text2Selected extends TextLoaded {
  Text2Selected({required super.currentText, required super.text1, required super.text2})
      : super(isText1: false);
}

class TextBloc extends Bloc<TextEvent, TextState> {
  TextBloc() : super(TextLoading()) { 
    on<FetchTexts>(_onFetchTexts);
    on<ShowText1>(_onShowText1);
    on<ShowText2>(_onShowText2);
  }

  Future<void> _onFetchTexts(FetchTexts event, Emitter<TextState> emit) async {
    emit(TextLoading());
    try {
      final response = await http.get(Uri.parse('https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml')); // Replace with a valid RSS feed URL
      if (response.statusCode == 200) {
        
        // Generate long texts with headlines
        final text1 = 'Headline 1\n\n${List.generate(100, (index) => 'This is line $index of text 1.').join('\n')}';
        final text2 = 'Headline 2\n\n${List.generate(100, (index) => 'This is line $index of text 2.').join('\n')}';

        emit(Text1Selected(currentText: text1, text1: text1, text2: text2));
      } else {
        emit(TextError());
      }
    } catch (e) {
      emit(TextError());
    }
  }

  void _onShowText1(ShowText1 event, Emitter<TextState> emit) {
    final currentState = state;
    if (currentState is TextLoaded) {
      emit(Text1Selected(currentText: currentState.text1, text1: currentState.text1, text2: currentState.text2));
    }
  }

  void _onShowText2(ShowText2 event, Emitter<TextState> emit) {
    final currentState = state;
    if (currentState is TextLoaded) {
      emit(Text2Selected(currentText: currentState.text2, text1: currentState.text1, text2: currentState.text2));
    }
  }
}
