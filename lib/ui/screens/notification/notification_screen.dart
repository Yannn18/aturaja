import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<String> notifications;
  final VoidCallback onClear;

  const NotificationScreen({
    super.key,
    required this.notifications,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Tombol sapu bersih muncul kalau ada notifikasinya
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all, color: Colors.black),
              onPressed: onClear,
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "There is no notifications",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.check, color: Colors.white),
            ),
            title: const Text("Top Up Berhasil", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(notifications[index]),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          );
        },
      ),
    );
  }
}