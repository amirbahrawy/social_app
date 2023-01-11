import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_app/layouts/home_layout.dart';
import 'package:social_app/services/local_notifications_service.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'modules/login/login_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  LocalNotificationsService.display(message);
  print(message.data.toString());
  showToast('On Background Message ', Colors.green);

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize local channel
  LocalNotificationsService.initialize();

  //initialize firebase
  await Firebase.initializeApp();

  // token of the user
  token = await FirebaseMessaging.instance.getToken();
  print(token);

  // on foreground
  FirebaseMessaging.onMessage.listen((event) {
    LocalNotificationsService.display(event);
    print(event.data.toString());
    showToast('On Message', Colors.green);
  });
  // when i clicked on the notification
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast('On Message Opened', Colors.green);
  });
  // on background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  late Widget widget;
  if (uId == null) {
    widget = LoginScreen();
  } else {
    widget = const HomeLayout();
  }
  Bloc.observer = MyBlocObserver();
  BlocOverrides.runZoned(
    () => runApp(MyApp(startWidget: widget)),
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getUserData()
        ..getPosts(),
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            home: startWidget,
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
