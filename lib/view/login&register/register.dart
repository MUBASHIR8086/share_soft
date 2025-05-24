
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shersoft/controller/localdb.dart';
import 'package:shersoft/controller/login.dart';
import 'package:shersoft/model/localdb.dart';
import 'package:shersoft/view/home/homepage.dart';
import 'package:shersoft/view/login&register/login.dart';
import 'package:shersoft/view/login&register/widget/widget.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController adreesController = TextEditingController();
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[700]!, Colors.blue[400]!]),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                height: 760,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Consumer<UserController>(
                  builder: (context, provider, child) => Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account"),
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("Login",style: TextStyle(
                            color: Colors.blue,
                          ),)),
                        ],
                      ),
                      loginform(
                          controller: nameController, lable: "Company name"),
                      loginform(controller: emailController, lable: "Email"),
                      loginform(lable: "Address", controller: adreesController),
                      loginform(
                          lable: "phone number", controller: phoneController),
                      loginform(
                          lable: "password", controller: passwordController),
                       Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color(0xFF0A1EBE),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                provider
                                    .registerUser(
                                      address: adreesController.text,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),context: context)
                                    .then((value) {
                                  if (value != null) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Homepage()));
                                                final data = UserAcoountDb(email: emailController.text.trim(), password: passwordController.text.trim());
                                                addData(data);
                                  }
                                });
                              },
                              child: Text("Register")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
