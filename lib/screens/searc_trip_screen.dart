import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/models/trip_model.dart';
import 'package:trips/providers/search/search_controller.dart';
import 'package:trips/providers/trip/trip_controller.dart';
import 'package:trips/screens/trip_plan_screen.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';

class SearchTripsScreen extends ConsumerStatefulWidget {
  static const routeName = '/search-trips';

  final String? initialMonth;
  final String? initialYear;
  final String? initialCategory;

  const SearchTripsScreen({
    super.key,
    this.initialMonth,
    this.initialYear,
    this.initialCategory,
  });

  @override
  ConsumerState<SearchTripsScreen> createState() => _SearchTripsScreenState();
}

class _SearchTripsScreenState extends ConsumerState<SearchTripsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();

    // Handle initial filters from navigation
    if (widget.initialCategory != null && widget.initialCategory!.isNotEmpty) {
      _searchController.text = widget.initialCategory!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchProvider.notifier).filterByMonthYearCategory(
          widget.initialMonth ?? 'Sep',
          widget.initialYear ?? '2025',
          widget.initialCategory!,
        );
      });
    }

    _searchController.addListener(() {
      ref.read(searchProvider.notifier).setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatMonthYear(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final searchState = ref.watch(searchProvider);
    final tripState = ref.watch(tripProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          widget.initialCategory != null
              ? '${widget.initialCategory} Trips'
              : 'Search Trips',
          style: AppTextStyles.h2(context),
        ),
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: colors.divider, height: 1),
        ),
      ),
      body: Column(
        children: [
          // Month/Year Banner (if coming from calendar)
          if (widget.initialMonth != null && widget.initialYear != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: colors.primary.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.calendar_month, size: 16, color: colors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Available trips in ${widget.initialMonth} ${widget.initialYear}',
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: colors.inputSearch,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, size: 20, color: colors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by destination...',
                        hintStyle: TextStyle(color: colors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: TextStyle(color: colors.textPrimary),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, size: 18, color: colors.textSecondary),
                      onPressed: () => _searchController.clear(),
                    ),
                  IconButton(
                    icon: Icon(
                      _showFilters ? Icons.filter_list : Icons.filter_list,
                      color: _showFilters ? colors.primary : colors.textSecondary,
                    ),
                    onPressed: () => setState(() => _showFilters = !_showFilters),
                  ),
                ],
              ),
            ),
          ),

          // Filters Section
          if (_showFilters)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  // Sort Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sort By',
                              style: AppTextStyles.h3(context).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  searchState.sortAscending ? 'Ascending' : 'Descending',
                                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                                ),
                                IconButton(
                                  icon: Icon(
                                    searchState.sortAscending
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 18,
                                    color: colors.primary,
                                  ),
                                  onPressed: () => ref.read(searchProvider.notifier).toggleSortOrder(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildSortChip('Price', 'price', colors),
                            _buildSortChip('Rating', 'rating', colors),
                            _buildSortChip('Name', 'title', colors),
                            _buildSortChip('Start Date', 'startDate', colors),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Status Filter Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter by Status',
                          style: AppTextStyles.h3(context).copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildFilterChip('All', 'all', colors),
                            _buildFilterChip('Upcoming', 'upcoming', colors),
                            _buildFilterChip('Ongoing', 'ongoing', colors),
                            _buildFilterChip('Completed', 'completed', colors),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Reset Filters Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchProvider.notifier).resetFilters();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Filters'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.primary,
                        side: BorderSide(color: colors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Results Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${searchState.searchResults.length} trips available',
                  style: TextStyle(color: colors.textSecondary),
                ),
                if (searchState.searchQuery.isNotEmpty)
                  Text(
                    'Search: "${searchState.searchQuery}"',
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (searchState.sortBy == 'startDate')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          searchState.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 12,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Start Date ${searchState.sortAscending ? '(Earliest first)' : '(Latest first)'}',
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Results List
          Expanded(
            child: tripState.isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: colors.primary,
              ),
            )
                : searchState.searchResults.isEmpty
                ? _buildEmptyState(colors)
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: searchState.searchResults.length,
              itemBuilder: (context, index) {
                final trip = searchState.searchResults[index];
                return _buildTripCard(trip, colors);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value, AppColors colors) {
    final isSelected = ref.watch(searchProvider).sortBy == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) ref.read(searchProvider.notifier).setSortBy(value);
      },
      backgroundColor: colors.surface,
      selectedColor: colors.primary,
      checkmarkColor: colors.onPrimary,
      labelStyle: TextStyle(
        color: isSelected ? colors.onPrimary : colors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? colors.primary : colors.border,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, AppColors colors) {
    final isSelected = ref.watch(searchProvider).filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) ref.read(searchProvider.notifier).setFilterStatus(value);
      },
      backgroundColor: colors.surface,
      selectedColor: colors.primary,
      checkmarkColor: colors.onPrimary,
      labelStyle: TextStyle(
        color: isSelected ? colors.onPrimary : colors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? colors.primary : colors.border,
        ),
      ),
    );
  }

  Widget _buildTripCard(TripModel trip, AppColors colors) {
    // Determine trip status for badge
    String getTripStatus() {
      final now = DateTime.now();
      if (trip.startDate.isAfter(now)) {
        return 'UPCOMING';
      } else if (trip.startDate.isBefore(now) && trip.endDate.isAfter(now)) {
        return 'ONGOING';
      } else if (trip.endDate.isBefore(now)) {
        return 'COMPLETED';
      }
      return 'AVAILABLE';
    }

    Color getStatusColor() {
      final now = DateTime.now();
      if (trip.startDate.isAfter(now)) {
        return Colors.blue;
      } else if (trip.startDate.isBefore(now) && trip.endDate.isAfter(now)) {
        return Colors.orange;
      } else if (trip.endDate.isBefore(now)) {
        return Colors.grey;
      }
      return Colors.green;
    }

    final status = getTripStatus();
    final statusColor = getStatusColor();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TripPlanScreen(trip: trip),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Trip Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: Image.network(
                trip.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: colors.surface,
                  child: Icon(
                    Icons.broken_image,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),

            // Trip Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      trip.title,
                      style: AppTextStyles.h3(context).copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            trip.location,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Start Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Start: ${_formatMonthYear(trip.startDate)}',
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // End Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'End: ${_formatMonthYear(trip.endDate)}',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rating and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trip.rating.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        // Price
                        Text(
                          '\$${trip.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    // Status Badge
                    if (!trip.isBooked)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 8,
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: colors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No trips available',
              style: AppTextStyles.h3(context).copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptyStateMessage(),
              style: TextStyle(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(searchProvider.notifier).resetFilters();
                _searchController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmptyStateMessage() {
    final searchState = ref.read(searchProvider);

    if (widget.initialMonth != null && widget.initialYear != null) {
      return 'No ${widget.initialCategory ?? ''} trips available in ${widget.initialMonth} ${widget.initialYear}';
    }

    if (searchState.filterStatus != 'all') {
      return 'No ${searchState.filterStatus} trips found';
    }

    if (searchState.searchQuery.isNotEmpty) {
      return 'No trips matching "${searchState.searchQuery}"';
    }

    return 'Try adjusting your search or filters';
  }
}