import 'dart:convert';

import 'package:currency/models/api_responce.dart';
import 'package:currency/models/currency_rate.dart';
import 'package:currency/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  MainViewModel? _mainVM;
  void initState() {
    // TODO: implement initState
    //  _mainVM=Provider.of<MainViewModel>(context,listen: false);  Buni bu yerda chaqirishingiz shart emas sababi providerdan to'g'ridan to'g Listni chaqirsangiz bo'ladi;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Valyuta kursi',style: TextStyle(fontSize: 20),),
        actions: [
          buildRefresh()
        ],
      ),
      body:  Container(
          child: FutureBuilder(
            future: Provider.of<MainViewModel>(context).currencies,//_mainVM?.getCurrencyRate(),
            builder: (BuildContext context,AsyncSnapshot<List<CurrencyRate>> snapshot){
              if(!snapshot.hasData ){
                return const Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.hasData){
                return   ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context,int index){
                      return SizedBox(
                        height: 120,
                        child: Card(
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index].code ?? "...",
                                    style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 14,),
                                  Row(
                                    children: [
                                      Text(
                                        'Mb kursi',
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                      ),
                                      const SizedBox(width: 48,),
                                      const Text(
                                        'Sotib olish',
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                      ),
                                      const SizedBox(width: 46,),
                                      Text(
                                        'Sotish',
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Text( snapshot.data![index].cb_price ?? "...",
                                        style: const TextStyle(fontSize: 18),),
                                      const SizedBox(width: 40,),
                                      Text( snapshot.data![index].buy_price ?? "...",
                                        style: const TextStyle(fontSize: 18),),
                                      const SizedBox(width: 40,),
                                      Text( snapshot.data![index].cell_price ?? "...",
                                        style: const TextStyle(fontSize: 18),)
                                    ],
                                  )
                                ],
                              ),
                            )

                        ),
                      );
                    }
                );
              }
              if(snapshot.hasError){
                return buildError("Server bilan bog'lanishda muammo yuzaga keldi");
              }

              return Container();

            },
          )
      ),
    );
  }
  Widget buildError(String? errorM){
    return Center(child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorM ?? "Error",
            style: TextStyle(fontSize: 24),),
          buildRefresh()
        ]));

  }
  Widget buildRefresh(){
    return  IconButton(onPressed: (){
      setState(() {
        _mainVM?.getCurrencyRate();
      });
    },
      icon: Icon(Icons.replay),iconSize: 30,);
  }
}