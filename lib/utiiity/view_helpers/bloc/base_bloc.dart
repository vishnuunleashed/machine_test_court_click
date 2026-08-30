import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:machine_test_court_click/utiiity/helpers/app_exception.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_event.dart';
import 'package:machine_test_court_click/utiiity/view_helpers/bloc/base_bloc_state.dart';

class BaseBloc<Event extends BaseBlocEvent,T> extends Bloc<Event,BaseBlocState<T>>{
  BaseBloc():super(const BaseBlocState());


  Future<void> baseMethod(
      Emitter<BaseBlocState<T>> emit,
      Future<Either<AppException,T>> Function() initiateCall
      )async{
      emit(state.copyWith(status: BaseStatus.loading));
      final result = await initiateCall();
      
      result.fold((exception){
        log("Exception : ${exception.message.toString()}");
        emit(BaseBlocState(exception: exception,status: BaseStatus.failure));
      } , (data){
        emit(BaseBlocState(status: BaseStatus.success,data: data));
      });
  }

}