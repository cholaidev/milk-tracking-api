import 'package:flutter/material.dart';
import 'package:milk_tracking_app/helper/db_helper.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  double buyAmount = 0;
  double sellAmount = 0;
  double expenseAmount = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final db = await DBHelper.database;

    final collectResult = await db.rawQuery(
      'SELECT SUM(quantity * rate) as total FROM milk_collections',
    );
    final salesResult = await db.rawQuery(
      'SELECT SUM(quantity * rate) as total FROM milk_sales',
    );
    final expenseResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses',
    );

    setState(() {
      buyAmount = (collectResult.first['total'] ?? 0) as double;
      sellAmount = (salesResult.first['total'] ?? 0) as double;
      expenseAmount = (expenseResult.first['total'] ?? 0) as double;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profit = sellAmount - buyAmount - expenseAmount;
    final loss = profit < 0 ? profit.abs() : 0.0;
    final actualProfit = profit >= 0 ? profit : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Milk Business Summary')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCard('My Buy', buyAmount, Colors.blue),
            _buildCard('My Sell', sellAmount, Colors.green),
            _buildCard('My Expense', expenseAmount, Colors.orange),
            _buildCard('My Profit', actualProfit, Colors.teal),
            _buildCard('My Loss', loss, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, double value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, color: color)),
        trailing: Text(
          '₹ ${value.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
