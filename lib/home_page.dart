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
    super.initState();
    _mainVM=Provider.of<MainViewModel>(context,listen: false);
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
          future: _mainVM?.getCurrencyRate(),
          builder: (BuildContext context,AsyncSnapshot<ApiResponse> snapshot){
            if(snapshot.data?.status==Status.LOADING){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(snapshot.data?.status==Status.SUCCESS){
              return   ListView.builder(
                  itemCount: snapshot.data?.data.length,
                  itemBuilder: (BuildContext context,int index){
                    return SizedBox(
                      height: 50,
                      child: Card(
                          child:Row(
                            children: [
                              Text(
                                snapshot.data?.data[index].title ?? "...",
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 40,),
                              Text(
                                snapshot.data?.data[index].cb_price ?? "...",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          )

                      ),
                    );
                  }
              );
            }
            if(snapshot.data?.status==Status.ERROR){
              return buildError(snapshot.data?.message);

            }
            if(snapshot.data?.status==Status.INITIAL){
              return Center(child: Text(snapshot.data?.message ?? "Initial",
              style: TextStyle(fontSize: 24),),);
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
