import 'package:dartz/dartz.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import '../../data/model/search_model.dart';
import '../repository/home_repository.dart';

class SearchPropertiesUseCase {
  final HomeRepository repository;
  const SearchPropertiesUseCase(this.repository);

  Future<Either<AppException, SearchResultsModel>> call(SearchQuery query) =>
      repository.search(query);
}

class GetSearchSuggestionsUseCase {
  final HomeRepository repository;
  const GetSearchSuggestionsUseCase(this.repository);

  Future<Either<AppException, List<SearchSuggestionModel>>> call(
    String query,
  ) => repository.getSearchSuggestions(query);
}
