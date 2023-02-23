import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=60df7606';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: const Color(0XFF171513),
        primaryColor: const Color(0XFFC5E2BE),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0XFF171513))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0XFF171513))),
          hintStyle: TextStyle(color: Color(0XFF171513)),
        )),
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
  late double dolar;
  late double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFF6EB),
      appBar: AppBar(
        title: const Text('\$ Conversor \$'),
        backgroundColor: const Color(0XFFC5E2BE),
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
                    style: TextStyle(color: Color(0XFFC5E2BE), fontSize: 25.0),
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
                        style: TextStyle(color: Color(0XFFC5E2BE), fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ));
                  // caso ao contrário, ou seja, caso não tenha nenhum erro
                  // retorna um container verder
                } else {
                  dolar = snapshot.data!['results']['currencies']['USD']['buy'];
                  euro = snapshot.data!['results']['currencies']['USD']['buy'];

                  return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            size: 150.0,
                            color: Color(0XFFC5E2BE),
                          ),
                          //botão Input
                          Divider(),
                          builTextFiel('Reais', '\$'),
                          Divider(),
                          builTextFiel('Dólar', '\$'),
                          Divider(),
                          builTextFiel('Euro', '€'),
                        ],
                      ));
                }
            }
          }),
    );
  }
}

Widget builTextFiel(String label, String prefix) {
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0XFF171513), fontSize: 20.0),
      border: const OutlineInputBorder(),
      prefixText: prefix,
    ),
  );
}
