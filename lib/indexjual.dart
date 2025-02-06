import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPenjualanTab extends StatefulWidget {
  const DetailPenjualanTab({super.key});

  @override
  State<DetailPenjualanTab> createState() => _DetailPenjualanTabState();
}

class _DetailPenjualanTabState extends State<DetailPenjualanTab> {
  List<Map<String, dynamic>> detaill = [];
  bool isLoading = false; 

  @override
  void initState() {
    super.initState();
    fetchdetail();
  }

  Future<void> fetchdetail() async{
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('detailpenjualan').select();
      setState(() {
        detaill = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body
      : ListView.builder(
        itemCount: detaill.length,  
        itemBuilder: (context, index){
          final detail = detaill[index];  // Mengakses data berdasarkan index
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: SizedBox(
             
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,  // Merapikan teks
                  children: [
                    Row(
                      children: [
                        Text('Detail ID: ${detail['DetailID']?.toString() ?? 'tidak tersedia'}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 28),
                    Text('Penjualan ID: ${detail['PenjualanID']?.toString() ?? 'tidak tersedia'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 28),
                    Text('Produk ID: ${detail['ProdukID']?.toString() ?? 'tidak tersedia'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 28),
                    Text('Jumlah Produk: ${detail['JumlahProduk']?.toString() ?? 'tidak tersedia'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 28),
                    Text('Subtotal: ${detail['Subtotal']?.toString() ?? 'tidak tersedia'}',
                      style: TextStyle(fontSize: 16),
                    ),
                      ],
                    )
                  ],
                ),
              )
            ),
          );
        },
      ),
    );
  }
}