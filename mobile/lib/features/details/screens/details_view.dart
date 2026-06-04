import 'package:flutter/material.dart';
import 'package:mongez/core/constants/endpoints.dart';
import 'package:mongez/features/checkout/screens/checkout_screen.dart';
import 'package:mongez/features/details/data/models/rating_model.dart';
import 'package:mongez/features/workers/data/models/worker_model.dart';
import 'package:mongez/generated/l10n.dart';
import 'package:mongez/services/api_service.dart';
import 'package:mongez/services/services_locator.dart';
import 'package:mongez/widgets/custom_app_bar.dart';
import 'package:mongez/widgets/custom_button.dart';
import 'package:mongez/widgets/favorite_button.dart';

class DetailsView extends StatefulWidget {
  final bool isCustomer;
  final WorkerModel worker;

  const DetailsView({
    super.key,
    required this.worker,
    required this.isCustomer,
  });

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  List<RatingModel> _ratings = [];
  bool _isLoadingRatings = true;
  String? _ratingsError;

  @override
  void initState() {
    super.initState();
    _fetchRatings();
  }

  Future<void> _fetchRatings() async {
    try {
      final apiService = getIt<ApiService>();
      final data = await apiService.get(
        endPoint: Endpoints.workerRatings(widget.worker.id),
      );
      final ratingsList = (data['ratings'] as List<dynamic>?)
              ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      setState(() {
        _ratings = ratingsList;
        _isLoadingRatings = false;
      });
    } catch (e) {
      setState(() {
        _ratingsError = e.toString();
        _isLoadingRatings = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final w = widget.worker;

    return Scaffold(
      appBar: CustomAppBar(title: lang.details),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildHeader(theme, colorScheme, textTheme),
          _buildWorkerInfo(theme, colorScheme, textTheme, lang, w),
          if (w.description.isNotEmpty)
            _buildSection(
              title: lang.description,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Text(
                  w.description,
                  style: textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ),
            ),
          _buildSection(
            title: lang.reviews,
            child: _buildReviewsContent(theme, colorScheme, textTheme, lang),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: CustomButton(
                text: widget.isCustomer ? lang.bookNow : lang.edit,
                onPressed: () {
                  if (widget.isCustomer) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutScreen(worker: w),
                      ),
                    );
                  }
                },
                backgroundColor: colorScheme.primary,
                textColor: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme, TextTheme textTheme) {
    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
            ),
            child: widget.worker.profileImage != null
                ? Image.network(
                    widget.worker.profileImage!,
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, s) => _buildHeaderFallback(colorScheme),
                  )
                : _buildHeaderFallback(colorScheme),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          // Favorite button
          if (widget.isCustomer)
            Positioned(
              top: 8,
              right: 8,
              child: FavoriteButton(
                workerId: widget.worker.userId ?? widget.worker.id,
              ),
            ),
          // Avatar overlapping bottom
          Positioned(
            bottom: -40,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.scaffoldBackgroundColor,
                border: Border.all(
                  color: theme.cardColor,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.08),
                child: ClipOval(
                  child: widget.worker.profileImage != null
                      ? Image.network(
                          widget.worker.profileImage!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, e, s) => Icon(
                            Icons.person,
                            size: 40,
                            color: colorScheme.primary,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 40,
                          color: colorScheme.primary,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderFallback(ColorScheme colorScheme) {
    return Center(
      child: Icon(
        Icons.person,
        size: 80,
        color: colorScheme.primary.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildWorkerInfo(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
    S lang,
    WorkerModel w,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              w.username ?? '',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star_rounded, size: 20, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  w.averageRating.toStringAsFixed(1),
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${w.completedJobs} ${lang.jobs})',
                  style: textTheme.bodySmall?.copyWith(
                    color: textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                  ),
                ),
                if (w.categoryName != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      w.categoryName!,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (w.experienceYears > 0) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.work_outline,
                    size: 18,
                    color: textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${w.experienceYears} ${lang.years} ${lang.experience}',
                    style: textTheme.bodySmall?.copyWith(
                      color: textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(thickness: 1),
          child,
        ],
      ),
    );
  }

  Widget _buildReviewsContent(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
    S lang,
  ) {
    if (_isLoadingRatings) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_ratingsError != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            lang.noReviews,
            style: textTheme.bodyMedium?.copyWith(
              color: textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    if (_ratings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            lang.noReviews,
            style: textTheme.bodyMedium?.copyWith(
              color: textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      itemCount: _ratings.length,
      itemBuilder: (context, index) {
        final rating = _ratings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.08),
                      child: Text(
                        (rating.clientName ?? '?')[0].toUpperCase(),
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        rating.clientName ?? lang.anonymous,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (i) {
                        return Icon(
                          i < rating.stars ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
                if (rating.review.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    rating.review,
                    style: textTheme.bodySmall?.copyWith(
                      height: 1.4,
                      color: textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
