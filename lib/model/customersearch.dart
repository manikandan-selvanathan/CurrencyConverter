import 'dart:convert';

import 'package:currency_converter_app/helper/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerSearch {
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final String amount;

  CustomerSearch({this.id, this.fromCurrency, this.toCurrency,this.amount});

  factory CustomerSearch.fromJson(Map<String, dynamic> json) {
    return CustomerSearch(
      id: json['id'],
      fromCurrency: json['fromCurrency'],
      toCurrency: json['toCurrency'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'fromCurrency': fromCurrency, 'toCurrency': toCurrency,'amount':amount};

  Future<List<CustomerSearch>> getSearchHistory() async {
    try {
      var ref = await SharedPreferences.getInstance();
      var raw = ref.getString(SHAREDPREFERENCES_SEARCH);
      var list = (raw != null && raw.isNotEmpty) ? jsonDecode(raw) : null;
      List<CustomerSearch> ids = new List<CustomerSearch>();
      if (list != null) {
        list.forEach((element) {
          ids.add(CustomerSearch.fromJson(element));
        });
      }
      return ids;
    } catch (err) {
      print("getAllOpenedNotification: $err");
      return null;
    }
  }

  Future<void> saveASearch(String query, String from, String to,String amount) async {
    try {
      var ref = await SharedPreferences.getInstance();
      var list = await getSearchHistory();
      var l=list.where((a)=>a.id==query).toList();
      if (l.length==0) {
        list.add(new CustomerSearch(
            id: "$from$to", fromCurrency: from, toCurrency: to,amount: amount));
      }
      var raw = jsonEncode(list);
      ref.setString(SHAREDPREFERENCES_SEARCH, raw);
    } catch (err) {
      print("saveASearch: $err");
    }
  }

  Future<List<CustomerSearch>> removeSearchHistory(String query) async {
    try {
      var oldList = await getSearchHistory();
      var ref = await SharedPreferences.getInstance();
      if (oldList != null) {
        oldList.removeWhere(
            (item) => item.id.toLowerCase() == query.toLowerCase());
      }
      var raw = jsonEncode(oldList);
      ref.setString(SHAREDPREFERENCES_SEARCH, raw);
      return oldList.toList();
    } catch (err) {
      print("removeSearchHistory: $err");
      return null;
    }
  }
}
