import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import 'package:conversor_moedas/custom_textField.dart';

//https://api.hgbrasil.com/finance/quotations?key=f2d449f7

class ConversorHome extends StatefulWidget{
  const ConversorHome({Key? key}) : super(key: key);

  @override
  ConversorHomeState createState () => ConversorHomeState();
}


class ConversorHomeState extends State<ConversorHome>{

  final TextEditingController realEditingController = TextEditingController();
  final TextEditingController dolarEditingController = TextEditingController();
  final TextEditingController euroEditingController = TextEditingController();
  final TextEditingController yenEditingController = TextEditingController();
  final TextEditingController bitcoinEditingController = TextEditingController();

  late double real;
  late double dolar;
  late double euro;
  late double yen;
  late double btc;

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Currency Converter",),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
            );
            default:
              if (snapshot.hasError){
                return Center(
                  child: Container(
                  color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Center(child: Text("Erro ao Carregar Dados..."),),
                  ),
                );
            }else{
              dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
              yen = snapshot.data!["results"]["currencies"]["JPY"]["buy"];
              btc = snapshot.data!["results"]["currencies"]["BTC"]["buy"];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    customTextField("Real", "R\$ ", realEditingController, realChanged),
                    customTextField("Dolar", "US\$ ", dolarEditingController, dolarChanged),
                    customTextField("Euro", "€ ", euroEditingController, euroChanged),
                    customTextField("Yen", " ¥ ", yenEditingController, yenChanged),
                    customTextField("Bitcoin", "₿ ", bitcoinEditingController, bitcoinChanged),
                  ],
                ),
              );
            }
          }
        }
      ),
    );
  }

  Future <Map> getData() async {
    var url = Uri.parse("https://api.hgbrasil.com/finance/quotations?key=f2d449f7");
    var response = await http.get(url);

    if (response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      throw Exception("Erro ao carregar dados do servidor");
    }
  }

  void realChanged (String text){
    if (text.isEmpty){
      dolarEditingController.text = "";
      euroEditingController.text = "";
      yenEditingController.text = "";
      bitcoinEditingController.text = "";
      return;
    }
    double real = double.parse(text);
    dolarEditingController.text = (real/dolar).toStringAsFixed(2);
    euroEditingController.text = (real/euro).toStringAsFixed(2);
    yenEditingController.text = (real/yen).toStringAsFixed(2);
    bitcoinEditingController.text = (real/btc).toStringAsFixed(2);
  }

  void dolarChanged (String text){
    if (text.isEmpty){
      realEditingController.text = "";
      euroEditingController.text = "";
      yenEditingController.text = "";
      bitcoinEditingController.text = "";
      return;
    }
    double dolar = double.parse(text);
    realEditingController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroEditingController.text = ((dolar * this.dolar)/euro).toStringAsFixed(2);
    yenEditingController.text = ((dolar * this.dolar)/yen).toStringAsFixed(2);
    bitcoinEditingController.text = ((dolar * this.dolar)/btc).toStringAsFixed(2);
  }

  void euroChanged (String text){
    if (text.isEmpty){
      realEditingController.text = "";
      dolarEditingController.text = "";
      yenEditingController.text = "";
      bitcoinEditingController.text = "";
      return;
    }
    double euro = double.parse(text);
    realEditingController.text = (euro * this.euro).toStringAsFixed(2);
    dolarEditingController.text = ((euro * this.euro)/dolar).toStringAsFixed(2);
    yenEditingController.text = ((euro * this.euro)/yen).toStringAsFixed(2);
    bitcoinEditingController.text = ((euro * this.euro)/btc).toStringAsFixed(2);
  }

  void yenChanged (String text){
    if (text.isEmpty){
      realEditingController.text = "";
      dolarEditingController.text = "";
      euroEditingController.text = "";
      bitcoinEditingController.text = "";
      return;
    }
    double yen = double.parse(text);
    realEditingController.text = (yen * this.yen).toStringAsFixed(2);
    dolarEditingController.text = ((yen * this.yen)/dolar).toStringAsFixed(2);
    euroEditingController.text = ((yen * this.yen)/euro).toStringAsFixed(2);
    bitcoinEditingController.text = ((yen * this.yen)/btc).toStringAsFixed(2);
  }

  void bitcoinChanged (String text){
    if (text.isEmpty){
      realEditingController.text = "";
      dolarEditingController.text = "";
      euroEditingController.text = "";
      yenEditingController.text = "";
      return;
    }
    double bitcoin = double.parse(text);
    realEditingController.text = (bitcoin * this.btc).toStringAsFixed(2);
    dolarEditingController.text = ((bitcoin * this.btc)/dolar).toStringAsFixed(2);
    euroEditingController.text = ((bitcoin * this.btc)/euro).toStringAsFixed(2);
    yenEditingController.text = ((bitcoin * this.btc)/btc).toStringAsFixed(2);
  }


}