import 'package:flutter/material.dart';
import '../models/vendor.dart';
import 'package:milk_tracking_app/helper/db_helper.dart';

class AddVendorScreen extends StatefulWidget {
  const AddVendorScreen({super.key});

  @override
  State<AddVendorScreen> createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends State<AddVendorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _saveVendor() async {
    if (_formKey.currentState!.validate()) {
      final newVendor = Vendor(
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
      );

      final db = await DBHelper.database;
      await db.insert('vendors', newVendor.toMap());

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vendor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Vendor Name'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter vendor name' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVendor,
                child: const Text('Save Vendor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
