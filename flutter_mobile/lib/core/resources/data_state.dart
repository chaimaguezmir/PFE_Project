abstract class DataState<T> {
  DataState({this.data, this.error});
  final T? data;
  final String? error;
}

class DataSuccess<T> extends DataState<T> {
  DataSuccess(T data) : super(data: data);
}

class DataError<T> extends DataState<T> {
  DataError(String error) : super(error: error);
}
