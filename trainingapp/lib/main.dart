import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'states/screen_index_provider.dart';
import 'components/bottom_appbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScreenIndexProvider())
      ],
      child: MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// This widget is the root of your application.
@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Training App',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
  );
}

class HomeScreen extends StatelessWidget {
  List<dynamic> screens = [
    // screen1(),
    // screen2(),
    // screen3(),
    // screen4(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(),
      //body: screens[currentScreenIndex],
    );
  }
}
