import 'package:flutter/material.dart';
import 'package:milk_tracking_app/helper/db_helper.dart';
import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await DBHelper.getProfile();

    setState(() {
      profile =
          data ??
          Profile(
            name: "Cholai Mani",
            email: "cholaimanigit@gmail.com",
            businessName: "Cholai Milk Center",
            contact: "9876543210",
          );
    });
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: profile!.name);
    final emailController = TextEditingController(text: profile!.email);
    final businessController = TextEditingController(
      text: profile!.businessName,
    );
    final contactController = TextEditingController(text: profile!.contact);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Profile"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: businessController,
                    decoration: const InputDecoration(
                      labelText: "Business Name",
                    ),
                  ),
                  TextField(
                    controller: contactController,
                    decoration: const InputDecoration(labelText: "Contact"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final updatedProfile = Profile(
                    id: profile!.id,
                    name: nameController.text,
                    email: emailController.text,
                    businessName: businessController.text,
                    contact: contactController.text,
                  );

                  final existing = await DBHelper.getProfile();
                  if (existing == null) {
                    await DBHelper.insertProfile(updatedProfile);
                  } else {
                    await DBHelper.updateProfile(updatedProfile);
                  }

                  setState(() => profile = updatedProfile);
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),

            _buildRow("Name", profile!.name),
            _buildRow("Email", profile!.email),
            _buildRow("Business", profile!.businessName),
            _buildRow("Contact", profile!.contact),

            const Spacer(),

            ElevatedButton.icon(
              onPressed: _showEditDialog,
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
