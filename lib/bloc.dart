import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:untitled/repository.dart';
import 'package:untitled/status.dart';

class _EmailErrorException implements Exception {
  String cause;
  _EmailErrorException(this.cause);
}

class _PassWordErrorException implements Exception {
  String cause;
  _PassWordErrorException(this.cause);
}

class LoginBloc {

  final Repository repository;

  LoginBloc(this.repository);

  static LoginBloc getInstance() {
    LoginBloc(RepositoryImpl());
  }

  final _emailStreamController = BehaviorSubject<String>();
  Stream<String> get email => _emailStreamController.stream;

  final _passwordStreamController = BehaviorSubject<String>();
  Stream<String> get passoword => _passwordStreamController.stream;

  Function(String) get onNameChanged => _emailStreamController.sink.add;
  Function(String) get onPasswordChanged => _passwordStreamController.sink.add;

  final _resultStreamController = BehaviorSubject<StatusResponse>();
  Stream get result => _resultStreamController.stream;

  submit() async {
    try {
      _resultStreamController.add(StatusResponse.loading());
      final email = _emailStreamController.valueOrNull;
      final password = _passwordStreamController.valueOrNull;
      if (email == null || email.isEmpty) {
        throw _EmailErrorException('Enter valid name');
      }
      if (password == null || password.isEmpty) {
        throw _PassWordErrorException('Enter valid password');
      }
      if (await repository.isUserAvailable(email, password)) {
        _resultStreamController.add(StatusResponse.completed(""));
      }
    } on _EmailErrorException catch (e) {
      _emailStreamController.addError(e.cause);
      _resultStreamController.add(StatusResponse.error(""));
    } on _PassWordErrorException catch (e) {
      _passwordStreamController.addError(e.cause);
      _resultStreamController.add(StatusResponse.error(""));
    } on Exception catch (e) {
      _resultStreamController.add(StatusResponse.error(""));
    }
  }
}
