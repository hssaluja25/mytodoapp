import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:mytodoapp/firebase_options.dart';
import 'root.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  TodoApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initalization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Logger logger = Logger(
      printer: PrettyPrinter(
    errorMethodCount: 5,
    methodCount: 0,
    printTime: true,
  ));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: FutureBuilder(
          future: _initalization,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error initializing app\n${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                return const Root();
              } else {
                logger.w('Initializing Firebase app returned no data.');
                return const Center(child: Text('Empty Data'));
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text('State: ${snapshot.connectionState}'));
            }
          },
        ),
      ),
    );
  }
}
