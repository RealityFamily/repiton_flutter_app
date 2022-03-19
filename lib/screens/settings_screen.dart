import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Настройки",
                    style: TextStyle(
                      fontSize: 34,
                    ),
                  )
                ],
              ),
              if (Provider.of<Auth>(context).userRole.contains("ADMIN"))
                Consumer<Auth>(
                  builder: (context, auth, _) => IconButton(
                    padding: const EdgeInsets.all(16),
                    onPressed: () {
                      auth.changeRoles();
                    },
                    icon: const Icon(Icons.change_circle_outlined),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
