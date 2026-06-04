import 'package:flutter/material.dart';
import 'package:mongez/features/home/models/categories.dart';

class CustomCategory extends StatelessWidget {
  final CategoriesModel category;
  final VoidCallback? onTap;

  const CustomCategory({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: category.imageUrl != null
                  ? Image.network(
                      category.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.category,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                    )
                  : Icon(
                      Icons.category,
                      color: colorScheme.primary,
                      size: 28,
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name ?? "",
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
