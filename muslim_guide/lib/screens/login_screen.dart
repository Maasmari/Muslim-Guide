import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muslim_guide/database/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? errorMessage = '';
  bool isLogin = true;
  String appbarText = 'Login';
  bool _isPasswordHidden = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();

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
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text.trim(),
        );
        await userCredential.user!
            .updateDisplayName(_controllerUsername.text.trim());
        await userCredential.user!.reload();
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false, bool isUsername = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _isPasswordHidden : false,
      validator: (value) {
        if (value!.isEmpty) return 'Please enter your $title';
        if (isUsername && value.length < 4)
          return 'Username must be at least 4 characters long';
        return null;
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(color: const Color.fromARGB(255, 33, 133, 37)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 33, 133, 37)),
        ),
        labelText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_isPasswordHidden
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage ?? '', style: TextStyle(color: Colors.redAccent));
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        isLogin
            ? signInWithEmailAndPassword()
            : createUserWithEmailAndPassword();
      },
      child: Text(
        isLogin ? 'Login' : 'Register',
      ),
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 33, 133, 37),
        onPrimary: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
          errorMessage = '';
          appbarText = isLogin ? 'Login' : 'Register';
        });
      },
      child: Text(
        isLogin ? 'Need an account? Register' : 'Have an account? Login',
        style: TextStyle(color: const Color.fromARGB(255, 33, 133, 37)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(appbarText,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 40),
              if (!isLogin) ...[
                _entryField('Username', _controllerUsername, isUsername: true),
                SizedBox(height: 20),
              ],
              _entryField('Email', _controllerEmail),
              SizedBox(height: 20),
              _entryField('Password', _controllerPassword, isPassword: true),
              SizedBox(height: 20),
              _errorMessage(),
              SizedBox(height: 20),
              _submitButton(),
              _loginOrRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}
