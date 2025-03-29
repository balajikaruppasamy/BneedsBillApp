import 'package:bneedsbillappnew/Controller/Login_Controller.dart';
import 'package:bneedsbillappnew/Screens/SIgnup_Screens.dart';
import 'package:bneedsbillappnew/Utility/Validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: controller.loginformkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(55.0),
                  child: Image(
                    height: 300,
                    image: AssetImage('assets/images/Login.png'),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: controller.Emailid,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email), labelText: 'Email-Id'),
                  validator: (value) => C_Validator.validateEmail(value),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(
                  () => TextFormField(
                    controller: controller.Password,
                    validator: (value) =>
                        C_Validator.validateEmptyText('Password', value),
                    obscureText: controller.hidepasssword.value,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidepasssword.value =
                                  !controller.hidepasssword.value;
                            },
                            icon: Icon(controller.hidepasssword.value
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Password'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Login ->'),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {
                          Get.to(SignupScreens());
                        },
                        child: Text('Create Account')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
