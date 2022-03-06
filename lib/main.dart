import 'package:first_app/layout/shop_layout.dart';
import 'package:first_app/modules/shop_modules/cubit/login/cubit/screens/login.dart';
import 'package:first_app/modules/shop_modules/cubit/on_boarding.dart';
import 'package:first_app/shared/bloc_observer.dart';
import 'package:first_app/shared/constants/constants.dart';
import 'package:first_app/shared/network/local/cache.dart';
import 'package:first_app/shared/network/remote/shop_dio.dart';
import 'package:first_app/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/shopCubitt/cubit.dart';
import 'modules/shop_modules/cubit/login/cubit/cubit.dart';
import 'modules/shop_modules/cubit/login/cubit/states.dart';
import 'modules/shop_modules/cubit/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  await CacheHelper.init();

  Widget widget;
  bool? isDark = CacheHelper.getData(key: 'isDark');
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token')??'';
   print(token);

  if(onBoarding!=null){
    if(token!=''){
      widget=const ShopLayout();
    }else {
      widget=ShopLogin();
    }
  }else{
    widget=const ShopOnBoarding();
  }
  widgett=widget;
  //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(isDark: isDark ?? false,widget: widget,));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget widget;

   MyApp({required this.isDark, required this.widget});

  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);*/
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>ShopLoginCubit()),
        BlocProvider(create: (context)=>ShopCubit()..getHomeData()..getCategoryData()..getCartData()..getFavoriteData()..getProfileData()),
        //BlocProvider(create: (context)=>NewsCubit()..getSports()..getScience()..getBusiness()),
      ],
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          theme: light,
          //darkTheme: dark,
         // themeMode: NewsCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
          home:   SplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}



