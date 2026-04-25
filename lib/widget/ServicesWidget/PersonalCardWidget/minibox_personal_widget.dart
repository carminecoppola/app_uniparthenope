import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import '../../HomeWidget/personal_home_widget.dart';
import '../../../utilityFunctions/auth_utils_function.dart';
import 'avatar_widget.dart';

class PersonalMiniBoxWidget extends StatelessWidget {
  final String? nome;
  final String? cognome;
  final String? identificativoLabel;
  final String? identificativo;

  const PersonalMiniBoxWidget({
    super.key,
    required this.nome,
    required this.cognome,
    required this.identificativoLabel,
    required this.identificativo,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: PersonalCardUser.heroTag,
      child: Material(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(34),
        child: Container(
          width: 330,
          height: 146,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            gradient: AppColors.blueGradient,
            borderRadius: BorderRadius.circular(34),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${toCamelCase(nome)} ${toCamelCase(cognome)}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.backgroundColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      height: 1.02,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    identificativoLabel ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.76),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.35,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    identificativo ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.detailsColor,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const AvatarWidget(size: 58.0),
                                const SizedBox(height: 10),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: () {
                                      AuthUtilsFunction.qrCodeImg(context);
                                      Navigator.pushNamed(
                                          context, '/qrCodePage');
                                    },
                                    child: Ink(
                                      width: 44,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: const Icon(
                                        Icons.qr_code_2_rounded,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
