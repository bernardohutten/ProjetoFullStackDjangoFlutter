import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:primeiroapp/services/conteudo_service.dart';
import 'conteudo_detail_screen.dart';

class EstudarScreen extends StatefulWidget {
  const EstudarScreen({super.key});

  @override
  State<EstudarScreen> createState() => _EstudarScreenState();
}

class _EstudarScreenState extends State<EstudarScreen> {
  List<dynamic> conteudos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarConteudos();
  }

  Future<void> carregarConteudos() async {
    final dados = await ConteudoService.listarConteudos();

    setState(() {
      conteudos = dados;
      loading = false;
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFEAF2FF),

    appBar: AppBar(
      title: const Text('Estudar'),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),

    body: loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: SizedBox(
              width: 1000,
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
                        'assets/ManualEstudar.svg',
                        height: 90,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Área de Estudos',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Escolha um conteúdo para aprender',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Expanded(
                        child: ListView.builder(
                          itemCount: conteudos.length,
                          itemBuilder: (context, index) {
                            final conteudo = conteudos[index];

                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(18),
                                child: Row(
                                  children: [

                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                          Colors.blue
                                              .withValues(
                                        alpha: 0.15,
                                      ),
                                      child: const Icon(
                                        Icons.menu_book,
                                        color: Colors.blue,
                                        size: 28,
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [

                                          Text(
                                            conteudo['titulo'],
                                            style:
                                                const TextStyle(
                                              fontSize: 20,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),

                                          const SizedBox(
                                              height: 6),

                                          const Text(
                                            'Toque para ler o conteúdo',
                                            style: TextStyle(
                                              color:
                                                  Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.open_in_new,
                                      ),
                                      label:
                                          const Text('Abrir'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ConteudoDetailScreen(
                                              conteudo:
                                                  conteudo,
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