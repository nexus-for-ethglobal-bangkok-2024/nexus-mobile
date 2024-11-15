// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen(
      {super.key,
      required this.emailController,
      required this.loginFunction,
      required this.loginWithGoogle,
      required this.loginWithGithub,
      required this.loginWithDiscord});

  final TextEditingController emailController;

  final void Function()? loginFunction;
  final void Function()? loginWithGoogle;
  final void Function()? loginWithGithub;
  final void Function()? loginWithDiscord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.purple, Colors.blue, Colors.red])
                .createShader(bounds),
            child: const Text(
              "Nexus",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(colors: [
              Colors.white,
              Colors.grey,
              Color.fromARGB(255, 96, 96, 96),
              Colors.white,
            ]).createShader(bounds),
            child: Text(
              "Sign In With",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          CustomTextField(
              hintText: "Enter Email",
              label: "Email",
              controller: emailController),
          const SizedBox(
            height: 15,
          ),
          CustomButtonWidget(
              function: loginFunction,
              functionName: "Login with Email Passwordless"),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 99,
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                  endIndent: 15,
                  indent: 15,
                  height: 25,
                ),
              ),
              Text(
                "Login with Social Provider",
                style: TextStyle(fontSize: 11),
              ),
              SizedBox(
                width: 99,
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                  endIndent: 15,
                  indent: 15,
                  height: 25,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SocialButtonWidget(
              function: loginWithGoogle,
              functionName: "Continue with Google",
              functionImage: "assets/images/google.png"),
          const SizedBox(
            height: 20,
          ),
          SocialButtonWidget(
              function: loginWithGithub,
              functionName: "Continue with GitHub",
              functionImage: "assets/images/github.png"),
          const SizedBox(
            height: 20,
          ),
          SocialButtonWidget(
              function: loginWithDiscord,
              functionName: "Continue with Discord",
              functionImage: "assets/images/discord.png")
        ],
      ),
    );
  }
}

//Email Text Field

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.label,
      this.isObsecure,
      this.suffixIcon,
      this.minLines,
      this.maxLines,
      this.validator,
      this.keyboardType,
      required this.controller});

  final String hintText;
  final String label;
  final bool? isObsecure;
  final IconButton? suffixIcon;
  final TextEditingController controller;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Validator? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: isObsecure ?? false,
        controller: controller,
        minLines: minLines,
        keyboardType: keyboardType,
        maxLines: maxLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator != null
            ? () {
                switch (validator) {
                  case Validator.email:
                    return (value) => TextFieldValidator.email(value);

                  default:
                    return (value) => TextFieldValidator.defaultEnterV(value);
                }
              }()
            : null,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(25)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(25)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(25)),
        ));
  }
}

//Email Validation

class TextFieldValidator {
  static String? email(String? email) {
    RegExp regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (email!.isEmpty) {
      return null;
    } else if (!regExp.hasMatch(email)) {
      return "Please enter valid email !";
    }
    return null;
  }

  static String? defaultEnterV([dynamic value, String? validateName]) {
    if (value is String && value.isEmpty) {
      return '$validateName';
    }
    return null;
  }
}

enum Validator { email }

//Login Button

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget(
      {super.key, required this.function, required this.functionName});

  final void Function()? function;

  final String functionName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 180, 178, 178),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              spreadRadius: 3, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 3), // Offset of the shadow
            ),
          ], //border corner radius
        ),
        child: Center(
          child: Text(
            functionName,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

// Social Button

class SocialButtonWidget extends StatelessWidget {
  const SocialButtonWidget(
      {super.key,
      required this.function,
      required this.functionName,
      required this.functionImage});

  final void Function()? function;

  final String functionName;

  final String functionImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(
                functionImage,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              functionName,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
