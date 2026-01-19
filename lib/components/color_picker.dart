import 'package:flutter/material.dart';
import 'package:mood_journal/theme/app_colors.dart';

class ColorPickerWidget extends StatelessWidget {
  final int selectedColorIndex;
  final Function(int) onColorSelected;
  const ColorPickerWidget({
    super.key,
    required this.onColorSelected,
    required this.selectedColorIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.noteColorsDark : AppColors.noteColors;

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose Color', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(colors.length, (index) {
              return GestureDetector(
                onTap: () => onColorSelected(index),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColorIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                  child: selectedColorIndex == index
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                ),
              );
            }),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
