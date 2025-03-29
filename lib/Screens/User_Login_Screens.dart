import 'package:bneedsbillappnew/Controller/UserLogin_Controller.dart';
import 'package:bneedsbillappnew/Screens/User_Detail_Screens.dart';
import 'package:bneedsbillappnew/Utility/Validator.dart';
import 'package:bneedsbillappnew/Widgets/Common_Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utility/Logger.dart';

class UserLoginScreens extends StatefulWidget {
  const UserLoginScreens({super.key});

  @override
  State<UserLoginScreens> createState() => _UserLoginScreensState();
}

class _UserLoginScreensState extends State<UserLoginScreens> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserloginController());
    return Scaffold(
      appBar: AppBar(
        title: Text('USER LOGIN'),
      ),
      body: Form(
        key: controller.userLoginKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) =>
                      C_Validator.validateEmptyText('Enter User Name', value),
                  controller: controller.Usernmaelogin,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'USERNAME',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) =>
                      C_Validator.validateEmptyText('Enter Password', value),
                  controller: controller.Userpasswordlogin,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'PASSWORD',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final LUsername =
                            controller.Usernmaelogin.text.trim().toUpperCase();

                        prefs.setString('PREFSUSERNAME', LUsername);
                        commonUtils.log.i('PREFSUSERNAME == $LUsername');
                        controller.fetchItems(
                          controller.Usernmaelogin.text.trim(),
                          controller.Userpasswordlogin.text.trim(),
                        );
                      },
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Colors.white,
                              ),
                            )
                          : const Text('USER LOGIN -->'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Divider(
                        color: C_ColorsPages.grey,
                        thickness: 0.5,
                        indent: 60,
                        endIndent: 5,
                      ),
                    ),
                    Text(
                      'OR',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Flexible(
                      child: Divider(
                        color: C_ColorsPages.grey,
                        thickness: 0.5,
                        indent: 5,
                        endIndent: 60,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Account? ',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    GestureDetector(
                        onTap: () => Get.offAll(UserDetailScreens()),
                        child: Text('User Register')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
