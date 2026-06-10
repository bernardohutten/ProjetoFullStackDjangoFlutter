import 'package:flutter/material.dart';

import 'package:primeiroapp/core/theme/app_colors.dart';
import 'package:primeiroapp/services/avaliacao_service.dart';

class QuizDetailScreen extends StatefulWidget {
  final int avaliacaoId;

  const QuizDetailScreen({
    super.key,
    required this.avaliacaoId,
  });

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  Map<String, dynamic>? avaliacao;
  bool loading = true;
  bool enviando = false;

  Map<int, int> respostasMultipla = {};

  @override
  void initState() {
    super.initState();
    carregarQuiz();
  }

  Future<void> carregarQuiz() async {
    final dados = await AvaliacaoService.detalheAvaliacao(
      widget.avaliacaoId,
    );

    setState(() {
      avaliacao = dados;
      loading = false;
    });
  }

  Future<void> enviarRespostas() async {
    if (avaliacao == null) return;

    setState(() {
      enviando = true;
    });

    final respostas = respostasMultipla.entries.map((entry) {
      return {
        'questao_id': entry.key,
        'alternativa_id': entry.value,
      };
    }).toList();

    final sucesso = await AvaliacaoService.responderAvaliacao(
      avaliacaoId: widget.avaliacaoId,
      respostas: respostas,
    );

    setState(() {
      enviando = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso ? 'Quiz enviado com sucesso.' : 'Erro ao enviar quiz.',
        ),
      ),
    );

    if (sucesso) {
      Navigator.pop(context);
    }
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

  if (avaliacao == null) {
    return const Scaffold(
      body: Center(
        child: Text('Erro ao carregar quiz.'),
      ),
    );
  }

  final questoes = avaliacao!['questoes'] as List<dynamic>;

  return Scaffold(
    backgroundColor: const Color(0xFFEAF2FF),

    appBar: AppBar(
      title: Text(avaliacao!['titulo']),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    body: Center(
      child: SizedBox(
        width: 1000,
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [

                const Icon(
                  Icons.quiz,
                  size: 80,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 12),

                Text(
                  avaliacao!['titulo'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${questoes.length} questões',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: questoes.isEmpty
                      ? const Center(
                          child: Text(
                            'Este quiz ainda não possui questões.',
                          ),
                        )
                      : ListView.builder(
                          itemCount: questoes.length + 1,
                          itemBuilder: (context, index) {

                            if (index == questoes.length) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        enviando ? null : enviarRespostas,
                                    icon: const Icon(Icons.send),
                                    label: Text(
                                      enviando
                                          ? 'Enviando...'
                                          : 'Enviar Quiz',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.primary,
                                      foregroundColor:
                                          Colors.white,
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                          15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final questao = questoes[index];
                            final alternativas =
                                questao['alternativas']
                                    as List<dynamic>;

                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      'Questão ${index + 1}',
                                      style: TextStyle(
                                        color:
                                            AppColors.primary,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      questao['enunciado'],
                                      style:
                                          const TextStyle(
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 15),

                                    ...alternativas.map(
                                      (alternativa) {
                                        return RadioListTile<int>(
                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                              12,
                                            ),
                                          ),
                                          title: Text(
                                            alternativa[
                                                'texto'],
                                          ),
                                          value:
                                              alternativa['id'],
                                          groupValue:
                                              respostasMultipla[
                                                  questao[
                                                      'id']],
                                          onChanged:
                                              (valor) {
                                            if (valor !=
                                                null) {
                                              setState(() {
                                                respostasMultipla[
                                                    questao[
                                                        'id']] = valor;
                                              });
                                            }
                                          },
                                        );
                                      },
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