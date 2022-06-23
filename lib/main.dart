import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:untitled/bloc.dart';
import 'package:untitled/status.dart';

void main() => runApp(MaterialApp(home: LoginWidget()));

class LoginWidget extends StatelessWidget {

  final loginBloc = LoginBloc.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          StreamBuilder<String>(
              stream: loginBloc.email,
              builder: (context, snapShot) {
                return TextField(
                    decoration: InputDecoration(
                        labelText: 'Email', errorText: snapShot.error),
                    onChanged: loginBloc.onNameChanged);
              }),
          StreamBuilder(
              stream: loginBloc.passoword,
              builder: (context, snapShot) {
                return TextField(
                    decoration: InputDecoration(
                        labelText: 'Password', errorText: snapShot.error),
                    onChanged: loginBloc.onPasswordChanged);
              }),
          Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: loginBloc.submit,
                    child: const Text('Login'),
                  ))),
          StreamBuilder<StatusResponse>(
              stream: loginBloc.result,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content: Row(
                                children: const [
                                  CircularProgressIndicator(),
                                  Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text("Loading"))
                                ],
                              ));
                            });
                      });
                      break;
                    case Status.COMPLETED:
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeRoute()),
                            (route) => false);
                      });
                      break;
                  }
                }
                return Container();
              })
        ],
      )),
    );
  }
}

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.blueGrey,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back'),
        ),
      ),
    );
  }
}
