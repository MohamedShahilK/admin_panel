import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBlocOld extends Bloc<AuthEvent, AuthState> {
  AuthBlocOld() : super(AuthState.initial()) {
    on<AuthEvent>((event, emit) {
     
    });
  }
}
