import 'package:flutter/material.dart';

class ControllListWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String id;
  final Widget Function(String) page;

  const ControllListWidget({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.page,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: FadeInImage(
            placeholder: const AssetImage("assets/images/user_black.png"),
            image: NetworkImage(
              imageUrl,
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => page(id),
          ),
        );
      },
    );
  }
}
