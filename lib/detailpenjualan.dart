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
  int? selectedPelangganID;
  List<Map<String, dynamic>> pelangganlist = [];

  @override
  void initState() {
    super.initState();
    stokawal = widget.produk['Stok'] ?? 0; // Set stok awal dari produk
    fetchpelanggan();
  }

  Future<void> fetchpelanggan() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('pelanggan').select('PelangganID, NamaPelanggan');
      if (response.isNotEmpty) {
        setState(() {
          pelangganlist = List<Map<String, dynamic>>.from(response);
          selectedPelangganID = pelangganlist.first['PelangganID'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data pelanggan: $e')),
      );
    }
  }

  void updateJumlahPesanan(int harga, int delta) {
    setState(() {
      if (delta > 0 && JumlahPesanan >= stokawal) return; // Cegah melebihi stok

      JumlahPesanan += delta;
      if (JumlahPesanan < 0) JumlahPesanan = 0;

      stokakhir = stokawal - JumlahPesanan;
      TotalHarga = JumlahPesanan * harga;
    });
  }

  Future<void> simpan() async {
    final supabase = Supabase.instance.client;
    final produkid = widget.produk['ProdukID'];

    if (produkid == null || selectedPelangganID == null || JumlahPesanan <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua Wajib Diisi')),
      );
      return;
    }

    try {
      final penjualan = await supabase.from('penjualan').insert({
        'TotalHarga': TotalHarga,
        'PelangganID': selectedPelangganID,
      }).select().single();

      if (penjualan.isNotEmpty) {
        final PenjualanID = penjualan['PenjualanID'];
        await supabase.from('detailpenjualan').insert({
          'PenjualanID': PenjualanID,
          'ProdukID': produkid,
          'JumlahProduk': JumlahPesanan,
          'Subtotal': TotalHarga,
        }).select().single();

        await supabase.from('produk').update({
          'Stok': stokawal - JumlahPesanan,
        }).match({'ProdukID': produkid});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil disimpan')),
        );

        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminHomepage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final Harga = produk['Harga'] ?? 0;

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
                  Text('Stok: $stokawal', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedPelangganID,
                    items: pelangganlist.map((pelanggan) {
                      return DropdownMenuItem<int>(
                        value: pelanggan['PelangganID'],
                        child: Text(pelanggan['NamaPelanggan']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPelangganID = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Pilih Pelanggan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => updateJumlahPesanan(Harga, -1),
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$JumlahPesanan', style: const TextStyle(fontSize: 20)),
                      IconButton(
                        onPressed: () => updateJumlahPesanan(Harga, 1),
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
                            await simpan();
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
