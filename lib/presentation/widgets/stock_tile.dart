import 'package:flutter/material.dart';
import '../../data/models/stock_model.dart';

class StockTile extends StatelessWidget {
  final StockModel stock;
  final bool isEditMode;
  final VoidCallback? onDelete;

  const StockTile({
    super.key,
    required this.stock,
    this.isEditMode = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: isEditMode
          ? const Icon(Icons.drag_handle_rounded, color: Colors.grey)
          : null,
      title: Text(
        stock.symbol,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        '${stock.exchange} | ${stock.type.label}',
        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _priceText(stock.ltp),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: stock.isFlat
                      ? null
                      : (stock.isGaining ? Colors.green : Colors.red),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _changeText(),
                style: TextStyle(
                  fontSize: 11,
                  color: stock.isFlat
                      ? Colors.grey
                      : (stock.isGaining ? Colors.green : Colors.red),
                ),
              ),
            ],
          ),
          if (isEditMode) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Icon(Icons.remove, color: Colors.red, size: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _priceText(double value) {
    if (value >= 1000) {
      // comma format
      return value
          .toStringAsFixed(2)
          .replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return value.toStringAsFixed(2);
  }

  String _changeText() {
    if (stock.isFlat) return '0.00 (0.00%)';
    final sign = stock.isGaining ? '+' : '';
    return '$sign${stock.change.toStringAsFixed(2)} ($sign${stock.changePercent.toStringAsFixed(2)}%)';
  }
}
