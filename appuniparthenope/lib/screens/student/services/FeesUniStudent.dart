import "package:appuniparthenope/main.dart";
import "package:appuniparthenope/provider/taxes_provider.dart";
import "package:appuniparthenope/widget/ServicesWidget/TaxCategoryCard.dart";
import "package:appuniparthenope/widget/ServicesWidget/taxesCard.dart";
import "package:appuniparthenope/widget/bottomNavBar.dart";
import "package:appuniparthenope/widget/navbar.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class FeesUniStudentPage extends StatefulWidget {
  const FeesUniStudentPage({super.key});

  @override
  State<FeesUniStudentPage> createState() => _FeesUniStudentState();
}

class _FeesUniStudentState extends State<FeesUniStudentPage> {
  @override
  Widget build(BuildContext context) {
    final allTaxesInfo = Provider.of<TaxesDataProvider>(context).allTaxesInfo;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (allTaxesInfo != null)
              Center(
                child: Container(
                  width: 350,
                  height: 550,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 320,
                        height: 50,
                        decoration: BoxDecoration(
                          color: getColorForStatus(allTaxesInfo.semaforo),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            allTaxesInfo.semaforo == 'ROSSO'
                                ? 'SCADUTE'
                                : allTaxesInfo.semaforo == 'GIALLO'
                                    ? 'DA PAGARE'
                                    : 'REGOLARE',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TaxCategoryCard(
                                  title: 'Tasse da pagare',
                                  iconColor: Colors.white,
                                  backgroundColor: AppColors.accentColor,
                                  children: allTaxesInfo.toPay
                                      .map((toPayItem) => TaxStudentCard(
                                            title: toPayItem.desc,
                                            codInvoice:
                                                toPayItem.fattId.toString(),
                                            codIUR: toPayItem.iuv.toString(),
                                            date: toPayItem.scadFattura
                                                .toString(),
                                            amount:
                                                toPayItem.importo.toString(),
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 20),
                                TaxCategoryCard(
                                  title: 'Storico pagamenti',
                                  iconColor: Colors.white,
                                  backgroundColor: AppColors.successColor,
                                  children: allTaxesInfo.payed
                                      .map((payedItem) => TaxStudentCard(
                                            title: payedItem.desc,
                                            codInvoice:
                                                payedItem.fattId.toString(),
                                            codIUR: payedItem.iur.toString(),
                                            date: payedItem.dataPagamento
                                                .toString(),
                                            amount:
                                                payedItem.importo.toString(),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }

  Color getColorForStatus(String status) {
    if (status == 'ROSSO') {
      return AppColors.errorColor;
    } else if (status == 'GIALLO') {
      return AppColors.detailsColor;
    } else if (status == 'VERDE') {
      return AppColors.successColor;
    } else {
      return AppColors.lightGray;
    }
  }
}
