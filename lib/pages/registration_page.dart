import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import 'home_page.dart';
import 'package:firebase_core/firebase_core.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final _auth = FirebaseAuth.instance;

  /// form key
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController ageCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final nameFieldCont = TextFormField(
      controller: nameCont,
      validator: (value){
      RegExp regex = RegExp(r'^.{3,}$');
      if (value!.isEmpty) {
        return ("Name cannot be Empty");
      }
      if (!regex.hasMatch(value)) {
        return ("Enter Valid name(Min. 3 Character)");
      }
      return null;
    },
    onSaved: (value) {
    nameCont.text = value!;
      },
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.account_box),
          labelText: "Name"
      ),
    );

    final ageFieldCont = TextFormField(
      controller: ageCont,
      validator: (value){
        if (value!.isEmpty) {
          return ("This Field cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        nameCont.text = value!;
      },
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.numbers),
          labelText: "Age"
      ),
    );


    final emailFieldCont = TextFormField(
      controller: emailCont,
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
        emailCont.text = value!;
      },
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.mail),
          labelText: "Email"
      ),
    );

    final passwordFieldCont = TextFormField(
      controller: passwordCont,
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
        passwordCont.text = value!;
      },
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.mail),
          labelText: "Password"
      ),
    );

    final confirmPasswordFieldCont = TextFormField(
      controller: confirmPasswordCont,
      obscureText: true,
      validator: (value){
        if(confirmPasswordCont.text != passwordCont.text){
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordCont.text = value!;
      },

    );

    final registerButton = ElevatedButton(
      onPressed: (){
        signUp(emailCont.text, passwordCont.text);
      },
      child: const Text("Login"),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
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
                nameFieldCont,
                const SizedBox(height: 25),
                ageFieldCont,
                const SizedBox(height: 25),
                emailFieldCont,
                const SizedBox(height: 25),
                passwordFieldCont,
                const SizedBox(height: 25),
                confirmPasswordFieldCont,
                const SizedBox(height: 35),
                registerButton,
              ],
            ),
          ),
        ),
      ),
    );

  }
  void signUp(String email, String password) async{
    if(_formKey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) => {
        postDetailsToFirestore(),


        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Login Successfully'))), Navigator.of(context).
        pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()))

      }
      ).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Error')));
      });
    }
  }
  postDetailsToFirestore() async{
    FirebaseFirestore data = FirebaseFirestore.instance;

    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameCont.text;
    userModel.age = ageCont.text.toString() as int?;

    await data
    .collection("users")
    .doc(user.uid)
    .set(userModel.toMap());

  }
}

