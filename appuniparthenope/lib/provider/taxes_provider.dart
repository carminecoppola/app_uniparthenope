import 'package:flutter/material.dart';
import 'package:appuniparthenope/model/taxes_data.dart';

class TaxesDataProvider extends ChangeNotifier {
  TaxesInfo? _taxesInfo;

  TaxesInfo? get allTaxesInfo => _taxesInfo;

  // Metodo per impostare le informazioni sulle tasse
  void setTaxesInfo(TaxesInfo taxesInfo) {
    _taxesInfo = taxesInfo;
    notifyListeners();
  }
}
