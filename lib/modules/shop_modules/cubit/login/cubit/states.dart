import 'package:first_app/modules/shop_modules/cubit/login/cubit/screens/shop_login_model.dart';

abstract class ShopLoginStates {}
class ShopLoginInitialState extends ShopLoginStates{}
class ChangeBoardingIndexState extends ShopLoginStates{}
class ShopLoginLoadingState extends ShopLoginStates{}
class ShopLoginSuccessState extends ShopLoginStates{
 ShopLoginModel shopLoginModel;
 ShopLoginSuccessState(this.shopLoginModel);
}
class ShopLoginErrorState extends ShopLoginStates{
String? error;
ShopLoginErrorState(this.error);
}
class ShopRegisterLoadingState extends ShopLoginStates{}
class ShopRegisterSuccessState extends ShopLoginStates{}
class ShopRegisterErrorState extends ShopLoginStates{}

class ShopVerifyEmailLoadingState extends ShopLoginStates{}
class ShopVerifyEmailSuccessState extends ShopLoginStates{}
class ShopVerifyEmailErrorState extends ShopLoginStates{}

class ShopChangeSecureIconSuccessState extends ShopLoginStates{}


