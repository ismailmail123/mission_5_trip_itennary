import 'package:trips/data/models/trip_model.dart';

class SearchState {
  final String searchQuery;
  final String sortBy;
  final bool sortAscending;
  final String filterStatus;
  final String? filterMonth;
  final String? filterYear;
  final String? filterCategory;
  final List<TripModel> searchResults;
  final bool isLoading;
  final String? error;

  const SearchState({
    required this.searchQuery,
    required this.sortBy,
    required this.sortAscending,
    required this.filterStatus,
    this.filterMonth,
    this.filterYear,
    this.filterCategory,
    required this.searchResults,
    required this.isLoading,
    this.error,
  });

  SearchState copyWith({
    String? searchQuery,
    String? sortBy,
    bool? sortAscending,
    String? filterStatus,
    String? filterMonth,
    String? filterYear,
    String? filterCategory,
    List<TripModel>? searchResults,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      filterStatus: filterStatus ?? this.filterStatus,
      filterMonth: filterMonth ?? this.filterMonth,
      filterYear: filterYear ?? this.filterYear,
      filterCategory: filterCategory ?? this.filterCategory,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  static SearchState initial() => const SearchState(
    searchQuery: '',
    sortBy: 'rating',
    sortAscending: false,
    filterStatus: 'all',
    filterMonth: null,
    filterYear: null,
    filterCategory: null,
    searchResults: [],
    isLoading: false,
    error: null,
  );
}