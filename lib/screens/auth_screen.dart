import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repiton/provider/root_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  String login = "";
  String password = "";

  bool isObscure = true;

  Future<void> _authButtonPressed(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    var result = false;

    _formKey.currentState!.save();
    if (login.contains("@")) {
      result = await RootProvider.getAuth().auth(null, login, password);
    } else {
      result = await RootProvider.getAuth().auth(login, null, password);
    }

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ошибка входа")));
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
                                constraints: BoxConstraints(maxWidth: 500),
                                labelText: "Логин",
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty ? "Введите корректный логин или почту" : null,
                              onSaved: (value) => login = value ?? "",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              style: const TextStyle(fontSize: 18),
                              obscureText: isObscure,
                              decoration: InputDecoration(
                                constraints: const BoxConstraints(maxWidth: 500),
                                labelText: "Пароль",
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                  icon: Icon(
                                    isObscure ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
                                    color: Colors.black,
                                  ),
                                ),
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
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
