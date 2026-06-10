import 'package:flutter/material.dart';

class ConteudoDetailScreen extends StatelessWidget {
  final Map<String, dynamic> conteudo;

  const ConteudoDetailScreen({
    super.key,
    required this.conteudo,
  });

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFEAF2FF),

    appBar: AppBar(
      title: const Text('Conteúdo'),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),

    body: Center(
      child: SizedBox(
        width: 1000,
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          Colors.blue.withValues(
                        alpha: 0.15,
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Text(
                        conteudo['titulo'],
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Divider(
                  thickness: 1.5,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Conteúdo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  conteudo['texto'],
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.8,
                  ),
                ),

                const SizedBox(height: 40),

                const Divider(),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.check,
                    ),
                    label: const Text(
                      'Concluir leitura',
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 18,
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Leitura concluída!',
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