import 'package:flutter/material.dart';

import 'package:primeiroapp/core/widgets/custom_button.dart';
import 'package:primeiroapp/core/widgets/custom_textfield.dart';
import 'package:primeiroapp/services/auth_service.dart';

import '../home/home_screen.dart';
import 'register_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> fazerLogin() async {
    setState(() {
      loading = true;
    });

    final sucesso = await AuthService.login(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() {
      loading = false;
    });

    if (sucesso) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário ou senha inválidos.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color(0xFFEAF2FF),

      body: SafeArea(
  child: Center(
    child: SizedBox(
      width: 450,
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

  const SizedBox(height: 40),


              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              CustomTextField(
                hint: 'Usuário',
                controller: usernameController,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hint: 'Senha',
                obscure: true,
                controller: passwordController,
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: loading ? 'Entrando...' : 'Entrar',
                onPressed: loading ? () {} : fazerLogin,
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text('Criar conta'),
              ),
            ],
          ),
        ),
      ),
    )
  )
      )
    );
  }
}