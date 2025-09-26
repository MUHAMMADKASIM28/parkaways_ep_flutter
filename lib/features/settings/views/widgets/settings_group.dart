// lib/features/settings/views/widgets/setting_group.dart

import 'package:flutter/material.dart';

class SettingGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingGroup({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 8.0),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ),
        Card(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
            separatorBuilder: (context, index) => const Divider(height: 1),
          ),
        ),
      ],
    );
  }
}