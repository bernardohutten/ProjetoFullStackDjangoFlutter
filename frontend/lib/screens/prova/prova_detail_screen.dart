import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:primeiroapp/core/theme/app_colors.dart';
import 'package:primeiroapp/services/avaliacao_service.dart';

class ProvaDetailScreen extends StatefulWidget {
  final int avaliacaoId;

  const ProvaDetailScreen({
    super.key,
    required this.avaliacaoId,
  });

  @override
  State<ProvaDetailScreen> createState() => _ProvaDetailScreenState();
}

class _ProvaDetailScreenState extends State<ProvaDetailScreen> {
  Map<String, dynamic>? avaliacao;
  bool loading = true;
  bool enviando = false;

  Map<int, int> respostasMultipla = {};
  Map<int, TextEditingController> respostasAbertas = {};

  @override
  void initState() {
    super.initState();
    carregarProva();
  }

  Future<void> carregarProva() async {
    final dados = await AvaliacaoService.detalheAvaliacao(
      widget.avaliacaoId,
    );

    if (dados != null) {
      final questoes = dados['questoes'] as List<dynamic>;

      for (final questao in questoes) {
        if (questao['tipo'] == 'aberta') {
          respostasAbertas[questao['id']] = TextEditingController();
        }
      }
    }

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

    final List<Map<String, dynamic>> respostas = [];

    respostasMultipla.forEach((questaoId, alternativaId) {
      respostas.add({
        'questao_id': questaoId,
        'alternativa_id': alternativaId,
      });
    });

    respostasAbertas.forEach((questaoId, controller) {
      final texto = controller.text.trim();

      if (texto.isNotEmpty) {
        respostas.add({
          'questao_id': questaoId,
          'resposta_texto': texto,
        });
      }
    });

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
          sucesso
              ? 'Prova enviada com sucesso.'
              : 'Erro ao enviar prova.',
        ),
      ),
    );

    if (sucesso) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    for (final controller in respostasAbertas.values) {
      controller.dispose();
    }

    super.dispose();
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
        child: Text('Erro ao carregar prova.'),
      ),
    );
  }

  final questoes = avaliacao!['questoes'] as List<dynamic>;

  return Scaffold(
    backgroundColor: const Color(0xFFEAF2FF),

    appBar: AppBar(
      title: const Text('Prova'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),

    body: Center(
      child: SizedBox(
        width: 1100,
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [

                SvgPicture.asset(
                  'assets/login.svg',
                  height: 90,
                ),

                const SizedBox(height: 15),

                Text(
                  avaliacao!['titulo'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '${questoes.length} questões',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                LinearProgressIndicator(
                  value: questoes.isEmpty
                      ? 0
                      : respostasMultipla.length /
                          questoes.length,
                  minHeight: 10,
                  borderRadius:
                      BorderRadius.circular(10),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: questoes.isEmpty
                      ? const Center(
                          child: Text(
                            'Esta prova ainda não possui questões.',
                          ),
                        )
                      : ListView.builder(
                          itemCount: questoes.length,
                          itemBuilder:
                              (context, index) {

                            final questao =
                                questoes[index];

                            return Card(
                              elevation: 5,
                              margin:
                                  const EdgeInsets.only(
                                bottom: 20,
                              ),
                              shape:
                                  RoundedRectangleBorder(
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
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [

                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color:
                                            AppColors.primary,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          12,
                                        ),
                                      ),
                                      child: Text(
                                        'Questão ${index + 1}',
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 15),

                                    Text(
                                      questao[
                                          'enunciado'],
                                      style:
                                          const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 15),

                                    if (questao[
                                            'tipo'] ==
                                        'multipla')

                                      ...(questao[
                                                  'alternativas']
                                              as List)
                                          .map(
                                        (alternativa) {
                                          return Card(
                                            color: respostasMultipla[
                                                        questao[
                                                            'id']] ==
                                                    alternativa[
                                                        'id']
                                                ? AppColors
                                                    .primary
                                                    .withValues(
                                                  alpha:
                                                      0.15,
                                                )
                                                : null,
                                            child:
                                                RadioListTile<
                                                    int>(
                                              title: Text(
                                                alternativa[
                                                    'texto'],
                                              ),
                                              value:
                                                  alternativa[
                                                      'id'],
                                              groupValue:
                                                  respostasMultipla[
                                                      questao[
                                                          'id']],
                                              onChanged:
                                                  (valor) {
                                                if (valor !=
                                                    null) {
                                                  setState(
                                                    () {
                                                      respostasMultipla[
                                                              questao[
                                                                  'id']] =
                                                          valor;
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      ),

                                    if (questao[
                                            'tipo'] ==
                                        'aberta')

                                      TextField(
                                        controller:
                                            respostasAbertas[
                                                questao[
                                                    'id']],
                                        minLines: 4,
                                        maxLines: 8,
                                        decoration:
                                            InputDecoration(
                                          hintText:
                                              'Digite sua resposta...',
                                          filled: true,
                                          fillColor:
                                              Colors.grey
                                                  .shade100,
                                          border:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    icon: enviando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),

                    label: Text(
                      enviando
                          ? 'Enviando...'
                          : 'Enviar Prova',
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primary,
                      foregroundColor:
                          Colors.white,
                    ),

                    onPressed:
                        enviando ? null : enviarRespostas,
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