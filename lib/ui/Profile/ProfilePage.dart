import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/themes/theme.dart';
import 'package:tick_tock/ui/core/ui/CustomInput.dart';
import 'package:tick_tock/ui/NavigationBar/CustomNavigationBar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.inversePrimary,
        elevation: 0,
        title: const Text('Profile'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('카테고리', style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Avatar with edit icon
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colors.primary.withOpacity(0.1),
                  child: const Icon(Icons.person, size: 40),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: colors.primary,
                    child: const Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '졸려요 자고싶어요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'HYU@hanyang.ac.kr',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Placeholder box for sprout image
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),
            // Name input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomInput(
                controller: TextEditingController(),
                labelText: '이름',
                hintText: '정현도',
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for draggable modal widget
            Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.outline),
              ),
              child: const Center(
                child: Text(
                  '나중에 변경',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      
    );
  }
}


void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: MediaQuery.platformBrightnessOf(context) == Brightness.light
            ? MaterialTheme.darkScheme().toColorScheme()
            : MaterialTheme.lightScheme().toColorScheme(),
      ),
      home: const ProfilePage(),
    );
  }
}


