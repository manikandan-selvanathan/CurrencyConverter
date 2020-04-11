
import 'package:connectivity/connectivity.dart';

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

String enumToString(var value)
{
  return value.toString()
    .split('.')
  .last;
}