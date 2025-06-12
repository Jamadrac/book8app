import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserModel? currentUser;
  String selectedAgeGroup = '6-8 years';
  final List<String> ageGroups = [
    '3-5 years',
    '6-8 years',
    '9-11 years',
    '12-14 years',
    '15-17 years',
    '18+ years',
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn || userData == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    if (mounted) {
      setState(() {
        currentUser = UserModel.fromJson(jsonDecode(userData));
      });
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _launchPremiumSignup() async {
    final Uri url = Uri.parse('https://book8.vercel.app/register');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch premium signup page')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Profile Section
          if (currentUser != null) ...[
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(currentUser!.username ?? 'User'),
                    subtitle: Text(currentUser!.email),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: _handleLogout,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Age Group Selection
          Card(
            child: ListTile(
              leading: const Icon(Icons.child_care),
              title: const Text('Age Group'),
              subtitle: Text(selectedAgeGroup),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Select Age Group'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                                ageGroups.map((age) {
                                  return ListTile(
                                    title: Text(age),
                                    selected: age == selectedAgeGroup,
                                    onTap: () {
                                      setState(() {
                                        selectedAgeGroup = age;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Premium Account
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: const Text('Premium Account'),
                  subtitle: const Text('Get access to all educational content'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Unlock all educational videos and features with a premium account.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                      onPressed: _launchPremiumSignup,
                      child: const Text('SIGN UP FOR PREMIUM'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // App Version
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
            ),
          ),
        ],
      ),
    );
  }
}
