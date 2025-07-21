import 'package:flutter/material.dart';
import '../models/milk_collection.dart';
import '../models/vendor.dart';
import 'package:milk_tracking_app/helper/db_helper.dart';
import 'package:intl/intl.dart';

class MilkCollectionScreen extends StatefulWidget {
  const MilkCollectionScreen({super.key});

  @override
  State<MilkCollectionScreen> createState() => _MilkCollectionScreenState();
}

class _MilkCollectionScreenState extends State<MilkCollectionScreen> {
  final _formKey = GlobalKey<FormState>();
  Vendor? _selectedVendor;
  List<Vendor> _vendors = [];

  final _quantityController = TextEditingController();
  final _rateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchVendors();
  }

  Future<void> _fetchVendors() async {
    final db = await DBHelper.database;
    final vendorMaps = await db.query('vendors');
    setState(() {
      _vendors = vendorMaps.map((e) => Vendor.fromMap(e)).toList();
    });
  }

  Future<void> _saveCollection() async {
    if (_formKey.currentState!.validate() && _selectedVendor != null) {
      final now = DateTime.now();
      final date = DateFormat('yyyy-MM-dd').format(now);

      final milkCollection = MilkCollection(
        vendorId: _selectedVendor!.id!,
        date: date,
        quantity: double.parse(_quantityController.text),
        rate: double.parse(_rateController.text),
      );

      final db = await DBHelper.database;
      await db.insert('milk_collections', milkCollection.toMap());

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Milk Collection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _vendors.isEmpty
                ? const Center(
                  child: Text('No vendors available. Add vendors first.'),
                )
                : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<Vendor>(
                        value: _selectedVendor,
                        hint: const Text('Select Vendor'),
                        items:
                            _vendors.map((vendor) {
                              return DropdownMenuItem(
                                value: vendor,
                                child: Text(vendor.name),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedVendor = value;
                          });
                        },
                        validator:
                            (value) => value == null ? 'Select a vendor' : null,
                      ),
                      TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity (Liters)',
                        ),
                        validator:
                            (value) => value!.isEmpty ? 'Enter quantity' : null,
                      ),
                      TextFormField(
                        controller: _rateController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Rate (Per Liter)',
                        ),
                        validator:
                            (value) => value!.isEmpty ? 'Enter rate' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveCollection,
                        child: const Text('Save Collection'),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
