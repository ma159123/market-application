import 'package:first_app/modules/shop_modules/cubit/login/cubit/screens/shop_login_model.dart';

abstract class ShopStates {}
class ShopInitialState extends ShopStates{}
class ChangeBottomNavBarState extends ShopStates{}
class ChangeAppBarTitleState extends ShopStates{}
class ShopGetHomeDataLoadingState extends ShopStates{}
class ShopGetHomeDataSuccessState extends ShopStates{}
class ShopGetHomeDataErrorState extends ShopStates{}
class ShopGetCategorySuccessState extends ShopStates{}
class ShopGetCategoryErrorState extends ShopStates{}
class ShopChangeFavSuccessState extends ShopStates{}
class ShopChangeFavState extends ShopStates{}
class ShopChangeFavErrorState extends ShopStates{}
class ShopGetFavLoadingState extends ShopStates{}
class ShopGetFavSuccessState extends ShopStates{}
class ShopGetFavErrorState extends ShopStates{}

class ShopUpdateUserDataLoadingState extends ShopStates{}
class ShopUpdateUserDataSuccessState extends ShopStates{
  ShopLoginModel model;
  ShopUpdateUserDataSuccessState(this.model);
}
class ShopUpdateUserDataErrorState extends ShopStates{}

class ShopGetProfileLoadingState extends ShopStates{}
class ShopGetProfileSuccessState extends ShopStates{
  ShopLoginModel model;
  ShopGetProfileSuccessState(this.model);
}
class ShopGetProfileErrorState extends ShopStates{}
class ShopSearchLoadingState extends ShopStates{}
class ShopSearchSuccessState extends ShopStates{}
class ShopSearchErrorState extends ShopStates{}

class ShopGetCartDataLoadingState extends ShopStates{}
class ShopGetCartDataSuccessState extends ShopStates{}
class ShopGetCartDataErrorState extends ShopStates{}

class ShopChangeCartLoadingState extends ShopStates{}
class ShopChangeCartSuccessState extends ShopStates{}
class ShopChangeCartErrorState extends ShopStates{}

class ShopUpdateCartDataLoadingState extends ShopStates{}
class ShopUpdateCartDataSuccessState extends ShopStates{}
class ShopUpdateCartDataErrorState extends ShopStates{}

class ShopGetProductDetailsLoadingState extends ShopStates{}
class ShopGetProductDetailsSuccessState extends ShopStates{}
class ShopGetProductDetailsErrorState extends ShopStates{}

class ShopGetCategoriesDetailsLoadingState extends ShopStates{}
class ShopGetCategoriesDetailsSuccessState extends ShopStates{}
class ShopGetCategoriesDetailsErrorState extends ShopStates{}

class ShopChangeInkWellSuccessState extends ShopStates{}
class ShopChangeInkWellErrorState extends ShopStates{}