
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:currency_converter_app/model/enums/enums.dart';
import 'package:currency_converter_app/helper/constants.dart';

Widget getPlaceholder(var myContext, var message, var placeholderPage,
    {var isButtonRequired = false, var buttonText, Function onButtonClicked}) {
  var imagePath = "assets/images/";
  switch (placeholderPage) {
    case PlaceholderPages.no_internet:
      imagePath = imagePath + "no_internet_placeholder.png";
      break;
    case PlaceholderPages.no_saved_item:
      imagePath = imagePath + "no_favorites_placeholder.png";
      break;
    case PlaceholderPages.something_went_wrong:
      imagePath = imagePath + "something_went_wrong_placeholder.png";
      break;
  }
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 250,
          width: 250,
          child: Image.asset(imagePath),
        ),
        Text(
          message, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,),
          textAlign: TextAlign.center,),
         _getButton(isButtonRequired,buttonText,onButtonClicked)
      ],
    ),
  );
}


Widget getiOSProgressBar() {
  return Container(
      color: Colors.white,
      child: Center(
          child: new CupertinoActivityIndicator()
      ));
}


Widget _getButton(var isButtonRequired, var buttonText,Function onClicked)
{
  if (isButtonRequired) {
    return RaisedButton(child: Text(buttonText),
        textColor: Colors.white,
        onPressed: ()
        {
          onClicked();
        });
  }
  else {
    return SizedBox.shrink();
  }
}


showNoInternetSnackbar(var context, bool isScaffoldState) {
  var con = isScaffoldState ? context : Scaffold.of(context);
  var sState = con as ScaffoldState;
  sState.hideCurrentSnackBar();
  showSnackBar(con, NO_INTERNET_MESSAGE_BODY);
}

Widget showSnackBar(var scaffold, var message) {
  try{
    final snackBar = SnackBar(content: Text(message));
    scaffold.showSnackBar(snackBar);
  }catch(err)
  {
    print("showSnackBar $err");
  }

}
