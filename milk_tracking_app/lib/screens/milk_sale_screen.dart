import 'package:flutter/material.dart';
import '../models/milk_sale.dart';
import '../models/customer.dart';
import 'package:milk_tracking_app/helper/db_helper.dart';
import 'package:intl/intl.dart';

class MilkSalesScreen extends StatefulWidget {
  const MilkSalesScreen({super.key});

  @override
  State<MilkSalesScreen> createState() => _MilkSalesScreenState();
}

class _MilkSalesScreenState extends State<MilkSalesScreen> {
  final _formKey = GlobalKey<FormState>();
  Customer? _selectedCustomer;
  List<Customer> _customers = [];

  final _quantityController = TextEditingController();
  final _rateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    final db = await DBHelper.database;
    final customerMaps = await db.query('customers');
    setState(() {
      _customers = customerMaps.map((e) => Customer.fromMap(e)).toList();
    });
  }

  Future<void> _saveSale() async {
    if (_formKey.currentState!.validate() && _selectedCustomer != null) {
      final now = DateTime.now();
      final date = DateFormat('yyyy-MM-dd').format(now);

      final milkSale = MilkSale(
        customerId: _selectedCustomer!.id!,
        date: date,
        quantity: double.parse(_quantityController.text),
        rate: double.parse(_rateController.text),
      );

      final db = await DBHelper.database;
      await db.insert('milk_sales', milkSale.toMap());

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Milk Sales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _customers.isEmpty
                ? const Center(
                  child: Text('No customers available. Add customers first.'),
                )
                : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<Customer>(
                        value: _selectedCustomer,
                        hint: const Text('Select Customer'),
                        items:
                            _customers.map((customer) {
                              return DropdownMenuItem(
                                value: customer,
                                child: Text(customer.name),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCustomer = value;
                          });
                        },
                        validator:
                            (value) =>
                                value == null ? 'Select a customer' : null,
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
                        onPressed: _saveSale,
                        child: const Text('Save Sale'),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
