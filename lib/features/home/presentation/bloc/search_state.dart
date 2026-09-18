import '../../data/model/explore_model.dart';
import '../../data/model/search_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchSuggestionsLoading extends SearchState {}

class SearchSuggestionsLoaded extends SearchState {
  final List<SearchSuggestionModel> suggestions;
  SearchSuggestionsLoaded(this.suggestions);
}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final SearchResultsModel results;
  SearchLoaded(this.results);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

class SearchSuggestionsError extends SearchState {
  final String message;
  SearchSuggestionsError(this.message);
}

class SearchResultsViewModel {
  final List<ExploreProperty> items;
  final int total;
  const SearchResultsViewModel(this.items, this.total);
}
