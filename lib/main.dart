import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_switch.dart';
import 'switch_bloc.dart';
import 'text_bloc.dart';

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
    const double opacity = 0.58;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAC9D71).withOpacity(opacity),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white), // Change the icon color to white
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(''),
            BlocBuilder<TextBloc, TextState>(
              builder: (context, state) {
                if (state is TextLoadSuccess) {
                  return const CustomSwitch();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      drawer: BlocBuilder<TextBloc, TextState>(
        builder: (context, state) {
          final isText1Selected = state is TextLoadSuccess && !state.isText2Selected;
          final isText2Selected = state is TextLoadSuccess && state.isText2Selected;

          return Drawer(
            child: Container(
              color: Colors.white, // Set the drawer background color to white
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isText1Selected
                            ? const Color(0xFFAC9D71).withOpacity(1)
                            : const Color(0xFFAC9D71).withOpacity(0.42),
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
                        backgroundColor: isText2Selected
                            ? const Color(0xFFAC9D71).withOpacity(1)
                            : const Color(0xFFAC9D71).withOpacity(0.42),
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
          );
        },
      ),
      body: BlocBuilder<TextBloc, TextState>(
        builder: (context, state) {
          if (state is TextLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TextLoadSuccess) {
            const textStyle = TextStyle(fontSize: 16);
            const headlineStyle = TextStyle(fontSize: 36, fontWeight: FontWeight.bold);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: state.isText2Selected ? 'Headline 2\n\n' : 'Headline 1\n\n',
                      style: headlineStyle,
                    ),
                    TextSpan(
                      text: state.isText2Selected ? state.text2 : state.text1,
                      style: textStyle,
                    ),
                  ],
                ),
              ),
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
