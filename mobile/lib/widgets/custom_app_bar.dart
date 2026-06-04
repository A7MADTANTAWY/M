import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mongez/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:mongez/features/notifications/presentation/screens/notification_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.height = kToolbarHeight,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: centerTitle,

      leading: Navigator.canPop(context)
          ? IconButton(
              icon: Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_forward_ios
                    : Icons.arrow_back_ios_new,
                size: 20,
                color: textTheme.bodyLarge?.color,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,

      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 18),
          child: BlocBuilder<NotificationCubit, NotificationState>(
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
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
