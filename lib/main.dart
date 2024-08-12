import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_switch.dart';
import 'switch_bloc.dart';
import 'text_bloc.dart';

void main() {
  runApp(const MyApp());
}

/// [MyApp]
/// -------------
/// The main application widget. It sets up the theme
/// and provides the main home page with necessary blocs.
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

/// [MyHomePage]
/// -------------
/// The main home page widget that displays the content based on
/// the selected text and handles UI interactions.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Constant value for opacity
  static const double OPACITY = 0.58;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAC9D71).withOpacity(OPACITY),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white), // White icon color
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
      drawer: _buildDrawer(context),
      body: _buildBody(context),
    );
  }

  // Method to build the drawer widget
  Widget _buildDrawer(BuildContext context) {
    return BlocBuilder<TextBloc, TextState>(
      builder: (context, state) {
        final bool isText1Selected = state is TextLoadSuccess && !state.isText2Selected;
        final bool isText2Selected = state is TextLoadSuccess && state.isText2Selected;

        var text1Button = ElevatedButton(
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
        );

        var text2Button = ElevatedButton(
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
        );

        return Drawer(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.all(8), child: text1Button),
                Padding(padding: const EdgeInsets.all(8), child: text2Button),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to build the body widget
  Widget _buildBody(BuildContext context) {
    return BlocBuilder<TextBloc, TextState>(
      builder: (context, state) {
        if (state is TextLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TextLoadSuccess) {
          return _buildContent(state);
        } else if (state is TextLoadFailure) {
          return const Center(child: Text('Failed to load texts'));
        } else {
          return const Center(child: Text('Unexpected error'));
        }
      },
    );
  }

  // Method to build the content widget
  Widget _buildContent(TextLoadSuccess state) {
    const TextStyle textStyle = TextStyle(fontSize: 16);
    const TextStyle headlineStyle = TextStyle(fontSize: 36, fontWeight: FontWeight.bold);

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
  }
}
