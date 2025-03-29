import 'package:bneedsbillappnew/Controller/UserDetail_Controller.dart';
import 'package:bneedsbillappnew/Screens/User_Login_Screens.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:bneedsbillappnew/Utility/Validator.dart';
import 'package:bneedsbillappnew/Widgets/Common_Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailScreens extends StatefulWidget {
  const UserDetailScreens({super.key});

  @override
  State<UserDetailScreens> createState() => _UserDetailScreensState();
}

class _UserDetailScreensState extends State<UserDetailScreens> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('PREFSUSERNAME');

    if (storedUsername != null && storedUsername.isNotEmpty) {
      setState(() {
        isLoggedIn = true; // User is already logged in
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserdetailController());
    return Scaffold(
      appBar: AppBar(
        title: Text('USER DETAILS'),
      ),
      body: Form(
        key: controller.Userformkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) =>
                      C_Validator.validateEmptyText('Enter Username', value),
                  controller: controller.Name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'USERNAME',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) =>
                      C_Validator.validateEmptyText('Enter Password', value),
                  controller: controller.Userpassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.lock),
                    labelText: 'USER PASSWORD',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) => C_Validator.validateEmptyText(
                      'Enter Phone Number', value),
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: controller.Userphonenumber,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'USER MOBILE NO',
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final LUsername =
                          controller.Name.text.trim().toUpperCase();
                      // Store the user ID
                      prefs.setString('PREFSUSERNAME', LUsername);
                      commonUtils.log.i('PREFSUSERNAME == $LUsername');
                      controller.addItem();
                    },
                    child: Text('CREATE USER ACCOUNT'),
                  ),
                ),
                SizedBox(height: 10),
                if (!isLoggedIn) // Show the "Already have User Account?" only if the user is not logged in
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
                SizedBox(height: 15),
                if (!isLoggedIn) // Only show this if the user is not logged in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have User Account? ',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      GestureDetector(
                          onTap: () => Get.to(UserLoginScreens()),
                          child: Text('User Account')),
                    ],
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
