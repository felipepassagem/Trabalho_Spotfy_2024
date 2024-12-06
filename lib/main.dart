import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class Sport {
  final String nome;
  final String tipo;
  final String origem;
  final String popularidade;

  Sport({
    required this.nome,
    required this.tipo,
    required this.origem,
    required this.popularidade,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      nome: json['nome'],
      tipo: json['tipo'],
      origem: json['origem'],
      popularidade: json['popularidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipo': tipo,
      'origem': origem,
      'popularidade': popularidade,
    };
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String apiUrl = 'https://arquivos.ectare.com.br/esportes.json';
  List<Sport> sports = [];

  @override
  void initState() {
    super.initState();
    fetchSports();
  }

  Future<void> fetchSports() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          sports = (json.decode(response.body) as List)
              .map((e) => Sport.fromJson(e))
              .toList();
        });
      } else {
        throw Exception('Falha ao carregar dados');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addSport(Sport sport) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(sport.toJson()),
      );
      if (response.statusCode == 201) {
        setState(() {
          sports.add(sport);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateSport(int index, Sport updatedSport) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${sports[index].nome}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedSport.toJson()),
      );
      if (response.statusCode == 200) {
        setState(() {
          sports[index] = updatedSport;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteSport(int index) async {
    try {
      final response =
          await http.delete(Uri.parse('$apiUrl/${sports[index].nome}'));
      if (response.statusCode == 200) {
        setState(() {
          sports.removeAt(index);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(230, 230, 247, 255),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(230, 230, 247, 255),
          title: Text('Esportes API'),
        ),
        body: sports.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: sports.length,
                itemBuilder: (context, index) {
                  final sport = sports[index];
                  return Container(
                    color: index % 2 == 0
                        ? Colors.white // Fundo branco para itens pares
                        : Colors
                            .grey[200], // Fundo cinza claro para itens ímpares
                    child: ListTile(
                      title: Text(sport.nome),
                      subtitle: Text(
                        '${sport.tipo} - Origem: ${sport.origem} - Popularidade: ${sport.popularidade}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // IconButton(
                          //   icon: Icon(Icons.edit),
                          //   onPressed: () {
                          //     final updatedSport = Sport(
                          //       nome: sport.nome,
                          //       tipo: 'Editado',
                          //       origem: sport.origem,
                          //       popularidade: sport.popularidade,
                          //     );
                          //     updateSport(index, updatedSport);
                          //   },
                          // ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // deleteSport(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () {
        // final newSport = Sport(
        //   nome: 'Novo Esporte',
        //   tipo: 'Individual',
        //   origem: 'Teste',
        //   popularidade: 'Média',
        // );
        // addSport(newSport);
        // },
        // ),
      ),
    );
  }
}


//////////////////////////
//        SPOTFY       //
/////////////////////////




// import 'package:flutter/material.dart';

// void main() => runApp(const MeuApp());

// class MeuApp extends StatefulWidget {
//   const MeuApp({super.key});

//   @override
//   MeuSpotfy createState() {
//     return MeuSpotfy();
//   }
// }

// class MeuSpotfy extends State<MeuApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 50, 50, 50),
//                 Colors.black,
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Container(
//               margin: const EdgeInsets.all(15.0),
//               child: Form(
//                 child: spotfy(),
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: Colors.black,
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.grey,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Início',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.search),
//               label: 'Buscar',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.library_music),
//               label: 'Biblioteca',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget spotfy() {
//   return Column(children: [
//     titulo(),
//     ultimosAlbuns(),
//     lancamentos("assets/brotherinarms.png", "Brothers In Arms", "Dire Straits"),
//     miniPlayer("assets/brotherinarms.png", "Brothers In Arms", "Dire Straits")
//   ]);
// }

// Widget miniAlbum(String imagePath, String albumTitle) {
//   return Container(
//     decoration: BoxDecoration(color: Color.fromARGB(20, 255, 255, 255)),
//     margin: EdgeInsets.all(5),
//     child: Row(
//       children: [
//         Image.asset(
//           imagePath,
//           height: 55.0,
//           width: 55.0,
//           fit: BoxFit.cover,
//         ),
//         SizedBox(width: 10.0), // Espaçamento entre imagem e texto
//         Flexible(
//           child: Text(
//             albumTitle,
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//             maxLines: 1, // Limita a uma linha
//             overflow: TextOverflow.ellipsis, // Adiciona "..." se o texto for muito longo
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget ultimosAlbuns() {
//   return Column(
//     children: [
//       Row(children: [
//         Expanded(
//           flex: 5,
//           child: miniAlbum("assets/brotherinarms.png", "Brothers In Arms"),
//         ),
//         Expanded(
//           flex: 5,
//           child: miniAlbum("assets/brotherinarms.png", "Hounds Of Love"),
//         ),
//       ]),
//       Row(
//         children: [
//           Expanded(
//             flex: 5,
//             child: miniAlbum("assets/brotherinarms.png", "Meat Is Murder"),
//           ),
//           Expanded(
//             flex: 5,
//             child: miniAlbum(
//                 "assets/brotherinarms.png", "Songs From The Big Chair"),
//           ),
//         ],
//       ),
//       Row(
//         children: [
//           Expanded(
//               flex: 5,
//               child: miniAlbum(
//                   "assets/brotherinarms.png", "The Head On The Door")),
//           Expanded(flex: 5, child: miniAlbum("assets/brotherinarms.png", "Tim")),
//         ],
//       ),
//     ],
//   );
// }

// Widget titulo() {
//   return Padding(
//     padding: const EdgeInsets.only(top: 20.0), // Espaçamento superior
//     child: Row(children: [
//       Expanded(
//           flex: 6,
//           child: Text("Boa noite",
//               style: TextStyle(color: Colors.white, fontSize: 24.00))),
//       Expanded(
//           flex: 1,
//           child: Icon(
//             Icons.notifications_none,
//             color: Colors.white,
//             size: 24.0,
//           )),
//       Expanded(
//           flex: 1,
//           child: Icon(
//             Icons.history,
//             color: Colors.white,
//             size: 24.0,
//           )),
//       Expanded(
//           flex: 1,
//           child: Icon(
//             Icons.settings_outlined,
//             color: Colors.white,
//             size: 24.0,
//           )),
//     ]),
//   );
// }


// Widget lancamentos(String imagePath, String title, String artist) {
//   return Container(
//     margin: EdgeInsets.symmetric(vertical: 15.0),
//     padding: EdgeInsets.all(10.0),
//     decoration: BoxDecoration(
//       color: Color.fromARGB(30, 255, 255, 255),
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start, // Ajusta o alinhamento dos elementos
//       children: [
//         Text(
//           "Novo Lançamento de \n" + artist,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10.0), // Espaçamento entre o texto e a Row
//         Row(
//           children: [
//             Image.asset(
//               imagePath,
//               height: 60.0,
//               width: 60.0,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(width: 10.0),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14.0,
//                     ),
//                   ),
//                   Text(
//                     artist,
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12.0,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.favorite_border, color: Colors.white),
//               onPressed: () {
//                 // Ação ao favoritar
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.play_arrow, color: Colors.white),
//               onPressed: () {
//                 // Ação ao reproduzir
//               },
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }


// Widget miniPlayer(String imagePath, String songTitle, String artist) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//     decoration: BoxDecoration(
//       color: Colors.black,
//       boxShadow: [
//         BoxShadow(color: Colors.grey.shade900, blurRadius: 5, spreadRadius: 1),
//       ],
//     ),
//     child: Row(
//       children: [
//         Image.asset(
//           imagePath,
//           height: 50.0,
//           width: 50.0,
//           fit: BoxFit.cover,
//         ),
//         SizedBox(width: 10.0),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 songTitle,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14.0,
//                 ),
//               ),
//               Text(
//                 artist,
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12.0,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         IconButton(
//           icon: Icon(Icons.pause, color: Colors.white),
//           onPressed: () {
//             // Ação ao pausar
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.skip_next, color: Colors.white),
//           onPressed: () {
//             // Ação ao pular para a próxima música
//           },
//         ),
//       ],
//     ),
//   );
// }


//////////////////////////
//        SPOTFY       //
/////////////////////////










































// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: meuLayoutWidget(),
//       ),
//     );
//   }
// }

// Widget meuLayoutWidget() {
//   return Row(
//     children: [
//       Text("A"),
//       Text("B"),
//       Text("C"),
//     ],
//   );
// }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: Text('Layout Flutter', style: TextStyle(color: Colors.white)),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Container(
//                 color: Colors.green,
//                 width: double.infinity,
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'Felipe Passagem',
//                   style: TextStyle(color: Colors.white, fontSize: 18.0),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text('Item 1'),
//                   Text('Item 2'),
//                   Text('Item 3'),
//                 ],
//               ),
//               SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Container(
//                     color: Colors.red,
//                     padding: EdgeInsets.all(16.0),
//                     child: Text('X', style: TextStyle(color: Colors.white)),
//                   ),
//                   Container(
//                     color: Colors.yellow,
//                     padding: EdgeInsets.all(16.0),
//                     child: Text('Y', style: TextStyle(color: Colors.white)),
//                   ),
//                   Container(
//                     color: Colors.green,
//                     padding: EdgeInsets.all(16.0),
//                     child: Text('Z', style: TextStyle(color: Colors.white)),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Icon(Icons.heat_pump_rounded, color: Colors.pink),
//                   Icon(Icons.favorite, color: Colors.green),
//                   Icon(Icons.send, color: Colors.blue),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//##################################################

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// void main() => runApp(MeuApp());

// class MeuApp extends StatefulWidget {
//   @override
//   MeuFormulario createState() {
//     return MeuFormulario();
//   }
// }

// class MeuFormulario extends State<MeuApp> {
//   final _formKey = GlobalKey<FormState>();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _scaffoldMsgKey = GlobalKey<ScaffoldMessengerState>();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       scaffoldMessengerKey: _scaffoldMsgKey,
//       home: Scaffold(
//           key: _scaffoldKey,
//           appBar: AppBar(title: Text("Exemplo de Formulário")),
//           body: SingleChildScrollView(
//             child: Container(
//               margin: EdgeInsets.all(15.0),
//               child: Form(
//                 key: _formKey,
//                 child: MeuFormularioUi(_scaffoldKey, _formKey, _scaffoldMsgKey),
//               ),
//             ),
//           )),
//     );
//   }
// }

// Widget MeuFormularioUi(var _scaffoldKey, var _formKey, var _scaffoldMsgKey) {
//   var _nome;
//   var _idade;

//   return Column(
//     children: [
//       Text("Meu Formulário"),
//       TextFormField(
//           decoration: InputDecoration(labelText: "Nome:"),
//           maxLength: 50,
//           onSaved: (val) {
//             _nome = val;
//           }),
//       TextFormField(
//           decoration: InputDecoration(labelText: "Idade:"),
//           maxLength: 3,
//           keyboardType: TextInputType.number,
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           onSaved: (val) {
//             _idade = val;
//           }),
//       ElevatedButton(
//           onPressed: () {
//             _formKey.currentState.save();
//             _scaffoldMsgKey.currentState.showSnackBar(SnackBar(
//               content: Text("Olá $_nome, você tem $_idade anos"),
//             ));
//           },
//           child: const Text("Calcular"))
//     ],
//   );
// }

//################### FIM #################

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:math' as math;

// void main() => runApp(MeuApp());

// class MeuApp extends StatefulWidget {
//   @override
//   MeuFormulario createState() {
//     return MeuFormulario();
//   }
// }

// class MeuFormulario extends State<MeuApp> {
//   final _formKey = GlobalKey<FormState>();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _scaffoldMsgKey = GlobalKey<ScaffoldMessengerState>();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       scaffoldMessengerKey: _scaffoldMsgKey,
//       home: Scaffold(
//           key: _scaffoldKey,
//           appBar: AppBar(title: Text("Exemplo de Formulário")),
//           body: SingleChildScrollView(
//             child: Container(
//               margin: EdgeInsets.all(15.0),
//               child: Form(
//                 key: _formKey,
//                 child: MeuFormularioUi(_scaffoldKey, _formKey, _scaffoldMsgKey),
//               ),
//             ),
//           )),
//     );
//   }
// }

// Widget MeuFormularioUi(var _scaffoldKey, var _formKey, var _scaffoldMsgKey) {
//   var _gasolina;
//   var _etanol;
//   var _distancia;

//   return Column(
//     children: [
//       Icon(Icons.directions_car_filled,
//           color: const Color.fromARGB(255, 162, 7, 7)),
//       TextFormField(
//           decoration: InputDecoration(labelText: "Gasolina:"),
//           maxLength: 8,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
//           ],
//           onSaved: (val) {
//             _gasolina = val;
//           }),
//       TextFormField(
//           decoration: InputDecoration(labelText: "Etanol:"),
//           maxLength: 8,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
//           ],
//           onSaved: (val) {
//             _etanol = val;
//           }),
//       TextFormField(
//           decoration: InputDecoration(labelText: "Distancia:"),
//           maxLength: 8,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
//           ],
//           onSaved: (val) {
//             _distancia = val;
//           }),
//       ElevatedButton(
//           onPressed: () {
//             _formKey.currentState.save();
//             var calculoGasolina = (double.parse(_distancia) / 12) * double.parse(_gasolina);
//             var calculoEtanol = (double.parse(_distancia) / 9) * double.parse(_etanol);
//             // if(calculoGasolina>calculoEtanol)

//             _scaffoldMsgKey.currentState.showSnackBar(SnackBar(
//               content: Text("Valores:"),
//             ));
//           },
//           child: const Text("Calcular"))
//     ],
//   );
// }

// Widget MeuFormularioUi(var _scaffoldKey, var _formKey, var _scaffoldMsgKey) {
//   var _gasolina;
//   var _etanol;
//   var _distancia;

//   return Column(
//     children: [
//       Icon(Icons.directions_car_filled,
//           color: const Color.fromARGB(255, 162, 7, 7)),
//       TextFormField(
//           decoration: InputDecoration(labelText: "Gasolina:"),
//           maxLength: 8,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
//           ],
//           onSaved: (val) {
//             _gasolina = val;
//           }),
//       TextFormField(
//           decoration: InputDecoration(labelText: "Etanol:"),
//           maxLength: 8,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
//           ],
//           onSaved: (val) {
//             _etanol = val;
//           }),
//       TextFormField(
//           decoration: InputDecoration(labelText: "Distancia:"),
//           maxLength: 8,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
//           ],
//           onSaved: (val) {
//             _distancia = val;
//           }),
//       ElevatedButton(
//           onPressed: () {
//             _formKey.currentState.save();
//             var calculoGasolina = (double.parse(_distancia) / 12) * double.parse(_gasolina);
//             var calculoEtanol = (double.parse(_distancia) / 9) * double.parse(_etanol);
//             // if(calculoGasolina>calculoEtanol)
            

//             _scaffoldMsgKey.currentState.showSnackBar(SnackBar(
//               content: Text("Valores:"),
//             ));
//           },
//           child: const Text("Calcular"))
//     ],
//   );
// }

