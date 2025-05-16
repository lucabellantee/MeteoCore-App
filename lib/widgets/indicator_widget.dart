import 'package:flutter/material.dart';

class IndicatorWidget extends StatelessWidget {
  final bool isActive;
  final Color color;
  final String label;

  const IndicatorWidget({
    super.key,
    required this.isActive,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? color : color.withOpacity(0.2),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
                boxShadow: isActive
                    ? [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ]
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              isActive ? 'Attivo' : 'Inattivo',
              style: TextStyle(
                fontSize: 14,
                color: isActive ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              '',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}