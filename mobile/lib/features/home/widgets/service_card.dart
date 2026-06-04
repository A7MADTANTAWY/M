import 'package:flutter/material.dart';
import 'package:mongez/features/checkout/screens/checkout_screen.dart';
import 'package:mongez/features/details/screens/details_view.dart';
import 'package:mongez/features/workers/data/models/worker_model.dart';
import 'package:mongez/generated/l10n.dart';
import 'package:mongez/widgets/favorite_button.dart';

class ServiceCard extends StatelessWidget {
  final bool isCustomer;
  final WorkerModel worker;

  const ServiceCard({
    super.key,
    required this.worker,
    required this.isCustomer,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.3 : 0.06,
              ),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Banner section
            SizedBox(
              height: 84,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.35),
                            colorScheme.primary.withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isCustomer)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: FavoriteButton(workerId: worker.userId ?? worker.id),
                    ),
                  // Avatar overlapping bottom-left of banner
                  Positioned(
                    bottom: -28,
                    left: 16,
                    child: Hero(
                      tag: 'worker-avatar-${worker.id}',
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: colorScheme.surface,
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: colorScheme.primary.withValues(alpha: 0.08),
                          child: ClipOval(
                            child: worker.profileImage != null
                                ? Image.network(
                                    worker.profileImage!,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, e, s) => Icon(
                                      Icons.person,
                                      size: 26,
                                      color: colorScheme.primary,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 26,
                                    color: colorScheme.primary,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content below banner
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    worker.username ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 17, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(
                        worker.averageRating.toStringAsFixed(1),
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      if (worker.categoryName != null) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            worker.categoryName!,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                      if (worker.experienceYears > 0) ...[
                        const SizedBox(width: 10),
                        Icon(
                          Icons.work_outline,
                          size: 14,
                          color: textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${worker.experienceYears} ${lang.years}',
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (worker.description.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      worker.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        height: 1.4,
                        fontSize: 13,
                        color: textTheme.bodySmall?.color?.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isCustomer) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(worker: worker),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsView(
                                worker: worker,
                                isCustomer: isCustomer,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        isCustomer ? lang.bookNow : lang.edit,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
