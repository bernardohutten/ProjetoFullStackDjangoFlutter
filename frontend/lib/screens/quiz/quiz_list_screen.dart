import 'package:flutter/material.dart';

import 'package:primeiroapp/core/theme/app_colors.dart';
import 'package:primeiroapp/services/avaliacao_service.dart';

import 'quiz_detail_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  List<dynamic> quizzes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarQuizzes();
  }

  Future<void> carregarQuizzes() async {
    final dados = await AvaliacaoService.listarAvaliacoes();

    setState(() {
      quizzes = dados.where((avaliacao) {
        return avaliacao['tipo'] == 'quiz';
      }).toList();

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFEAF2FF),

    appBar: AppBar(
      title: const Text('Quizzes'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
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
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [

                      SvgPicture.asset(
                        'assets/BulboQuiz.svg',
                        height: 90,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'Quizzes',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Teste seus conhecimentos e acompanhe sua evolução',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [

                            const Icon(
                              Icons.quiz,
                              color: Colors.white,
                              size: 40,
                            ),

                            const SizedBox(width: 15),

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  '${quizzes.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const Text(
                                  'Quizzes disponíveis',
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
                        child: quizzes.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [

                                    Icon(
                                      Icons.quiz_outlined,
                                      size: 80,
                                      color: Colors.grey,
                                    ),

                                    SizedBox(height: 12),

                                    Text(
                                      'Nenhum quiz disponível',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: quizzes.length,
                                itemBuilder: (context, index) {
                                  final quiz = quizzes[index];

                                  return Card(
                                    elevation: 5,
                                    shadowColor: Colors.black12,
                                    margin: const EdgeInsets.only(
                                      bottom: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(
                                        20,
                                      ),
                                      child: Row(
                                        children: [

                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                AppColors.primary
                                                    .withValues(
                                              alpha: 0.15,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets
                                                      .all(8),
                                              child:
                                                  SvgPicture.asset(
                                                'assets/BulboQuiz.svg',
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 15,
                                          ),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [

                                                Text(
                                                  quiz['titulo'],
                                                  style:
                                                      const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight
                                                            .bold,
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 6,
                                                ),

                                                Row(
                                                  children: [

                                                    const Icon(
                                                      Icons
                                                          .help_outline,
                                                      size: 18,
                                                      color:
                                                          Colors.grey,
                                                    ),

                                                    const SizedBox(
                                                      width: 5,
                                                    ),

                                                    Text(
                                                      '${quiz['total_questoes']} questões',
                                                      style:
                                                          const TextStyle(
                                                        color:
                                                            Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      QuizDetailScreen(
                                                    avaliacaoId:
                                                        quiz[
                                                            'id'],
                                                  ),
                                                ),
                                              );
                                            },
                                            style:
                                                ElevatedButton
                                                    .styleFrom(
                                              backgroundColor:
                                                  AppColors
                                                      .primary,
                                              foregroundColor:
                                                  Colors.white,
                                              padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                horizontal: 18,
                                                vertical: 14,
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.play_arrow,
                                            ),
                                            label: const Text(
                                              'Iniciar',
                                            ),
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