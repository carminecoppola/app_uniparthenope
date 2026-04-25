import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/taxes_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/TaxWidget/taxes_card.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/widget/custom_loading_indicator.dart';

import 'tab_view_tax.dart';

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

    if (allTaxesInfo == null) {
      return Center(
        child: CustomLoadingIndicator(
          text: AppLocalizations.of(context).translate('loading_fees'),
          myColor: AppColors.primaryColor,
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _FeesOverviewCard(
            pendingCount: allTaxesInfo.toPay.length,
            paidCount: allTaxesInfo.payed.length,
            status: allTaxesInfo.semaforo,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 14),
            decoration: const BoxDecoration(
              gradient: AppColors.blueGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                CustomTaxTabBar(tabController: _tabController),
                const SizedBox(height: 12),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPendingList(context, allTaxesInfo),
                      _buildPaidList(context, allTaxesInfo),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingList(BuildContext context, allTaxesInfo) {
    if (allTaxesInfo.toPay.isEmpty) {
      return _EmptyFeesState(
        icon: Icons.check_circle_outline,
        text: AppLocalizations.of(context).translate('empty_paid_fees'),
        color: AppColors.successColor,
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(
        0,
        4,
        0,
        MediaQuery.paddingOf(context).bottom + 112,
      ),
      children: allTaxesInfo.toPay
          .map<Widget>(
            (toPayItem) => TaxStudentCard(
              title: toPayItem.desc,
              codInvoice: toPayItem.fattId.toString(),
              paymentCode: toPayItem.iuv.toString(),
              date: toPayItem.scadFattura.toString(),
              amount: toPayItem.importo.toString(),
              isPaid: false,
            ),
          )
          .toList(),
    );
  }

  Widget _buildPaidList(BuildContext context, allTaxesInfo) {
    if (allTaxesInfo.payed.isEmpty) {
      return _EmptyFeesState(
        icon: Icons.receipt_long_outlined,
        text: AppLocalizations.of(context).translate('empty_completed_fees'),
        color: AppColors.lightGray,
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(
        0,
        4,
        0,
        MediaQuery.paddingOf(context).bottom + 112,
      ),
      children: allTaxesInfo.payed
          .map<Widget>(
            (payedItem) => TaxStudentCard(
              title: payedItem.desc,
              codInvoice: payedItem.fattId.toString(),
              paymentCode: (payedItem.iur ?? '').toString(),
              date: payedItem.dataPagamento.toString(),
              amount: payedItem.importo.toString(),
              isPaid: true,
            ),
          )
          .toList(),
    );
  }
}

class _FeesOverviewCard extends StatelessWidget {
  final int pendingCount;
  final int paidCount;
  final String? status;

  const _FeesOverviewCard({
    required this.pendingCount,
    required this.paidCount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);
    final statusLabel = _getStatus(status, context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.blueGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDarkColor.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context).translate('fees_summary_title'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(status),
                      size: 16,
                      color: statusColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.96),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _FeesHighlight(
                  label: AppLocalizations.of(context)
                      .translate('fees_pending_count'),
                  value: pendingCount.toString(),
                  icon: Icons.schedule_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FeesHighlight(
                  label:
                      AppLocalizations.of(context).translate('fees_paid_count'),
                  value: paidCount.toString(),
                  icon: Icons.check_circle_outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatus(String? currentStatus, BuildContext context) {
    if (currentStatus == 'ROSSO') {
      return AppLocalizations.of(context).translate('not_regular');
    } else if (currentStatus == 'GIALLO') {
      return AppLocalizations.of(context).translate('not_paid');
    } else if (currentStatus == 'VERDE') {
      return AppLocalizations.of(context).translate('regular');
    }
    return AppLocalizations.of(context).translate('fees_status_unknown');
  }

  Color _getStatusColor(String? currentStatus) {
    if (currentStatus == 'ROSSO') {
      return AppColors.errorColor;
    } else if (currentStatus == 'GIALLO') {
      return AppColors.detailsColor;
    } else if (currentStatus == 'VERDE') {
      return AppColors.successColor;
    }
    return Colors.white;
  }

  IconData _getStatusIcon(String? currentStatus) {
    if (currentStatus == 'ROSSO') {
      return Icons.error_outline_rounded;
    } else if (currentStatus == 'GIALLO') {
      return Icons.warning_amber_rounded;
    } else if (currentStatus == 'VERDE') {
      return Icons.check_circle_rounded;
    }
    return Icons.help_outline_rounded;
  }
}

class _FeesHighlight extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _FeesHighlight({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFeesState extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _EmptyFeesState({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 14),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDarkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
