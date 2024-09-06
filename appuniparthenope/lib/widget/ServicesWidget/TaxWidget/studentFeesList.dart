import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/taxes_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/TaxWidget/taxesCard.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';

import 'tabViewTax.dart';

class FeesStudent extends StatefulWidget {
  const FeesStudent({super.key});

  @override
  State<FeesStudent> createState() => _FeesStudentState();
}

class _FeesStudentState extends State<FeesStudent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    final allTaxesInfo = Provider.of<TaxesDataProvider>(context).allTaxesInfo;

    return Scaffold(
      body: allTaxesInfo != null
          ? Column(
              children: [
                CustomTaxTabBar(tabController: _tabController),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      child: Container(
                        color: AppColors.primaryColor,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Contenuto della scheda "Da pagare"
                            Container(
                              color: AppColors.primaryColor,
                              child: ListView(
                                children: allTaxesInfo.toPay.isEmpty
                                    ? [
                                        const SizedBox(height: 30),
                                        const Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle_outline,
                                                size: 64,
                                                color:
                                                    AppColors.backgroundColor,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Non ci sono tasse da pagare',
                                                style: TextStyle(
                                                  color:
                                                      AppColors.backgroundColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]
                                    : [
                                        Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: allTaxesInfo.toPay
                                                .map((toPayItem) =>
                                                    TaxStudentCard(
                                                      title: toPayItem.desc,
                                                      codInvoice: toPayItem
                                                          .fattId
                                                          .toString(),
                                                      codIUR: toPayItem.iuv
                                                          .toString(),
                                                      date: toPayItem
                                                          .scadFattura
                                                          .toString(),
                                                      amount: toPayItem.importo
                                                          .toString(),
                                                      isPaid: false,
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                            // Contenuto della scheda "Pagate"
                            Container(
                              color: AppColors.primaryColor,
                              child: ListView(
                                children: [
                                  const SizedBox(height: 30),
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: allTaxesInfo.payed
                                          .map((payedItem) => TaxStudentCard(
                                                title: payedItem.desc,
                                                codInvoice:
                                                    payedItem.fattId.toString(),
                                                codIUR:
                                                    payedItem.iur.toString(),
                                                date: payedItem.dataPagamento
                                                    .toString(),
                                                amount: payedItem.importo
                                                    .toString(),
                                                isPaid: true,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CustomLoadingIndicator(
                text: 'Caricamento delle tue tasse...',
                myColor: AppColors.primaryColor,
              ),
            ), // Mostra un CircularProgressIndicator se allTaxesInfo è null
    );
  }
}
