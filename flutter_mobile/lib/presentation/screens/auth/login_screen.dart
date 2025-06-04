import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 100.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(

                  alignment: const Alignment(0, 0),
                  child: Text(
                    'Se Connecter',
                    style: TextStyle(
                      fontSize: 60.sp,
                      fontWeight: FontWeight.bold,
                      color: theme().colorScheme.secondary,
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 80.h),
                  width: 850.w,
                  child: Column(
                    children: [
                      const TextField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                          labelText: 'Entrez votre E-mail',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 50.h),
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.black,
                          ),

                          labelText: 'Mot de passe',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: const Icon(
                              /*_obscurePassword
                                    ? Icons.visibility_off
                                    :*/
                              Icons.visibility,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Container(alignment:const Alignment(1, 0),child: Text('Mot de passe oublié ?',style: TextStyle(color:theme().colorScheme.primary,fontSize: 40.sp),),),
                    ],
                  ),
                ),

                Container(color: Colors.yellow.shade200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
