import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Products', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.inventory_2, color: AppColors.primaryOrange),
                ),
                title: Text('Product Item ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Category: Electronics\nStock: ${50 - (index * 5)} units'),
                isThreeLine: true,
                trailing: Text(
                  '₹ ${999 + (index * 500)}.00',
                  style: const TextStyle(color: AppColors.cardDarkBlue, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
