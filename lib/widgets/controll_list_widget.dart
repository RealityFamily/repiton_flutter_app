import 'package:flutter/material.dart';

class ControllListWidget extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final Object user;
  final Widget Function(Object) page;

  const ControllListWidget({
    required this.name,
    this.imageUrl,
    required this.user,
    required this.page,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const AssetImage placeHolder = AssetImage("assets/images/user_black.png");
    late ImageProvider image;

    if (imageUrl != null) {
      image = NetworkImage(imageUrl!);
    } else {
      image = placeHolder;
    }

    return ListTile(
      title: Text(name),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: ClipOval(child: FadeInImage(placeholder: placeHolder, image: image)),
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => page(user))),
    );
  }
}
