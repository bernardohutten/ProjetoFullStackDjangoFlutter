import 'package:flutter/material.dart';

import 'package:primeiroapp/core/theme/app_colors.dart';
import 'package:primeiroapp/services/atividade_service.dart';
import 'package:primeiroapp/services/auth_service.dart';

import '../auth/login_screen.dart';
import '../perfil/perfil_screen.dart';
import '../estudar/estudar_screen.dart';
import '../quiz/quiz_list_screen.dart';
import '../prova/prova_list_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> atividades = [];
  bool loading = true;

  final nomeAtividadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarAtividades();
  }

  Future<void> carregarAtividades() async {
    final dados = await AtividadeService.listarAtividades();

    setState(() {
      atividades = dados;
      loading = false;
    });
  }

  Future<void> criarAtividade() async {
    final nome = nomeAtividadeController.text.trim();

    if (nome.isEmpty) return;

    final sucesso = await AtividadeService.criarAtividade(nome);

    if (sucesso) {
      nomeAtividadeController.clear();
      Navigator.pop(context);
      carregarAtividades();
    }
  }

  Future<void> registrar(int id) async {
    final sucesso = await AtividadeService.registrarAtividade(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso
              ? 'Atividade registrada com sucesso.'
              : 'Você já registrou esta atividade hoje.',
        ),
      ),
    );

    if (sucesso) {
      carregarAtividades();
    }
  }

  Future<void> deletar(int id) async {
    final sucesso = await AtividadeService.deletarAtividade(id);

    if (sucesso) {
      carregarAtividades();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Essa atividade não pode ser excluída.'),
        ),
      );
    }
  }

  void abrirAtividadePadrao(Map<String, dynamic> atividade) {
    final tipo = atividade['tipo_nome'];

    if (tipo == 'Estudar') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const EstudarScreen(),
        ),
      );
    } else if (tipo == 'Quiz') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const QuizListScreen(),
        ),
      );
    } else if (tipo == 'Fazer Prova') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProvaListScreen(),
        ),
      );
    }
  }

  void abrirModalCriarAtividade() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Nova atividade'),
          content: TextField(
            controller: nomeAtividadeController,
            decoration: const InputDecoration(
              hintText: 'Ex: Academia',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nomeAtividadeController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: criarAtividade,
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sair() async {
    await AuthService.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    nomeAtividadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text('Minhas Atividades'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PerfilScreen(),
                ),
              );
            },
          ),
          IconButton(
            onPressed: sair,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirModalCriarAtividade,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),

      body: loading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : Center(
        child: SizedBox(
          width: 1100,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [

                  SvgPicture.asset(
                    'assets/login.svg',
                    height: 100,width: 100,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Minhas Atividades',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Organize seus estudos e acompanhe seu progresso',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.analytics,
                          color: Colors.white,
                          size: 40,
                        ),

                        const SizedBox(width: 15),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${atividades.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Atividades cadastradas',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: atividades.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Nenhuma atividade encontrada',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: atividades.length,
                            itemBuilder: (context, index) {
                              final atividade =
                                  atividades[index];

                              final bool padrao =
                                  atividade['tipo_nome'] !=
                                      null;

                              String imagem =
                                  'assets/pessoal.svg';
                                  

                              if (atividade['tipo_nome'] ==
                                  'Estudar') {
                                imagem =
                                    'assets/ManualEstudar.svg';
                              } else if (atividade[
                                      'tipo_nome'] ==
                                  'Quiz') {
                                imagem =
                                    'assets/BulboQuiz.svg';
                              } else if (atividade[
                                      'tipo_nome'] ==
                                  'Fazer Prova') {
                                imagem =
                                    'assets/Prova.svg';
                              }

                              return Card(
                                elevation: 6,
                                margin:
                                    const EdgeInsets.only(
                                        bottom: 16),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(
                                          20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [

                                      Row(
                                        children: [

                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                AppColors
                                                    .primary
                                                    .withValues(
                                              alpha: 0.15,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets
                                                      .all(
                                                      8),
                                              child:
                                                  SvgPicture
                                                      .asset(
                                                imagem,
                                                width: 60,
                                                height: 60,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                              width: 15),

                                          Expanded(
                                            child: Text(
                                              atividade[
                                                  'nome_atividade'],
                                              style:
                                                  const TextStyle(
                                                fontSize:
                                                    22,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                          height: 15),

                                      Chip(
                                        label: Text(
                                          padrao
                                              ? 'Atividade padrão'
                                              : 'Atividade personalizada',
                                        ),
                                        backgroundColor:
                                            padrao
                                                ? AppColors
                                                    .primary
                                                    .withValues(
                                                        alpha:
                                                            0.15)
                                                : Colors.grey
                                                    .shade200,
                                      ),

                                      const SizedBox(
                                          height: 10),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            size: 18,
                                            color:
                                                Colors.green,
                                          ),
                                          const SizedBox(
                                              width: 5),
                                          Text(
                                            '${atividade['total_registros']} registros',
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                          height: 20),

                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: [

                                          ElevatedButton
                                              .icon(
                                            onPressed: () {
                                              registrar(
                                                  atividade[
                                                      'id']);
                                            },
                                            icon:
                                                const Icon(
                                                    Icons
                                                        .check),
                                            label:
                                                const Text(
                                              'Registrar',
                                            ),
                                          ),

                                          if (padrao)
                                            OutlinedButton
                                                .icon(
                                              onPressed: () {
                                                abrirAtividadePadrao(
                                                    atividade);
                                              },
                                              icon:
                                                  const Icon(
                                                Icons
                                                    .open_in_new,
                                              ),
                                              label:
                                                  const Text(
                                                'Abrir',
                                              ),
                                            ),

                                          if (!padrao)
                                            TextButton.icon(
                                              onPressed:
                                                  () {
                                                deletar(
                                                    atividade[
                                                        'id']);
                                              },
                                              icon:
                                                  const Icon(
                                                Icons
                                                    .delete,
                                                color: Colors
                                                    .red,
                                              ),
                                              label:
                                                  const Text(
                                                'Excluir',
                                                style:
                                                    TextStyle(
                                                  color: Colors
                                                      .red,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  }