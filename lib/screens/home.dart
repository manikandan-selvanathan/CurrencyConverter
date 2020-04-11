import 'dart:convert';

import 'package:currency_converter_app/helper/colors.dart';
import 'package:currency_converter_app/helper/commonhelper.dart';
import 'package:currency_converter_app/model/currency.dart';
import 'package:currency_converter_app/services/webservice.dart';
import 'package:currency_converter_app/widgets/commonui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:currency_converter_app/helper/constants.dart';
import 'package:currency_converter_app/model/enums/enums.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:currency_converter_app/model/customersearch.dart';
import 'package:currency_converter_app/theme/style.dart';
import 'package:currency_converter_app/widgets/loginbackground.dart';
import 'package:path/path.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool isNetworkConnected = true;
  Currency currency;
  RoundedLoadingButtonController _convertController;
  TextEditingController _textEditingController;
  String fromCurrency;
  String toCurrency;
  String result;
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CustomerSearch> searchItems = new List<CustomerSearch>();
  CustomerSearch customerSearch = new CustomerSearch();

  @override
  void initState() {

    new Future.delayed(Duration.zero,() {
      fetchData();
    });


    _convertController = new RoundedLoadingButtonController();
    _textEditingController = new TextEditingController();
    getSearchHistory();
    super.initState();
  }

  void getSearchHistory() async {
    searchItems = await customerSearch.getSearchHistory();
    setState(() {});
  }

  void clearResult() {
    setState(() {
      result = "";
    });
  }

  void fetchData() async {
    try {
      if (isNetworkConnected = await isNetworkAvailable()) {
        WebService webService = new WebService();
        if (fromCurrency == null) {
          toggleLoading(true);
        }
        currency = await webService
            .fetchConversionRates(fromCurrency ?? INITIAL_CURRENCY_CODE);

        if (_textEditingController.text.isNotEmpty) {
          if (fromCurrency.toLowerCase() != toCurrency.toLowerCase()) {
            result = currency.convertTheValue(currency,
                _textEditingController.text, fromCurrency, toCurrency);
            setState(() {});
            await customerSearch.saveASearch("$fromCurrency$toCurrency",
                fromCurrency, toCurrency, _textEditingController.text);
            getSearchHistory();
          } else {
            showSnackBar(_scaffoldKey.currentState, SAME_CURRENCY_ERROR);
          }
        } else if (fromCurrency != null) {
          showSnackBar(_scaffoldKey.currentState, INVALID_AMOUNT_ERROR);
        }

        if (fromCurrency == null) {
          fromCurrency =
              enumToString(currency.conversionRates.keys.toList()[0]);
          toCurrency = enumToString(currency.conversionRates.keys.toList()[1]);
        }

        print(currency);
        toggleLoading(false);
      } else {
        toggleLoading(false);
        showNoInternetSnackbar(context, false);
      }
    } catch (err) {
      print("fetchData $err");
    }

    _convertController.reset();
  }

  Widget get _tags {
    if (searchItems.length <= 0) return SizedBox.shrink();

    return Tags(
      key: _tagStateKey,
      symmetry: false,
      horizontalScroll: false,
      itemCount: searchItems.length,
      itemBuilder: (index) {
        final item = searchItems[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: "${item.fromCurrency} - ${item.toCurrency}",
          pressEnabled: true,
          color: Colors.green,
          textColor: Colors.white,
          activeColor: Colors.green,
          textActiveColor: Colors.white,
          combine: ItemTagsCombine.withTextBefore,
//          icon: ItemTagsIcon(icon:Icons.history),
          removeButton: true
              ? ItemTagsRemoveButton(
                  onRemoved: () {
                    removeSearchHistory(item.id);
                    return true;
                  },
                )
              : null,
          splashColor: Colors.lightGreen,
          textScaleFactor:
              utf8.encode(item.id.substring(0, 1)).length > 2 ? 0.8 : 1,
          textStyle: TextStyle(
            fontSize: 16,
          ),
          onPressed: (item) {
            print(item);
            fromCurrency = searchItems[item.index].fromCurrency;
            toCurrency = searchItems[item.index].toCurrency;
            _textEditingController.text = searchItems[item.index].amount;
            clearResult();
          },
        );
      },
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Amount',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: _textEditingController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black, fontSize: 17),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.attach_money,
                color: Colors.green,
              ),
              hintText: 'Enter the amount',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  void removeSearchHistory(String id) async {
    await customerSearch.removeSearchHistory(id);
    getSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PrimaryColor,
        key: _scaffoldKey,
        body: getBody(context),
        bottomNavigationBar: getConvertButton());
  }

  Widget getConvertButton() {
    return BottomAppBar(
        child: Container(
            color: PrimaryColor,
            height: 100,
            child: Column(children: [
              Text(
                result ?? "",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              RoundedLoadingButton(
                color: Colors.green,
                child: Text(CONVERT_BUTTON_TEXT,
                    style: TextStyle(color: Colors.white)),
                controller: _convertController,
                onPressed: () {
                  fetchData();
                },
              ),
            ])));
  }

  void toggleLoading(bool isShow) {
    setState(() {
      if (mounted) {
        isLoading = isShow;
      }
    });
  }

  Widget getBody(BuildContext _context) {
    if (!isNetworkConnected) {
      return getPlaceholder(
          context, NO_INTERNET_MESSAGE, PlaceholderPages.no_internet,
          isButtonRequired: true,
          buttonText: REFRESH_BUTTON_TEXT,
          onButtonClicked: fetchData);
    } else if (isLoading) {
      return getiOSProgressBar();
    } else if (!isLoading && currency == null) {
      return getPlaceholder(
          context, NO_INTERNET_MESSAGE, PlaceholderPages.something_went_wrong,
          isButtonRequired: true,
          buttonText: REFRESH_BUTTON_TEXT,
          onButtonClicked: fetchData);
    }

    return Container(
      child: Stack(
        children: <Widget>[
          Background(),
          Container(
            margin: EdgeInsets.only(top: 250),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("\$ Currency Converter",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.green,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 30),
                  _buildEmailTF(),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Theme(
                            data: Theme.of(_context)
                                .copyWith(canvasColor: Colors.white),
                            child: new DropdownButton<String>(
                              isExpanded: true,
                              value: fromCurrency ?? "",
                              items: currency
                                  .getCountryCodes(currency.conversionRates)
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  fromCurrency = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.swap_horiz, color: Colors.green),
                          onPressed: () {
                            var oldValue = fromCurrency;
                            fromCurrency = toCurrency;
                            toCurrency = oldValue;
                            setState(() {});
                          },
                        ),
                        Expanded(
                          child: Theme(
                            data: Theme.of(_context)
                                .copyWith(canvasColor: Colors.white),
                            child: new DropdownButton<String>(
                              isExpanded: true,
                              value: toCurrency ?? "",
                              items: currency
                                  .getCountryCodes(currency.conversionRates)
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  toCurrency = newValue;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  _tags
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
