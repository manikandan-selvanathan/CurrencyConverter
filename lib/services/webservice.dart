import 'dart:convert';

import 'package:currency_converter_app/helper/constants.dart';
import 'package:currency_converter_app/model/currency.dart';
import 'package:http/http.dart' as http;

class WebService
{

  final String _baseURL="https://prime.exchangerate-api.com/v5/$API_KEY/latest/";

  http.Client _httpClient;

  WebService()
  {
    this._httpClient=http.Client();
  }

  Future<Currency> fetchConversionRates(String baseCurrency) async
  {
    try
    {

      final url = '$_baseURL/$baseCurrency';
      final response = await this._httpClient.get(url);

      if (response.statusCode != 200) {
        throw new Exception('error getting quotes');
      }
      print(response.body);
      final Currency json = Currency.fromJson(jsonDecode(response.body));
      return json;

    }
    catch(err)
    {
      print("fetchConversionRates $err");
      return null;
    }
  }

}