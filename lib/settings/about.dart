import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../utils/storage_manager.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          SizedBox.square(
            dimension: 120,
            child: Image.asset(
              'assets/images/ic_minima_dark.png',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Minima',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Developed by ',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: open Github.
                },
                child: const Text(
                  '@birjuvachhani',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          IconButton(
            tooltip: 'Reset Settings',
            onPressed: () {
              GetIt.instance.get<StorageManager>().clear();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(height: 48),
          const Text(
            'Version v1.0.0',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              letterSpacing: 0.2,
            ),
          ),
          // const SizedBox(height: 8),
          // const Text('Backgrounds from Unsplash'),
        ],
      ),
    );
  }
}
