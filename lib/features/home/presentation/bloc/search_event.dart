import '../../data/model/search_model.dart';

abstract class SearchEvent {}

class SearchProperties extends SearchEvent {
  final SearchQuery query;
  SearchProperties(this.query);
}

class SearchSuggestionsChanged extends SearchEvent {
  final String query;
  SearchSuggestionsChanged(this.query);
}
