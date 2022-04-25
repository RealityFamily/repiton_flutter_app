import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/auth.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  String login = "";
  String password = "";

  void _authButtonPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    if (login.contains("@")) {
      Provider.of<Auth>(context, listen: false).auth(null, login, password);
    } else {
      Provider.of<Auth>(context, listen: false).auth(login, null, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Repiton",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                labelText: "Логин",
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty ? "Введите корректный логин или почту" : null,
                              onSaved: (value) => login = value ?? "",
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              style: const TextStyle(fontSize: 18),
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Пароль",
                              ),
                              validator: (value) =>
                                  value == null || value.length <= 5 ? "Введите корректный пароль" : null,
                              onSaved: (value) => password = value ?? "",
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => _authButtonPressed(context),
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 18),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              ),
                              child: const Text(
                                "Войти",
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
