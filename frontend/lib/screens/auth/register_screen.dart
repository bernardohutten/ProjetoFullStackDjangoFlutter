import 'package:flutter/material.dart';

import 'package:primeiroapp/core/widgets/custom_button.dart';
import 'package:primeiroapp/core/widgets/custom_textfield.dart';
import 'package:primeiroapp/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool loading = false;

  Future<void> cadastrar() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem.'),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    final sucesso = await AuthService.register(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() {
      loading = false;
    });

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso.'),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao criar conta.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xFFEAF2FF),

  appBar: AppBar(
    backgroundColor: const Color(0xFFEAF2FF),
    elevation: 0,
  ),

      body: Center(
  child: SingleChildScrollView(
    child: SizedBox(
      width: 500,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/login.svg',
                height: 200,width: 200,
              ),

              const SizedBox(height: 20),

              const Text(
                'Cadastro',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Crie sua conta para começar',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              CustomTextField(
                hint: 'Usuário',
                controller: usernameController,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hint: 'Email',
                controller: emailController,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hint: 'Senha',
                obscure: true,
                controller: passwordController,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hint: 'Confirmar senha',
                obscure: true,
                controller: confirmPasswordController,
              ),

              const SizedBox(height: 30),

               CustomButton(
                text: loading ? 'Cadastrando...' : 'Cadastrar',
                onPressed: loading ? () {} : cadastrar,
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),
    );
  }
}