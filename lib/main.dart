import 'package:flutter/material.dart';
// import 'package:kasir_coba/HomePage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windakasir/splash.dart';

String supabeseUrl = 'https://elbezejjyepzcdaqabaa.supabase.co';
String supabeseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVsYmV6ZWpqeWVwemNkYXFhYmFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyOTg4NTIsImV4cCI6MjA1MTg3NDg1Mn0.xM3xDfpjbZ5w6T1oZ5Y1Hc-u7RfJHgC_cb4pTEavbFQ';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:'https://elbezejjyepzcdaqabaa.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVsYmV6ZWpqeWVwemNkYXFhYmFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyOTg4NTIsImV4cCI6MjA1MTg3NDg1Mn0.xM3xDfpjbZ5w6T1oZ5Y1Hc-u7RfJHgC_cb4pTEavbFQ',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

  