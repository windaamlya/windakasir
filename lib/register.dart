import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windakasir/homepage%20copy.dart';

String supabeseUrl = 'https://elbezejjyepzcdaqabaa.supabase.co';
String supabeseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVsYmV6ZWpqeWVwemNkYXFhYmFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyOTg4NTIsImV4cCI6MjA1MTg3NDg1Mn0.xM3xDfpjbZ5w6T1oZ5Y1Hc-u7RfJHgC_cb4pTEavbFQ';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:'https://elbezejjyepzcdaqabaa.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVsYmV6ZWpqeWVwemNkYXFhYmFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyOTg4NTIsImV4cCI6MjA1MTg3NDg1Mn0.xM3xDfpjbZ5w6T1oZ5Y1Hc-u7RfJHgC_cb4pTEavbFQ',
  );
  runApp(Register());
}


class Register extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Register> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final roleController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _Login() async {
    final username = usernameController.text;
    final password = passwordController.text;
    final role = roleController.text;

    try {
      final response = await supabase
          .from('user')
          .select('username, password, role')
          .eq('username', username)
          .single();
      if (response != null && response['password'] == password) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login berhasil!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomepage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username atau Password salah!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: Text("Register"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text("Register", style: TextStyle(fontSize: 30, color: Colors.pink[300])),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                icon: Icon(Icons.person, color: Colors.pink[300]),
                fillColor: Colors.pink[50],
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration( 
                labelText: "Password",
                icon: Icon(Icons.vpn_key_sharp, color: Colors.pink[300]),
                fillColor: Colors.pink[50],
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              obscureText: true,
            ),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: roleController,
              decoration: InputDecoration(
                labelText: "Role",
                icon: Icon(Icons.group, color: Colors.pink[300]),
                fillColor: Colors.pink[50],
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _Login,
              child: Text("Register"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
