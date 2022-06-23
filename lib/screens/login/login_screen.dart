import 'package:ecommerce_app/helpers/validators.dart';
import 'package:ecommerce_app/models/user/user_manager.dart';
import 'package:ecommerce_app/models/user/user.dart' as costum;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Prazeres de Vênus'),
        centerTitle: true,
        actions: [
          TextButton(
            child: const Text('Criar Conta'),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/signup');
            },
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Consumer<UserManager>(
              builder: (_,userManager, child) {

                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: <Widget> [
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email) {
                        if (email!.isEmpty) {
                          return 'Campo obrigatório.';
                        }
                        if (!emailValid(email)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                      ),
                      obscureText: true,
                      autocorrect: false,
                      validator: (password) {
                        if (password!.isEmpty || password.length < 6) {
                          return 'Senha inválida';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text('Esqueci minha senha'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          primary: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/forgot-password');
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      onPressed: userManager.loading ? null : () {
                        if (_formKey.currentState!.validate()) {
                          final user = costum.User(
                            email: emailController.text,
                            password: passController.text,
                          );
                          context.read<UserManager>().signIn(
                            user: user,
                            onFail: (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Falha ao entrar: $e'),
                                backgroundColor: const Color.fromARGB(255, 250, 110, 100),
                              ));
                            },
                            onSuccess: () {
                              print("sucesso");
                            });
                        }
                      },
                      child: userManager.loading ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ) : const Text('Entrar'),
                    ),
                  ],
                );
              },
            )
          ),
        ),
      ),
    );
  }
}
