

import 'dart:async';

class Validator {

  static final Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const String emailError = 'Correo no válido';
  static const String passwordLenthError = 'Min. 6 caracteres';
  static const String passwordSpecialError = 'Caracter especial requerido';
  static RegExp specialRegExp = new RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password.length>=6 && password.contains(specialRegExp)) {
        sink.add(password);
      } else if(password.length>=6) {
        sink.addError(passwordSpecialError);
      } else {
        sink.addError(passwordLenthError);
      }
    }
  );

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      RegExp regExp = new RegExp(pattern);

      if(regExp.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError('Correo no válido');
      }
    }
  );

}