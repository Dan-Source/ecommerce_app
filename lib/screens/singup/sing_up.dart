import 'package:ecommerce_app/models/user/user.dart';
import 'package:ecommerce_app/models/user/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/helpers/validators.dart';

import '../../models/user/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}


class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode emailFocus = FocusNode();

  FocusNode passFocus = FocusNode();

  FocusNode confirmPassFocus = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration:
                          const InputDecoration(hintText: 'Nome Completo'),
                      autocorrect: false,
                      validator: (name) {
                        if (name!.isEmpty) {
                          return 'Campo obrigatório.';
                        } else if (name.trim().split(' ').length <= 1) {
                          return 'Preencha seu Nome Completo.';
                        }
                        return null;
                      },
                      controller: nameController,
                      onEditingComplete: () {
                        emailFocus.nextFocus();
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      focusNode: emailFocus,
                      validator: (email) {
                        if (email!.isEmpty) return 'Campo obrigatório.';
                        if (!emailValid(email)) return 'E-mail inválido.';
                        return null;
                      },
                      controller: emailController,
                      onEditingComplete: () {
                        passFocus.nextFocus();
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      focusNode: passFocus,
                      obscureText: true,
                      validator: (pass) {
                        if (pass!.isEmpty) return 'Informe a senha.';
                        if (pass.length < 6) return 'Senha muito curta.';
                        return null;
                      },
                      controller: passController,
                      onEditingComplete: () {
                        confirmPassFocus.nextFocus();
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration:
                          const InputDecoration(hintText: 'Repita a Senha'),
                      autocorrect: false,
                      obscureText: true,
                      focusNode: confirmPassFocus,
                      validator: (pass) {
                        if (pass!.isEmpty) return 'Informe a senha.';
                        if (pass.length < 6) return 'Senha muito curta.';
                        return null;
                      },
                      controller: confirmPassController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                if (passController.text != confirmPassController.text) {
                                  ScaffoldMessenger
                                    .of(context)
                                    .showSnackBar(
                                      const SnackBar(
                                        content: Text('As senhas não conferem.'),
                                        backgroundColor: Color.fromARGB(255, 250, 110, 100),
                                      ));
                                  return;
                                }
                                final User user = User(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passController.text,
                                );
                                userManager.signUp(
                                    user: user,
                                    onFail: (e) {
                                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Falha ao cadastrar: $e'),
                                      backgroundColor: const Color.fromARGB(255, 250, 110, 100),
                                    ));
                                    },
                                    onSuccess: () {
                                      Navigator.of(context).pop();
                                      // Navigator.of(context).pop();
                                  });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      child: userManager.loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'Criar Conta',
                              style: TextStyle(fontSize: 15),
                            ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
