import 'package:flutter/material.dart';

class activatePage extends StatefulWidget {
  const activatePage({Key? key}) : super(key: key);

  @override
  State<activatePage> createState() => _activatePageState();
}

class _activatePageState extends State<activatePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
            child: ElevatedButton(onPressed: null, child: Text('Activate'))),
      ),
    );
  }
}