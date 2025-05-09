import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicall/app/app_export.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.indigo50,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 30),
          _buildProfileSection(),
          const SizedBox(height: 30),
          _buildSettingsSection(context),
          const SizedBox(height: 30),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ), 
      margin: EdgeInsets.zero,
      child: Column(
        children: const [
          _ProfileItem(icon: Icons.person_outline, text: 'Johan Nilsson'),
          Divider(height: 2),
          _ProfileItem(icon: Icons.medical_services_outlined, text: 'Doctor'),
          Divider(height: 2),
          _ProfileItem(icon: Icons.group_outlined, text: 'Närsjukvårdsteam Sahlgrenska'),
          Divider(height: 2),
          _ProfileItem(icon: Icons.location_on_outlined, text: 'Västra Götalandsregionen'),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),  
      margin:  EdgeInsets.zero,
      child: Column(
        children: [
          const _ProfileItem(icon: Icons.language, text: 'English'),
          const Divider(height: 2),
          const _ProfileItem(icon: Icons.notifications_none, text: 'Notification Setting'),
          const Divider(height: 2),
          GestureDetector(
            onTap: () {
              // TODO: Implement change password route
              context.push('/change-password');
            },
            child: const _ProfileItem(icon: Icons.lock_outline, text: 'Change Password'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: Colors.blue,
        ),
        onPressed: () {
          // TODO: Implement logout logic
          context.go('/login');
        },
        child: const Text('Log Out'),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProfileItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black), 
      title: Text(text, style: const TextStyle(fontSize: 16)),
      dense: true,
    );
  }
}
