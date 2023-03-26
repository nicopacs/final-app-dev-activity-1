import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// form key
  final _formKey = GlobalKey<FormState>();

  /// controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// firebase
  final _auth = FirebaseAuth.instance;

  @override

  Widget build(BuildContext context) {
    final emailField = TextFormField(
      controller: emailController,
      validator: (value){
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
            .hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.mail),
          labelText: "Email"
      ),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.mail),
          labelText: "Password"
      ),
    );

    final loginButton = ElevatedButton(
      onPressed: (){
        signIn(emailController.text, passwordController.text);
      },
      child: const Text("Login"),
    );


    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 45),
                emailField,
                const SizedBox(height: 25),
                passwordField,
                const SizedBox(height: 35),
                loginButton,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: (){


                      },
                      child: const Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );

  }
  void signIn(String email, String password) async{
    if(_formKey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) => {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Login Successfully'))), Navigator.of(context).
        pushReplacement(MaterialPageRoute(builder: (context) => HomePage()))

      }
      ).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Error')));
      }

      );
    }
  }
}
