import 'package:flutter/material.dart';
import 'screens/vendor_list_screen.dart';
import 'screens/customer_list_screen.dart';
import 'screens/milk_collection_screen.dart';
import 'package:milk_tracking_app/screens/milk_sale_screen.dart';
import 'screens/report_screen.dart';
import 'package:milk_tracking_app/screens/home_dashboard_screen.dart';
import 'package:milk_tracking_app/screens/profile_screen.dart';

void main() {
  runApp(const MilkTrackingApp());
}

class MilkTrackingApp extends StatelessWidget {
  const MilkTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Milk Tracking App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeDashboardScreen(),
    VendorListScreen(),
    CustomerListScreen(),
    MilkCollectionScreen(),
    MilkSalesScreen(),
    ReportScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Vendors',
    'Customers',
    'Milk Collection',
    'Milk Sales',
    'Report',
    "profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Vendors'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Customers'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Collect'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sales',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
