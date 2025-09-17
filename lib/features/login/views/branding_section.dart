import 'package:flutter/material.dart';

class BrandingSection extends StatelessWidget {
  final bool isNarrow;

  const BrandingSection({super.key, this.isNarrow = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isNarrow ? Alignment.center : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isNarrow ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          SizedBox(
            width: isNarrow ? 50 : 75,
            height: isNarrow ? 50 : 75,
            child: Image.asset("assets/icons/logo-parkways.png"),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Parkways",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isNarrow ? 24 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isNarrow ? 4 : 6),
              Text(
                "Digital Parking Transformation",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isNarrow ? 14 : 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}