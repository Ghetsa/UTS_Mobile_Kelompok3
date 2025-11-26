import 'package:flutter/material.dart';
import 'keuangan_stat_card.dart';

class StatCardRow extends StatelessWidget {
  final List<StatCard> cards;

  const StatCardRow({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: cards.map((card) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: card,
          ),
        );
      }).toList(),
    );
  }
}
