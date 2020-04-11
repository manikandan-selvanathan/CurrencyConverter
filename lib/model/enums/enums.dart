enum PlaceholderPages {
  no_search_results,
  no_internet,
  no_saved_item,
  something_went_wrong
}

extension on CountryCodes {

  String toShortString() {
    return this.toString().split('.').last;
  }

}

enum CountryCodes {
  USD,
  AED,
  ARS,
  AUD,
  BGN,
  BRL,
  BSD,
  CAD,
  CHF,
  CLP,
  CNY,
  COP,
  CZK,
  DKK,
  DOP,
  EGP,
  EUR,
  FJD,
  GBP,
  GTQ,
  HKD,
  HRK,
  HUF,
  IDR,
  ILS,
  INR,
  ISK,
  JPY,
  KRW,
  KZT,
  MXN,
  MYR,
  NOK,
  NZD,
  PAB,
  PEN,
  PHP,
  PKR,
  PLN,
  PYG,
  RON,
  RUB,
  SAR,
  SEK,
  SGD,
  THB,
  TRY,
  TWD,
  UAH,
  UYU,
  ZAR
}
