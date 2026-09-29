import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/search_properties.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchPropertiesUseCase searchProperties;
  final GetSearchSuggestionsUseCase getSuggestions;
  int _suggestionGeneration = 0;
  int _searchGeneration = 0;

  SearchBloc(this.searchProperties, this.getSuggestions)
    : super(SearchInitial()) {
    on<SearchProperties>((event, emit) async {
      final generation = ++_searchGeneration;
      _suggestionGeneration++;
      emit(SearchLoading());
      final result = await searchProperties(event.query);
      if (emit.isDone || generation != _searchGeneration) return;
      result.fold(
        (error) => emit(SearchError(error.message)),
        (results) => emit(SearchLoaded(results)),
      );
    });
    on<SearchSuggestionsChanged>((event, emit) async {
      final generation = ++_suggestionGeneration;
      final query = event.query.trim();
      if (query.length < 2) {
        emit(SearchSuggestionsLoaded(const []));
        return;
      }
      emit(SearchSuggestionsLoading());
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (emit.isDone || generation != _suggestionGeneration) return;
      final result = await getSuggestions(query);
      if (emit.isDone || generation != _suggestionGeneration) return;
      result.fold(
        (error) => emit(SearchSuggestionsError(error.message)),
        (suggestions) => emit(SearchSuggestionsLoaded(suggestions)),
      );
    });
  }

  @override
  Future<void> close() {
    _suggestionGeneration++;
    _searchGeneration++;
    return super.close();
  }
}
