import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? errorMessage = '';
  bool isLogin = true;
  String appbarText = 'Login';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Auth().signInWithEmailAndPassword(
            email: _controllerEmail.text.trim(),
            password: _controllerPassword.text.trim());
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Auth().createUserWithEmailAndPassword(
            email: _controllerEmail.text.trim(),
            password: _controllerPassword.text.trim());
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $title';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _errorMessage() {
    return Visibility(
      visible: errorMessage!.isNotEmpty,
      child: Text(
        errorMessage!,
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        FocusScope.of(context).unfocus(); // Hide keyboard
        if (isLogin) {
          signInWithEmailAndPassword();
        } else {
          createUserWithEmailAndPassword();
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.purple, // Background color
        onPrimary: Colors.white, // Text Color (Foreground color)
      ),
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
          errorMessage = ''; // Reset error message
          appbarText = isLogin ? 'Login' : 'Register';
        });
      },
      child: Text(
          isLogin ? 'Need an account? Register' : 'Have an account? Login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appbarText,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  _entryField('Email', _controllerEmail),
                  SizedBox(height: 20),
                  _entryField('Password', _controllerPassword,
                      isPassword: true),
                  SizedBox(height: 20),
                  _errorMessage(),
                  SizedBox(height: 20),
                  _submitButton(),
                  _loginOrRegisterButton(),
                ],
              ),
            ),
          ),
        ));
  }
}
