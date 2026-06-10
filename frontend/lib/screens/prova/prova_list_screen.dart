import 'package:flutter/material.dart';

import 'package:primeiroapp/core/theme/app_colors.dart';
import 'package:primeiroapp/services/avaliacao_service.dart';

import 'prova_detail_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ProvaListScreen extends StatefulWidget {
  const ProvaListScreen({super.key});

  @override
  State<ProvaListScreen> createState() => _ProvaListScreenState();
}

class _ProvaListScreenState extends State<ProvaListScreen> {
  List<dynamic> provas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarProvas();
  }

  Future<void> carregarProvas() async {
    final dados = await AvaliacaoService.listarAvaliacoes();

    setState(() {
      provas = dados.where((avaliacao) {
        return avaliacao['tipo'] == 'prova';
      }).toList();

      loading = false;
    });
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFEAF2FF),

    appBar: AppBar(
      title: const Text('Provas'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
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
                        'assets/Prova.svg',
                        height: 90,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'Área de Provas',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Resolva avaliações e acompanhe seu desempenho',
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
                              Icons.assignment,
                              color: Colors.white,
                              size: 40,
                            ),

                            const SizedBox(width: 15),

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  '${provas.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const Text(
                                  'Provas disponíveis',
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      Expanded(
                        child: provas.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [

                                    Icon(
                                      Icons.assignment_outlined,
                                      size: 80,
                                      color: Colors.grey,
                                    ),

                                    SizedBox(height: 12),

                                    Text(
                                      'Nenhuma prova disponível',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: provas.length,
                                itemBuilder:
                                    (context, index) {

                                  final prova =
                                      provas[index];

                                  return Card(
                                    elevation: 6,
                                    shadowColor:
                                        Colors.black12,
                                    margin:
                                        const EdgeInsets.only(
                                      bottom: 16,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        20,
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets
                                              .all(20),
                                      child: Row(
                                        children: [

                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                AppColors
                                                    .primary
                                                    .withValues(
                                              alpha: 0.15,
                                            ),
                                            child:
                                                SvgPicture
                                                    .asset(
                                              'assets/Prova.svg',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),

                                          const SizedBox(
                                              width: 15),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [

                                                Text(
                                                  prova[
                                                      'titulo'],
                                                  style:
                                                      const TextStyle(
                                                    fontSize:
                                                        20,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),

                                                const SizedBox(
                                                    height:
                                                        8),

                                                Chip(
                                                  avatar:
                                                      const Icon(
                                                    Icons
                                                        .help_outline,
                                                    size:
                                                        18,
                                                  ),
                                                  label:
                                                      Text(
                                                    '${prova['total_questoes']} questões',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          ElevatedButton
                                              .icon(
                                            icon:
                                                const Icon(
                                              Icons
                                                  .play_arrow,
                                            ),
                                            label:
                                                const Text(
                                              'Iniciar',
                                            ),
                                            onPressed:
                                                () {
                                              Navigator
                                                  .push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          ProvaDetailScreen(
                                                    avaliacaoId:
                                                        prova['id'],
                                                  ),
                                                ),
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