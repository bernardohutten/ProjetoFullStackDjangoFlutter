import 'package:flutter/material.dart';
import 'package:primeiroapp/services/user_service.dart';
import 'package:primeiroapp/core/theme/app_colors.dart';
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Map<String, dynamic>? usuario;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarPerfil();
  }

  Future<void> carregarPerfil() async {
    final dados = await UserService.getMe();

    setState(() {
      usuario = dados;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
  if (loading) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  return Scaffold(
    backgroundColor: const Color(0xFFEAF2FF),

    appBar: AppBar(
      title: const Text('Meu Perfil'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),

    body: usuario == null
        ? const Center(
            child: Text('Erro ao carregar perfil.'),
          )
        : Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 550,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [

                        CircleAvatar(
                          radius: 55,
                          backgroundColor: AppColors.primary,
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          usuario!['username'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          usuario!['email'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            children: [
                              Text(
                                'Seu progresso',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 6),

                              Text(
                                'Acompanhe sua evolução nos estudos',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          children: [

                            Expanded(
                              child: Card(
                                elevation: 3,
                                color: Colors.blue.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(20),
                                  child: Column(
                                    children: [

                                      const Icon(
                                        Icons.menu_book,
                                        size: 35,
                                        color: Colors.blue,
                                      ),

                                      const SizedBox(height: 10),

                                      Text(
                                        '${usuario!['total_atividades']}',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      const Text(
                                        'Atividades',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Card(
                                elevation: 3,
                                color: Colors.green.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(20),
                                  child: Column(
                                    children: [

                                      const Icon(
                                        Icons.check_circle,
                                        size: 35,
                                        color: Colors.green,
                                      ),

                                      const SizedBox(height: 10),

                                      Text(
                                        '${usuario!['total_registros']}',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      const Text(
                                        'Registros',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            children: [

                              Icon(
                                Icons.emoji_events,
                                size: 40,
                                color: Colors.amber,
                              ),

                              SizedBox(height: 10),

                              Text(
                                'Continue estudando diariamente para aumentar seus resultados.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
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