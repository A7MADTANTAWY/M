import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mongez/features/checkout/screens/addresses_screen.dart';
import 'package:mongez/features/checkout/screens/cards_screen.dart';
import 'package:mongez/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mongez/features/settings/screens/settings_screen.dart';
import 'package:mongez/generated/l10n.dart';
import 'package:mongez/services/navigation_service.dart';
import 'package:mongez/widgets/custom_app_bar.dart';
import 'add_service_screen.dart';

class AccountScreen extends StatelessWidget {
  final bool isCustomer;

  const AccountScreen({super.key, required this.isCustomer});

  void _logout(BuildContext context) {
    NavigationService.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: CustomAppBar(title: lang.account),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final profile = state is ProfileSuccess ? state.profile : null;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: theme.brightness == Brightness.dark ? 0.2 : 0.05,
                        ),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 68,
                        height: 68,
                        child: ClipOval(
                          child: profile?.profileImage != null
                              ? Image.network(
                                  profile!.profileImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.asset("assets/images/person.avif", fit: BoxFit.cover),
                                )
                              : Image.asset("assets/images/person.avif", fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.username ?? '...',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              profile?.phone ?? '',
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    profile?.address ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.edit, size: 20, color: textTheme.bodySmall?.color),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (!isCustomer) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (profile?.averageRating ?? 0).toStringAsFixed(1),
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${profile?.completedJobs ?? 0} ${lang.ratings}',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _AccountSection(
                    icon: Icons.add_box_outlined,
                    title: lang.addService,
                    subtitle: lang.addServiceDesc,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddServiceScreen()),
                      );
                    },
                  ),
                ],
                _AccountSection(
                  icon: Icons.location_on_outlined,
                  title: lang.addresses,
                  subtitle: lang.addressesDesc,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SavedAddressPage()),
                    );
                  },
                ),
                if (isCustomer)
                  _AccountSection(
                    icon: Icons.credit_card,
                    title: lang.paymentMethods,
                    subtitle: lang.paymentMethodsDesc,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CardsScreen()),
                      );
                    },
                  ),
                _AccountSection(
                  icon: Icons.settings,
                  title: lang.settings,
                  subtitle: lang.settingsDesc,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(lang.logout),
                        content: Text(lang.logoutConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(lang.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _logout(context);
                            },
                            child: Text(
                              lang.logout,
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.error),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: colorScheme.error),
                        const SizedBox(width: 8),
                        Text(
                          lang.logout,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.15 : 0.04,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: colorScheme.primary),
        ),
        title: Text(
          title,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle, style: textTheme.bodySmall),
        trailing: Icon(
          Directionality.of(context) == TextDirection.rtl
              ? Icons.arrow_back_ios
              : Icons.arrow_forward_ios,
          size: 16,
          color: textTheme.bodySmall?.color,
        ),
        onTap: onTap,
      ),
    );
  }
}
