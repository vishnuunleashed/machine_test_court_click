import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';

enum BaseStatus {initial,loading, success, failure}

class BaseBlocState<T>{
  final BaseStatus status;
  final T? data;
  final AppException? exception;
  const BaseBlocState({
    this.status = BaseStatus.initial,
    this.data,
    this.exception});

  BaseBlocState<T> copyWith({
    BaseStatus? status,
    T? data,
    AppException? exception}
      ){

   return BaseBlocState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
       exception: exception ?? this.exception
    );
  }
}