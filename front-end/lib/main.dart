import 'package:flutter/material.dart';
import 'login-page.dart';
import './lender/register/lender-register.dart';
import './lender/register/lender-email-verification.dart';
import './lender/success-notice/lender-success-account.dart';
import './lender/home/lender-navigation.dart';
import './borrower/register/borrower-register.dart';
import './borrower/register/borrower-email-verification.dart';
import './borrower/register/borrower-form-umkm.dart';
import './borrower/success-notice/borrower-success-account.dart';
import './borrower/home/borrower-navigation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      initialRoute: '/loginPage',
      routes: {
        '/loginPage': (context) => LoginPage(),
        /* REGISTER LENDER */
        '/registerLender': (context) => RegisterLender(),
        '/emailVerifLender': (context) => EmailVerificationLender(),
        '/successAccLender': (context) => LenderSuccessAccount(),
        /* LENDER HOME */
        '/lenderPage': (context) => LenderPage(),
        /* REGISTER BORROWER */
        '/registerBorrower': (context) => RegisterBorrower(),
        '/emailVerifBorrower': (context) => EmailVerificationBorrower(),
        '/formUMKM': (context) => FormulirUMKM(),
        '/successAccBorrower': (context) => BorrowerSuccessAccount(),
        /* BORROWER HOME */
        '/borrowerPage': (context) => BorrowerPage(),
      },
    );
  }
}
