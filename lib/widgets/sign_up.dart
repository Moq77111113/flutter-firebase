import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/provider/google_auth.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const FlutterLogo(size: 120),
            const Spacer(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Hey there\nWelcome back',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      color: Colors.white)),
            ),
            const SizedBox(
              height: 8,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Log in to continue',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      decoration: TextDecoration.none)),
            ),
            const Spacer(),
            ElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                },
                label: const Text('Sign up with Google')),
            const SizedBox(height: 40),
            RichText(
                text: const TextSpan(
                    text: 'Already have an account ? ',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                    children: [
                  TextSpan(
                    text: 'Log in',
                    style: TextStyle(decoration: TextDecoration.underline),
                  )
                ]))
          ],
        ),
      );
}
