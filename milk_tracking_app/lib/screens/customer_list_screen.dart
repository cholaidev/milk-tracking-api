import 'package:flutter/material.dart';
import '../models/customer.dart';
import 'package:milk_tracking_app/helper/db_helper.dart';
import 'add_customer_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('customers');

    setState(() {
      _customers = List.generate(maps.length, (i) {
        return Customer.fromMap(maps[i]);
      });
    });
  }

  void _navigateToAddCustomer() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCustomerScreen()),
    );
    fetchCustomers(); // Refresh list after returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body:
          _customers.isEmpty
              ? const Center(child: Text('No Customers Added Yet'))
              : ListView.builder(
                itemCount: _customers.length,
                itemBuilder: (context, index) {
                  final customer = _customers[index];
                  return ListTile(
                    title: Text(customer.name),
                    subtitle: Text(customer.phone ?? 'No phone'),
                  );
                },
              ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: _navigateToAddCustomer,
        icon: const Icon(Icons.add),
        label: const Text('Add Customer'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
