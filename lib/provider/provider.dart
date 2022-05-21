import 'dart:convert';
import 'dart:io';

import 'package:currency/models/api_responce.dart';
import 'package:flutter/material.dart';

import '../models/currency_rate.dart';
import 'package:http/http.dart' as http;

class MainViewModel extends ChangeNotifier{

  ApiResponse _apiResponse=ApiResponse.initial('empty');
  final List<CurrencyRate> _currencyList=[];

  ApiResponse get response{
    return _apiResponse;
  }

  Future<List<CurrencyRate>>  currencies() async{
    // bu yerda getni  o'rniga  async funksiya qo'shdim sababi apidan kelyotgan malumotlarni  await qib turishi uchun
    await getCurrencyRate();
    return _currencyList;

  }
  Future<ApiResponse> getCurrencyRate() async{
    String url="https://nbu.uz/uz/exchange-rates/json/";
    Uri myUrl=Uri.parse(url);
    try{
    var response=await http.get(myUrl);
    List data =jsonDecode(response.body);
    _currencyList.clear();
    for (var element in data) {
      _currencyList.add(CurrencyRate.fromJson(element));
    }
    _apiResponse=ApiResponse.success(_currencyList.toString());
    }
    catch(exception){
      if(exception is SocketException){
        _apiResponse=ApiResponse.error("No Internet");
      }
    }

    return _apiResponse;
  }
}