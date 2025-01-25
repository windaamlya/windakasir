import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windakasir/pelanggan/index.dart';
import 'package:windakasir/penjualan/index.dart';
import 'package:windakasir/produk/index.dart';
import 'package:windakasir/splash.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 4, child: 
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.inventory), text: 'Produk'),
            Tab(icon: Icon(Icons.people), text: 'pelanggan'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Penjualan'),
            Tab(icon: Icon(Icons.drafts), text: 'Detail Penjualan'),
          ]
        )
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                child: ListTile(
                 leading: Icon(Icons.arrow_back),
                 title: Text(
                   'Pengaturan',
                  style: TextStyle(
                  ),
                 ), 
                 onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                    );
                 },
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text('Log Out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Splash()),
                  );
              },
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Splash()),
                  );
              },
            )
          ],
        ),
      ),
      body: TabBarView(
        children: [
          produkTab(),
          PelangganTab(),
          penjualanTab(),
          
        ]
      ),
    )
    );
  }
}