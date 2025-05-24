import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shersoft/controller/login.dart';
import 'package:shersoft/view/home/homepage.dart';
import 'package:shersoft/view/login&register/register.dart';
import 'package:shersoft/view/login&register/widget/widget.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginPage({super.key});

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
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: double.infinity,
                height: 480,
                child: Consumer<UserController>(
                  builder: (context, controller, child) => Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an company'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterPage()));
                              },
                              child: Text("create")),
                        ],
                      ),
                      loginform(controller: emailController, lable: 'Email'),
                      loginform(
                          controller: passwordController, lable: 'Password'),
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                          ),
                          Text("Remeber me"),
                        ],
                      ),
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
                                controller
                                    .loginUser(
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
                                  }
                                });
                              },
                              child: Text("Login")),
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
