import 'package:flutter/material.dart';

class ControllListWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String id;

  const ControllListWidget({
    required this.id,
    required this.name,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
    );
  }
}
