import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => TextBloc()..add(TextFetched()),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  static const double opacity = 0.58;

  // Define a GlobalKey for the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to Scaffold
      appBar: AppBar(
        backgroundColor: const Color(0xFFAC9D71).withOpacity(opacity),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer using GlobalKey
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(''),
            _buildCustomSwitch(context),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
      body: _buildBody(context),
    );
  }

  Widget _buildCustomSwitch(BuildContext context) {
    return BlocBuilder<TextBloc, TextState>(
      builder: (context, state) {
        if (state is TextLoadSuccess) {
          return GestureDetector(
            onTap: () {
              context.read<TextBloc>().add(state.isText2Selected ? Text1Selected() : Text2Selected());
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
                    alignment: state.isText2Selected ? Alignment.centerRight : Alignment.centerLeft,
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
                      state.isText2Selected ? 'Text 2' : 'Text 1',
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
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return BlocBuilder<TextBloc, TextState>(
      builder: (context, state) {
        if (state is TextLoadSuccess) {
          return Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDrawerButton(context, '1', !state.isText2Selected, () {
                  context.read<TextBloc>().add(Text1Selected());
                  Navigator.pop(context);
                }),
                _buildDrawerButton(context, '2', state.isText2Selected, () {
                  context.read<TextBloc>().add(Text2Selected());
                  Navigator.pop(context);
                }),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDrawerButton(BuildContext context, String text, bool isSelected, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFAC9D71).withOpacity(isSelected ? 1 : 0.42),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(50),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 48, color: Colors.white)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<TextBloc, TextState>(
      builder: (context, state) {
        if (state is TextLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TextLoadSuccess) {
          return _buildContent(state);
        } else if (state is TextLoadFailure) {
          return const Center(child: Text('Failed to load texts'));
        }
        return const Center(child: Text('Unexpected error'));
      },
    );
  }

  Widget _buildContent(TextLoadSuccess state) {
    const TextStyle textStyle = TextStyle(fontSize: 16);
    const TextStyle headlineStyle = TextStyle(fontSize: 36, fontWeight: FontWeight.bold);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: state.isText2Selected ? 'Some text 2\n' : 'Some text 1\n', style: headlineStyle),
            TextSpan(text: state.isText2Selected ? state.text2 : state.text1, style: textStyle),
          ],
        ),
      ),
    );
  }
}
