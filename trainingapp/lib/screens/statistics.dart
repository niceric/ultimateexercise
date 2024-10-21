import 'package:flutter/material.dart';
import 'package:trainingapp/components/bottom_appbar.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
