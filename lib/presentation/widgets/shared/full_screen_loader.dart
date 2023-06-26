import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final List<String> messages = [
      'Espere por favor...',
      'Cargando películas...',
      'Cargando populares..',
      'Cargando...',
      'Ya casi...',
      'Esto está tardando más de lo esperado...',
      'Puta madre!!🤬...',
    ];

    return Stream.periodic( const Duration(seconds: 3), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 2,),
          const SizedBox(height: 20,),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if( !snapshot.hasData ) return const Text('Cargando...');

              return Text( snapshot.data! );
            },
          )
        ],
      )
    );
  }
}