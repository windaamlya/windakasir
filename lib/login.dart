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
  runApp(LoginPage());
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _Login() async {
    final username = usernameController.text;
    final password = passwordController.text;

    try {
      final response = await supabase
          .from('user')
          .select('username, password')
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
        title: Text("Login Kasir"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 200,
            width: double.infinity,
            child: Image.asset('asset/image/kue.png'),
          ),
          Center(
            child: Text("Login", style: TextStyle(fontSize: 30, color: Colors.pink[300])),
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
          Center(
            child: ElevatedButton(
              onPressed: _Login,
              child: Text("Login"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200],
                fixedSize: Size(100, 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
