

import 'dart:async';

import 'package:blocform/src/bloc/validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validator {


  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //listen stream

  Stream<String> get emailStream => _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validatePassword);

  Stream <bool> get formStream => 
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);
  //insert to stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //get last value
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}