import 'package:flutter/material.dart';
import 'package:tubes_riil/borrower/account/borrower-account.dart';
import 'package:tubes_riil/borrower/activity/borrower-activity.dart';
import 'package:tubes_riil/borrower/home/borrower-ajukan-pinjaman.dart';
import 'package:tubes_riil/borrower/wallet/borrower-isi-saldo.dart';
import 'package:tubes_riil/borrower/wallet/borrower-pembayaran.dart';
import 'package:tubes_riil/borrower/wallet/borrower-pencairan-dana.dart';
import 'package:tubes_riil/borrower/wallet/borrower-wallet.dart';
import 'package:tubes_riil/lender/account/lender-account.dart';
import 'package:tubes_riil/lender/activity/lender-activity.dart';
import 'package:tubes_riil/lender/home/lender-home-before.dart';
import 'package:tubes_riil/lender/home/lender-home.dart';
import 'package:tubes_riil/lender/marketplace/lender-marketplace.dart';
import 'package:tubes_riil/lender/marketplace/lender-pendanaan-umkm.dart';
import 'package:tubes_riil/lender/wallet/lender-isi-saldo.dart';
import 'package:tubes_riil/lender/wallet/lender-pencairan-dana.dart';
import 'package:tubes_riil/lender/wallet/lender-wallet.dart';
import 'login-page.dart';
import './lender/register/lender-register.dart';
import './lender/register/lender-email-verification.dart';
import './lender/success-notice/lender-success-account.dart';
import './lender/home/lender-navigation.dart';
import './borrower/register/borrower-register.dart';
import './borrower/register/borrower-email-verification.dart';
import './borrower/register/borrower-form-umkm.dart';
import './borrower/success-notice/borrower-success-account.dart';
import './borrower/home/borrower-home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/*
// LIST STATUS
BORROWER = [selesai, diterima]
LENDER = [belum, sudah]
AJUAN = [mengajukan, selesai]
MARKET = [penggalangan, donpenggalangan, selesai]
PENDANAAN = [belum, sudah]
NOTIFIKASI = [belum, sudah]

*/

class MainProvider extends ChangeNotifier {
  String _token = "";

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('status');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var mainProvider = MainProvider();
  String? token = await mainProvider.getToken();
  String? status = await mainProvider.getStatus();

  runApp(MyApp(token: token, status: status));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.token, required this.status})
      : super(key: key);
  final String? token;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FormBorrower()),
        ChangeNotifierProvider(create: (context) => FormUmkm()),
        ChangeNotifierProvider(create: (context) => FormBorrowerLogin()),
        ChangeNotifierProvider(create: (context) => SakuProvider()),
        ChangeNotifierProvider(create: (context) => IsiProvider()),
        ChangeNotifierProvider(create: (context) => CairProvider()),
        ChangeNotifierProvider(create: (context) => RoleProvider()),
        ChangeNotifierProvider(create: (context) => BorrowerPageProvider()),
        ChangeNotifierProvider(create: (context) => FormAjukan()),
        ChangeNotifierProvider(create: (context) => LenderPageProvider()),
        ChangeNotifierProvider(create: (context) => FormLender()),
        ChangeNotifierProvider(create: (context) => SakuLenderProvider()),
        ChangeNotifierProvider(create: (context) => BorrowerAccountProvider()),
        ChangeNotifierProvider(create: (context) => IsiLenderProvider()),
        ChangeNotifierProvider(create: (context) => CairLenderProvider()),
        ChangeNotifierProvider(create: (context) => LenderAccountProvider()),
        ChangeNotifierProvider(create: (context) => MarketPlaceProvider()),
        ChangeNotifierProvider(create: (context) => PendanaanProvider()),
        ChangeNotifierProvider(create: (context) => BayarProvider()),
        ChangeNotifierProvider(create: (context) => BorrowerActivityProvider()),
        ChangeNotifierProvider(create: (context) => LenderActivityProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: Consumer<FormBorrowerLogin>(
        builder: (context, formBorrowerLogin, _) {
          if (token != null) {
            if (JwtDecoder.isExpired(token!)) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: const LoginPage(),
              );
            } else {
              if (status == "borrower") {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: const BorrowerPage(),
                );
              } else {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: const LenderPage(),
                );
              }
            }
          } else {
            // Token is not available, navigate to login/register screen
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const LoginPage(),
            );
          }
        },
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: const LoginPage(),
    //   initialRoute: '/loginPage',
    //   routes: {
    //     '/loginPage': (context) => LoginPage(),
    //     /* REGISTER LENDER */
    //     '/registerLender': (context) => RegisterLender(),
    //     '/emailVerifLender': (context) => EmailVerificationLender(),
    //     '/successAccLender': (context) => LenderSuccessAccount(),
    //     /* LENDER HOME */
    //     '/lenderPage': (context) => LenderPage(),
    //     /* REGISTER BORROWER */
    //     '/registerBorrower': (context) => RegisterBorrower(),
    //     // '/emailVerifBorrower': (context) =>
    //     //     EmailVerificationBorrower(email: '', token: token!),
    //     // '/formUMKM': (context) => FormulirUMKM(),
    //     '/successAccBorrower': (context) => BorrowerSuccessAccount(),
    //     /* BORROWER HOME */
    //     '/borrowerPage': (context) => BorrowerPage(),
    //   },
    // );
  }
}
