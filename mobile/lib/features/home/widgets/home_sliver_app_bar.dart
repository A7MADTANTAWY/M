import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mongez/features/auth/models/user.dart';
import 'package:mongez/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:mongez/features/notifications/presentation/screens/notification_screen.dart';
import 'package:mongez/generated/l10n.dart';

class CustomSliverAppBarHome extends StatelessWidget {
  final User user;
  final bool isCustomer;
  const CustomSliverAppBarHome({super.key, required this.user, this.isCustomer = true});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SliverAppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      pinned: false,
      floating: false,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${lang.hello(user.username!)}\n👋',
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.address ?? '',
                        style: textTheme.bodySmall?.copyWith(
                          color: textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  final badgeCount = context.watch<NotificationCubit>().unreadCount;
                  return Badge(
                    isLabelVisible: badgeCount > 0,
                    label: Text('$badgeCount', style: const TextStyle(fontSize: 10)),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/notifaction.png',
                        width: 40,
                        height: 40,
                        color: colorScheme.onSecondary,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

