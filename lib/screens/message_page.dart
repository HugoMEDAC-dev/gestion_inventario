import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  // const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final arg = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      appBar: AppBar(title: Text('Message')),
      body: Center(
        child: Text('Message Screen', style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
