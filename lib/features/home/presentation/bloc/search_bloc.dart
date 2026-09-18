import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/search_properties.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchPropertiesUseCase searchProperties;
  final GetSearchSuggestionsUseCase getSuggestions;
  Timer? _suggestionDebounce;

  SearchBloc(this.searchProperties, this.getSuggestions)
    : super(SearchInitial()) {
    on<SearchProperties>((event, emit) async {
      emit(SearchLoading());
      final result = await searchProperties(event.query);
      result.fold(
        (error) => emit(SearchError(error.message)),
        (results) => emit(SearchLoaded(results)),
      );
    });
    on<SearchSuggestionsChanged>((event, emit) async {
      _suggestionDebounce?.cancel();
      final query = event.query.trim();
      if (query.isEmpty) {
        emit(SearchSuggestionsLoaded(const []));
        return;
      }
      emit(SearchSuggestionsLoading());
      _suggestionDebounce = Timer(const Duration(milliseconds: 350), () async {
        final result = await getSuggestions(query);
        result.fold(
          (error) => emit(SearchSuggestionsError(error.message)),
          (suggestions) => emit(SearchSuggestionsLoaded(suggestions)),
        );
      });
    });
  }

  @override
  Future<void> close() {
    _suggestionDebounce?.cancel();
    return super.close();
  }
}
