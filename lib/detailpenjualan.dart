import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windakasir/homepage%20copy.dart';

class ProdukDetailPage extends StatefulWidget {
  final Map<String, dynamic> produk;
  const ProdukDetailPage({Key? key, required this.produk}) : super(key: key);

  @override
  _ProdukDetailPageState createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  int JumlahPesanan = 0;
  int TotalHarga = 0;
  int stokakhir = 0;
  int stokawal = 0;

  // Fungsi untuk memperbarui jumlah pesanan
  void updateJumlahPesanan(int harga, int delta) {
    setState(() {
      stokakhir = stokawal - delta;
      if (stokakhir < 0) stokakhir = 0; 
      JumlahPesanan += delta;
      if (JumlahPesanan < 0) JumlahPesanan = 0; // Tidak boleh negatif
      TotalHarga = JumlahPesanan * harga;
      if (TotalHarga < 0) TotalHarga = 0; // Tidak boleh negatif
    });
  }

  // Fungsi untuk menyimpan data ke tabel detailpenjualan
  Future<void> insertDetailPenjualan(int ProdukID, int PenjualanID, int JumlahPesanan, int TotalHarga) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('detailpenjualan').insert({
        'ProdukID': ProdukID,
        'PenjualanID': PenjualanID,
        'JumlahProduk': JumlahPesanan,
        'Subtotal': TotalHarga,
      });

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil disimpan!')),
        );
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomepage()));
      }
    } catch (e) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomepage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final Harga = produk['Harga'] ?? 0;
    final ProdukID = produk['ProdukID'] ?? 0;
    final PenjualanID = 1; // Contoh ID Penjualan (harus diganti sesuai logika Anda)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama Produk: ${produk['NamaProduk'] ?? 'Tidak Tersedia'}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Text('Harga: $Harga', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  Text('Stok: ${produk['Stok'] ?? 'Tidak Tersedia'}', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          updateJumlahPesanan(Harga, -1);
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$JumlahPesanan',
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          updateJumlahPesanan(Harga, 1);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup', style: TextStyle(fontSize: 20)),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (JumlahPesanan > 0) {
                          await insertDetailPenjualan(ProdukID, PenjualanID, JumlahPesanan, TotalHarga);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Jumlah pesanan harus lebih dari 0')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade300,
                        ),
                        child: Text('Pesan ($TotalHarga)', style: const TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}