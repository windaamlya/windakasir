import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windakasir/penjualan/insert.dart';
import 'package:windakasir/penjualan/update.dart';

class penjualanTab extends StatefulWidget {
  const penjualanTab({super.key});

  @override
  State<penjualanTab> createState() => _penjualanTabState();
}

class _penjualanTabState extends State<penjualanTab> {
  List<Map<String, dynamic>> Penjualan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchpenjualan();
  }

  Future<void> fetchpenjualan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
    .from('penjualan')
    .select('*, pelanggan(NamaPelanggan)');

      setState(() {
        Penjualan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching penjualan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletepenjualan(int id) async {
    await Supabase.instance.client.from('penjualan').delete().eq('PenjualanID', id);
    fetchpenjualan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Penjualan.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada penjualan tersedia',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: Penjualan.length,
                  itemBuilder: (context, index) {
                    final jualan = Penjualan[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jualan['TangggalPenjualan'] ?? 'No TangggalPenjualan',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              jualan['TotalHarga'] != null ? jualan['TotalHarga'].toString() : 'Total Harga Tidak Tersedia',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              jualan['pelanggan']?['NamaPelanggan'] ?? 'PelangganID Tidak Tersedia',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.pink),
                                  onPressed: () {
                                    final PenjualanID =
                                     jualan['PenjualanID'] ?? 0; // Pastikan ini sesuai dengan kolom di database
                                    if (PenjualanID != 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPenjualan(PenjualanID: PenjualanID)
                                        ),
                                      );
                                    } else {
                                      print('ID produk tidak valid');
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Hapus Penjualan'),
                                          content: const Text(
                                              'Apakah Anda yakin ingin menghapus penjualan ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deletepenjualan(jualan['PenjualanID']);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman untuk menambah buku baru
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPenjualan(),
            ),
          );
        },
        backgroundColor: Colors.pink[200],
        child: const Icon(Icons.add),
      ),
    );
  }
}
