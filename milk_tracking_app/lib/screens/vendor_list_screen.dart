import 'package:flutter/material.dart';
import '../models/vendor.dart';
import 'package:milk_tracking_app/helper/db_helper.dart';
import 'add_vendor_screen.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  List<Vendor> _vendors = [];

  @override
  void initState() {
    super.initState();
    fetchVendors();
  }

  Future<void> fetchVendors() async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('vendors');

    setState(() {
      _vendors = List.generate(maps.length, (i) {
        return Vendor.fromMap(maps[i]);
      });
    });
  }

  void _navigateToAddVendor() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVendorScreen()),
    );
    fetchVendors(); // Refresh the list after returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendors')),
      body:
          _vendors.isEmpty
              ? const Center(child: Text('No Vendors Added Yet'))
              : ListView.builder(
                itemCount: _vendors.length,
                itemBuilder: (context, index) {
                  final vendor = _vendors[index];
                  return ListTile(
                    title: Text(vendor.name),
                    subtitle: Text(vendor.phone ?? 'No phone'),
                  );
                },
              ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: _navigateToAddVendor,
        icon: const Icon(Icons.add),
        label: const Text('Add Vendor'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
