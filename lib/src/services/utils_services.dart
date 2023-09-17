import 'package:intl/intl.dart';

class UtilsServices {
  String priceToCurrency(double price) {
    NumberFormat numberFormat =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return numberFormat.format(price);
  }
}
