import 'package:blocform/src/bloc/provider.dart';
import 'package:blocform/src/providers/user_provider.dart';
import 'package:blocform/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final _prefs = Preferences();

  final userProvider = new UserProvider();

  @override
  Widget build(BuildContext context) {
    print(_prefs.token);
    return Scaffold(
      body: Stack(
        children: <Widget> [
          _createBackground(context),
          _loginForm(context),
        ]
      )
    );
  }

  Widget _createBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final background = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ])
      ),
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.10),
      ),
    );

    return Stack(
      children: <Widget>[
        background,
        Positioned(child: circle, top: 90.0, left: 30.0),
        Positioned(child: circle, top: -40.0, right: -30),
        Positioned(child: circle, bottom: -50.0, right: -10.0),
        Positioned(child: circle, top: 90.0, left: 30.0),
        Positioned(child: circle, bottom: 120.0, right: 20.0),
        Positioned(child: circle, bottom: -50.0, left: -20.0),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 90.0),
              SizedBox(height: 10.0, width: double.infinity),
              Text('Erick Fariñas', style: TextStyle(color: Colors.white, fontSize: 20.0))
            ],
          )
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(child: Container(height: 190.0)),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            
            child: Column(
              children: <Widget>[
                Text('Iniciar Sesión', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 40.0,),
                _createEmail(bloc),
                SizedBox(height: 30.0,),
                _createPassword(bloc),
                SizedBox(height: 30.0,),
                _createButton(bloc)
              ],
            ),
          ),
          FlatButton(
            child: Text('Registrarse'),
            onPressed: () => Navigator.pushReplacementNamed(context, 'signup'),
          ),
          SizedBox(height: 100.0)
        ]
      )
    );
  }

  _createEmail(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );

  }

  _createPassword(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  _createButton(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.formStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Iniciar Sesión')
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0)
      ),
      elevation: 0.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: snapshot.hasData ? ()=> _login(bloc, context) : null);
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    
    Map info = await userProvider.login(bloc.email, bloc.password);

    if(info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      _showAlert(context, info['message']);
    }
    

  }

  void _showAlert(context, message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error al iniciar sesión'),
          actions: <Widget>[
            FlatButton(child: Text('Aceptar'), onPressed: ()=> Navigator.of(context).pop())
          ],
          content: Text(message),
        );
      });
  }
}