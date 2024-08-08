// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: BlocProvider(
//         create: (context) => TextBloc()..add(TextFetched()),
//         child: const MyHomePage(),
//       ),
//     );
//   }
// }

// // The Home Page Widget
// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFAC9D71).withOpacity(0.58),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(''), // You can replace this with your app title
//             BlocBuilder<TextBloc, TextState>(
//               builder: (context, state) {
//                 if (state is TextLoadSuccess) {
//                   bool isSwitched = state.isText2Selected;
//                   return Switch(
                    
//                     value: isSwitched,
//                     onChanged: (value) {
//                       context.read<TextBloc>().add(value ? Text2Selected() : Text1Selected());
//                     },
//                     activeTrackColor: Colors.white,
//                     activeColor: const Color(0xFFAC9D71).withOpacity(0.58),

//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ],
//         ),
//       ),
//       drawer: Drawer(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFAC9D71).withOpacity(0.58),
//                   shape: const CircleBorder(),
//                   padding: const EdgeInsets.all(50),
//                 ),
//                 child: const Text('1', style: TextStyle(fontSize: 48, color: Colors.white)),
//                 onPressed: () {
//                   context.read<TextBloc>().add(Text1Selected());
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFAC9D71),
//                   shape: const CircleBorder(),
//                   padding: const EdgeInsets.all(50),
//                 ),
//                 child: const Text('2', style: TextStyle(fontSize: 48, color: Colors.white)),
//                 onPressed: () {
//                   context.read<TextBloc>().add(Text2Selected());
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: BlocBuilder<TextBloc, TextState>(
//         builder: (context, state) {
//           if (state is TextLoadInProgress) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is TextLoadSuccess) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(state.isText2Selected ? state.text2 : state.text1),
//             );
//           } else if (state is TextLoadFailure) {
//             return const Center(child: Text('Failed to load texts'));
//           } else {
//             return const Center(child: Text('Unexpected error'));
//           }
//         },
//       ),
//     );
//   }
// }

// // Text Events
// abstract class TextEvent {}

// class TextFetched extends TextEvent {}

// class Text1Selected extends TextEvent {}

// class Text2Selected extends TextEvent {}

// // Text States
// abstract class TextState {}

// class TextLoadInProgress extends TextState {}

// class TextLoadSuccess extends TextState {
//   final String text1;
//   final String text2;
//   final bool isText2Selected;

//   TextLoadSuccess({required this.text1, required this.text2, this.isText2Selected = false});
// }

// class TextLoadFailure extends TextState {}

// // TextBloc
// class TextBloc extends Bloc<TextEvent, TextState> {
//   TextBloc() : super(TextLoadInProgress()) {
//     on<TextFetched>(_onTextFetched);
//     on<Text1Selected>(_onText1Selected);
//     on<Text2Selected>(_onText2Selected);
//   }

//   Future<void> _onTextFetched(TextFetched event, Emitter<TextState> emit) async {
//     emit(TextLoadInProgress());
//     try {
//       final response = await http.get(Uri.parse('https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml'));
//       if (response.statusCode == 200) {
        
//         // Generate long texts with headlines
//         final text1 = 'Headline 1\n\n${List.generate(100, (index) => 'This is line $index of text 1.').join('\n')}';
//         final text2 = 'Headline 2\n\n${List.generate(100, (index) => 'This is line $index of text 2.').join('\n')}';

//         emit(TextLoadSuccess(text1: text1, text2: text2));
//       } else {
//         emit(TextLoadFailure());
//       }
//     } catch (_) {
//       emit(TextLoadFailure());
//     }
//   }

//   void _onText1Selected(Text1Selected event, Emitter<TextState> emit) {
//     final currentState = state;
//     if (currentState is TextLoadSuccess) {
//       emit(TextLoadSuccess(text1: currentState.text1, text2: currentState.text2, isText2Selected: false));
//     }
//   }

//   void _onText2Selected(Text2Selected event, Emitter<TextState> emit) {
//     final currentState = state;
//     if (currentState is TextLoadSuccess) {
//       emit(TextLoadSuccess(text1: currentState.text1, text2: currentState.text2, isText2Selected: true));
//     }
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'switch_bloc.dart'; // Import the BLoC file

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BlocProvider(
//         create: (context) => SwitchBloc(),
//         chiךd: SwitchWithText(),
//       ),
//     );
//   }
// }

// class SwitchWithText extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Switch with Text Inside using BLoC'),
//       ),
//       body: Center(
//         child: BlocBuilder<SwitchBloc, SwitchState>(
//           builder: (context, state) {
//             return GestureDetector(
//               onTap: () {
//                 context.read<SwitchBloc>().add(ToggleSwitch());
//               },
//               child: Container(
//                 width: 120,
//                 height: 25,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25.0),
//                   color: state.isSwitched ? Colors.white : Colors.white,
//                 ),
//                 child: Stack(
//                   children: [
//                     AnimatedAlign(
//                       duration: Duration(milliseconds: 250),
//                       alignment: state.isSwitched
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         child: Container(
//                           width: 23,
//                           height: 23,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: const Color(0xFFAC9D71).withOpacity(0.58),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Center(
//                       child: Text(
//                         state.text,
//                         style: TextStyle(
//                           color: state.isSwitched ? const Color(0xFFAC9D71).withOpacity(0.58) : const Color(0xFFAC9D71).withOpacity(0.58),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_switch.dart'; // Import the custom switch widget
import 'switch_bloc.dart'; // Import the SwitchBloc file
import 'text_bloc.dart'; // Import the TextBloc file

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
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TextBloc>(
            create: (context) => TextBloc()..add(TextFetched()),
          ),
          BlocProvider<SwitchBloc>(
            create: (context) => SwitchBloc(),
          ),
        ],
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
        backgroundColor: const Color(0xFFAC9D71).withOpacity(0.58),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(''), // You can replace this with your app title
            BlocBuilder<TextBloc, TextState>(
              builder: (context, state) {
                if (state is TextLoadSuccess) {
                  return const CustomSwitch(); // Use the custom switch widget here
                }
                return const SizedBox.shrink();
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
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAC9D71).withOpacity(0.58),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(50),
                ),
                child: const Text('1', style: TextStyle(fontSize: 48, color: Colors.white)),
                onPressed: () {
                  context.read<TextBloc>().add(Text1Selected());
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAC9D71),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(50),
                ),
                child: const Text('2', style: TextStyle(fontSize: 48, color: Colors.white)),
                onPressed: () {
                  context.read<TextBloc>().add(Text2Selected());
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<TextBloc, TextState>(
        builder: (context, state) {
          if (state is TextLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TextLoadSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(state.isText2Selected ? state.text2 : state.text1),
            );
          } else if (state is TextLoadFailure) {
            return const Center(child: Text('Failed to load texts'));
          } else {
            return const Center(child: Text('Unexpected error'));
          }
        },
      ),
    );
  }
}

