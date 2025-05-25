/*

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
      child: const Column(
        children: [
          _ProfileItem(icon: Icons.person_outline, text: 'Johan Nilsson'),
          Divider(height: 2),
          _ProfileItem(icon: Icons.medical_services_outlined, text: 'Doctor'),
          Divider(height: 2),
          _ProfileItem(
            icon: Icons.group_outlined,
            text: 'Närsjukvårdsteam Sahlgrenska',
          ),
          Divider(height: 2),
          _ProfileItem(
            icon: Icons.location_on_outlined,
            text: 'Västra Götalandsregionen',
          ),
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
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          const _ProfileItem(icon: Icons.language, text: 'English'),
          const Divider(height: 2),
          const _ProfileItem(
            icon: Icons.notifications_none,
            text: 'Notification Setting',
          ),
          const Divider(height: 2),
          GestureDetector(
            onTap: () {
              // TODO: Implement change password route
              context.push('/change-password');
            },
            child: const _ProfileItem(
              icon: Icons.lock_outline,
              text: 'Change Password',
            ),
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
  const _ProfileItem({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      dense: true,
    );
  }
}
*/
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
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 30),
          _buildDoctorHeader(),
          const SizedBox(height: 24),
          _buildSettingsSection(context),
          const SizedBox(height: 30),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  /// 👤 Avatar + name + role + org + location
  Widget _buildDoctorHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/200?img=15'),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  size: 20,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Dr. Johan Nilsson',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Primary Care Physician',
          style: TextStyle(fontSize: 16, color: Colors.pinkAccent),
        ),
        const SizedBox(height: 8),
        const Text(
          'Närsjukvårdsteam Sahlgrenska',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 2),
        const Text(
          'Västra Götalandsregionen',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  /// Language, notifications, password
  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          const _ProfileItem(icon: Icons.language, text: 'English'),
          const Divider(height: 2),
          const _ProfileItem(
              icon: Icons.notifications_none, text: 'Notification Setting'),
          const Divider(height: 2),
          GestureDetector(
            onTap: () => context.push('/change-password'),
            child: const _ProfileItem(
                icon: Icons.lock_outline, text: 'Change Password'),
          ),
        ],
      ),
    );
  }

  /// ✅ Styled logout button matching login screen
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: const Color(0xFF9AEF99),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), 
          ),
          elevation: 4,
        ),
        onPressed: () {
          context.go('/login');
        },
        child: const Text(
          'Log Out',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
