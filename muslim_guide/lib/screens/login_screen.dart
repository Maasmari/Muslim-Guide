import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muslim_guide/database/register_user.dart';
import '../database/auth.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(255, 0, 134, 0),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 0, 54, 7),
);

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

        // Updating the user's display name
        await userCredential.user!
            .updateDisplayName(_controllerUsername.text.trim());
        await userCredential.user!.reload(); // Make sure the user is updated

        // Fetch the updated user
        User? updatedUser = FirebaseAuth.instance.currentUser;

        // Additional check to ensure displayName is updated
        final int maxRetries = 5;
        int currentTry = 0;
        while (updatedUser!.displayName == null && currentTry < maxRetries) {
          await Future.delayed(Duration(seconds: 1)); // Wait for a second
          await updatedUser.reload();
          updatedUser = FirebaseAuth.instance.currentUser;
          currentTry++;
        }

        if (updatedUser.displayName != null) {
          // Call registerUser with non-null values
          await registerUser(
            updatedUser.uid,
            updatedUser.email!,
            updatedUser.displayName!,
          );
        } else {
          print('Unable to update displayName after retries.');
          // Handle the case where displayName is still not updated
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      } catch (e) {
        print('An unexpected error occurred: $e');
      }
    }
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false, bool isUsername = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _isPasswordHidden : false,
      style: TextStyle(
          color: kDarkColorScheme
              .onSurface), // Ensures text is visible against dark background
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $title';
        }
        if (isUsername && value.length < 4) {
          return 'Username must be at least 4 characters long';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
            color: kDarkColorScheme
                .onBackground), // Label color for better visibility
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: kDarkColorScheme.onBackground,
              width: 1.0), // Visible border in dark mode
        ),
        fillColor:
            kDarkColorScheme.background, // Dark fill color for input field
        filled: true,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: kDarkColorScheme
                      .onSurface, // Icon color in dark mode for visibility
                ),
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
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
            ),
      ),
      home: Scaffold(
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
                    // Conditionally show the username field for registration first
                    if (!isLogin) ...[
                      _entryField('Username', _controllerUsername,
                          isUsername: true),
                      SizedBox(height: 20),
                    ],
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
          )),
    );
  }
}
