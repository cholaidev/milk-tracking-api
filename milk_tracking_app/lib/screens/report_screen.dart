import 'package:flutter/material.dart';
import 'package:milk_tracking_app/helper/db_helper.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  double _totalCollected = 0;
  double _totalSold = 0;

  @override
  void initState() {
    super.initState();
    _calculateBalance();
  }

  Future<void> _calculateBalance() async {
    final db = await DBHelper.database;

    final collectResult = await db.rawQuery(
      'SELECT SUM(quantity) as total FROM milk_collections',
    );
    final salesResult = await db.rawQuery(
      'SELECT SUM(quantity) as total FROM milk_sales',
    );

    setState(() {
      _totalCollected = (collectResult.first['total'] ?? 0) as double;
      _totalSold = (salesResult.first['total'] ?? 0) as double;
    });
  }

  @override
  Widget build(BuildContext context) {
    final balance = _totalCollected - _totalSold;

    return Scaffold(
      appBar: AppBar(title: const Text('Milk Report')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Collected: $_totalCollected Ltr',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Total Sold: $_totalSold Ltr',
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(height: 30, thickness: 2),
            Text(
              'Balance: $balance Ltr',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
