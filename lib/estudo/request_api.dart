import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=60df7606';

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

//Função que vem do futuro assincrona
Future<Map> getData() async {
  //requisição do dado do futuro salvo na variável response
  http.Response response = await http.get(request);
  // retorna um Json em formato de mapa, ou seja, um mapa no futuro
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('\$ Conversor \$'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      //peguei o futuro do GetData, passei para o FutureBuilder
      //a tela será consturida depedendo do que tiver no getData()
      // o body vai conter um Mapa porque recebe da api Json
      body: FutureBuilder<Map>(
          future: getData(),
          //builder estou especificando o que vai ser mostrado na tela
          //em casa um dos casos
          builder: (context, snapshot) {
            //switch no snapshot para vê o estado da conexão, se não estiver
            //conectado ou esperando uma conexão, ele vai retornar um widget centralizado
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              // retorno do widget centralizado caso, não haja conexão
                return const Center(
                  child: Text(
                    'Carregando Dados...',
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
            //caso ao contrário, se tem um erro retorna uma string centralizada
            //indicando um erro
              default:
                if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                        'Erro ao Carregando Dados :(',
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ));
                  // caso ao contrário, ou seja, caso não tenha nenhum erro
                  // retorna um container verder
                } else {
                  return Container(
                    color: Colors.greenAccent,
                  );
                }
            }
          }),
    );
  }
}
