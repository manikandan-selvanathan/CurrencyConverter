import 'package:currency_converter_app/helper/commonhelper.dart';

import 'enums/enums.dart';

class Currency {
  String result;
  String documentation;
  String termsOfUse;
  String timeZone;
  int timeLastUpdate;
  int timeNextUpdate;
  String base;
  Map<CountryCodes, double> conversionRates;

  Currency(
      {this.result,
      this.documentation,
      this.termsOfUse,
      this.timeZone,
      this.timeLastUpdate,
      this.timeNextUpdate,
      this.base,
      this.conversionRates});

  Currency.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    documentation = json['documentation'];
    termsOfUse = json['terms_of_use'];
    timeZone = json['time_zone'];
    timeLastUpdate = json['time_last_update'];
    timeNextUpdate = json['time_next_update'];
    base = json['base'];
    conversionRates = ConversionRates.fromJson(json['conversion_rates']).rates;
  }

  List<String> getCountryCodes(Map<CountryCodes, double> conversionRates) {
    List<String> countryCodes = new List<String>();

    String value(CountryCodes value) {
      return value.toString().split('.').last;
    }

    conversionRates.forEach((k, v) => countryCodes.add(value(k)));
    return countryCodes;
  }

  String convertTheValue(Currency currency, String amount, String fromCurrency,
      String toCurrency) {
    double fromAmount = 1;
    double toAmount = 1;
    if (amount.isNotEmpty) {
      currency.conversionRates.forEach((k, v) {
        if (enumToString(k).toLowerCase() == fromCurrency.toLowerCase()) {
          fromAmount = v;
          return;
        } else if (enumToString(k).toLowerCase() == toCurrency.toLowerCase()) {
          toAmount = v;
        }
      });

      var result = (double.parse(amount) * fromAmount) * toAmount;
      return "$amount $fromCurrency  =  ${result.toStringAsFixed(2)} $toCurrency";
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['result'] = this.result;
      data['documentation'] = this.documentation;
      data['terms_of_use'] = this.termsOfUse;
      data['time_zone'] = this.timeZone;
      data['time_last_update'] = this.timeLastUpdate;
      data['time_next_update'] = this.timeNextUpdate;
      data['base'] = this.base;
      if (this.conversionRates != null) {
        data['conversion_rates'] = this.conversionRates.toString();
      }
      return data;
    }
  }
}

class ConversionRates {
  Map<CountryCodes, double> rates;

  ConversionRates({this.rates});

  factory ConversionRates.fromJson(Map<String, dynamic> json) {
    Map<CountryCodes, double> rates = {
      CountryCodes.USD: double.parse(json['USD'].toString()),
      CountryCodes.AED: double.parse(json['AED'].toString()),
      CountryCodes.ARS: double.parse(json['ARS'].toString()),
      CountryCodes.AUD: double.parse(json['AUD'].toString()),
      CountryCodes.BGN: double.parse(json['BGN'].toString()),
      CountryCodes.BRL: double.parse(json['BRL'].toString()),
      CountryCodes.BSD: double.parse(json['BSD'].toString()),
      CountryCodes.CAD: double.parse(json['CAD'].toString()),
      CountryCodes.CHF: double.parse(json['CHF'].toString()),
      CountryCodes.CLP: double.parse(json['CLP'].toString()),
      CountryCodes.CNY: double.parse(json['CNY'].toString()),
      CountryCodes.COP: double.parse(json['COP'].toString()),
      CountryCodes.CZK: double.parse(json['CZK'].toString()),
      CountryCodes.DKK: double.parse(json['DKK'].toString()),
      CountryCodes.DOP: double.parse(json['DOP'].toString()),
      CountryCodes.EGP: double.parse(json['EGP'].toString()),
      CountryCodes.EUR: double.parse(json['EUR'].toString()),
      CountryCodes.FJD: double.parse(json['FJD'].toString()),
      CountryCodes.GBP: double.parse(json['GBP'].toString()),
      CountryCodes.GTQ: double.parse(json['HKD'].toString()),
      CountryCodes.HKD: double.parse(json['HKD'].toString()),
      CountryCodes.HRK: double.parse(json['HRK'].toString()),
      CountryCodes.HUF: double.parse(json['HUF'].toString()),
      CountryCodes.IDR: double.parse(json['IDR'].toString()),
      CountryCodes.ILS: double.parse(json['ILS'].toString()),
      CountryCodes.ISK: double.parse(json['ISK'].toString()),
      CountryCodes.JPY: double.parse(json['JPY'].toString()),
      CountryCodes.KRW: double.parse(json['KRW'].toString()),
      CountryCodes.KZT: double.parse(json['KZT'].toString()),
      CountryCodes.MXN: double.parse(json['MXN'].toString()),
      CountryCodes.MYR: double.parse(json['MYR'].toString()),
      CountryCodes.NOK: double.parse(json['NOK'].toString()),
      CountryCodes.NZD: double.parse(json['NZD'].toString()),
      CountryCodes.PAB: double.parse(json['PAB'].toString()),
      CountryCodes.PEN: double.parse(json['PEN'].toString()),
      CountryCodes.PHP: double.parse(json['PHP'].toString()),
      CountryCodes.PKR: double.parse(json['PKR'].toString()),
      CountryCodes.PLN: double.parse(json['PLN'].toString()),
      CountryCodes.PYG: double.parse(json['PYG'].toString()),
      CountryCodes.RON: double.parse(json['RON'].toString()),
      CountryCodes.RUB: double.parse(json['RUB'].toString()),
      CountryCodes.SAR: double.parse(json['SAR'].toString()),
      CountryCodes.SEK: double.parse(json['SEK'].toString()),
      CountryCodes.SGD: double.parse(json['SGD'].toString()),
      CountryCodes.THB: double.parse(json['THB'].toString()),
      CountryCodes.TRY: double.parse(json['TRY'].toString()),
      CountryCodes.TWD: double.parse(json['TWD'].toString()),
      CountryCodes.UAH: double.parse(json['UAH'].toString()),
      CountryCodes.UYU: double.parse(json['UYU'].toString()),
      CountryCodes.ZAR: double.parse(json['ZAR'].toString()),
      CountryCodes.INR: double.parse(json['INR'].toString()),
    };

    return ConversionRates(rates: rates);
  }
}
