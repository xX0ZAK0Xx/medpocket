import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/app_constants.dart';
import 'blocs/bloc.dart';
import 'configs/theme.dart';
import 'firebase_options.dart';
import 'views/views.dart';

Future<void> main() async {
  //!for local db
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ),
  );
  

  // HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>RootBloc()),
        BlocProvider(create: (context)=>AuthBloc()),
        BlocProvider(create: (context)=>ShowBmiBloc()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(392.72, 850.9),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme, // Use the custom theme here,
          home: child
        ),
        // child: const RootScreen(),
        child: const SplashScreen(),
      ),
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
