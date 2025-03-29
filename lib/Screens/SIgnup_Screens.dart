import 'package:bneedsbillappnew/Controller/Signup_Controller.dart';
import 'package:bneedsbillappnew/Screens/Front_Screens.dart';
import 'package:bneedsbillappnew/Screens/Login_Screens.dart';
import 'package:bneedsbillappnew/Widgets/Common_Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignupScreens extends StatefulWidget {
  const SignupScreens({super.key});

  @override
  State<SignupScreens> createState() => _SignupScreensState();
}

class _SignupScreensState extends State<SignupScreens> {
  bool isLoading = false; // To manage loading state
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: controller.signupFormkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lets create Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Billing made easy for your growing business.',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: controller.companyid,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.add),
                    labelText: 'COMPANY ID',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.Companyname,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.business_sharp),
                    labelText: 'COMPANY NAME',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.Address,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.location5),
                    labelText: 'ADDRESS',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.City,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.location),
                    labelText: 'CITY',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.Emailid,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'EMAIL-ID',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.Phonenumber,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'PHONE NUMBER',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.passwords,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'PASSWORD',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });
                            await controller.Signup();
                            setState(() {
                              isLoading = false;
                            });
                          },
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.blue,
                          )
                        : const Text('Create Account'),
                  ),
                ),
                SizedBox(
                  height: 5,
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
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have Account? ',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    GestureDetector(
                        onTap: () => Get.to(LoginScreens()),
                        child: Text('LOGIN')),
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
