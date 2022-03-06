import 'package:first_app/layout/shopCubitt/states.dart';
import 'package:first_app/models/categories_details_model.dart';
import 'package:first_app/models/produt_details_model.dart';
import 'package:first_app/models/update_cart_data.dart';
import 'package:first_app/models/favorite_model.dart';
import 'package:first_app/models/get_cart_model.dart';
import 'package:first_app/models/get_favorites_model.dart';
import 'package:first_app/models/search_model.dart';
import 'package:first_app/models/shop_category_model.dart';
import 'package:first_app/models/shop_home_model.dart';
import 'package:first_app/modules/shop_modules/cubit/cart_screen.dart';
import 'package:first_app/modules/shop_modules/cubit/category/category_screen.dart';
import 'package:first_app/modules/shop_modules/cubit/favorite_screen.dart';
import 'package:first_app/modules/shop_modules/cubit/setting_screen.dart';
import 'package:first_app/modules/shop_modules/cubit/login/cubit/screens/shop_login_model.dart';
import 'package:first_app/modules/shop_modules/cubit/products/shop_products.dart';
import 'package:first_app/shared/constants/constants.dart';
import 'package:first_app/shared/network/remote/shop_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int index = 0;
  List<Widget> screens = [
    const ShopProducts(),
    const ShopCategory(),
    const ShopCart(),
    const ShopFavorite(),
    AccountScreen(),
  ];
  List<String> titles = [
    'Products',
    'Category',
    'Cart',
    'Favorite',
    'Account',
  ];
  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.category_outlined), label: 'Category'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.favorite_border), label: 'Favorite'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.settings), label: 'Account'),
  ];

  void changeBottomNavBar(index) {
    this.index = index;
    emit(ChangeBottomNavBarState());
  }

  void changeAppBarTitle(index) {
    this.index = index;
    emit(ChangeAppBarTitleState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorite = {};
  Map<int, bool> cart = {};

  void getHomeData() {

      emit(ShopGetHomeDataLoadingState());
      DioHelper.getData(url: HOME, token: token).then((value) {
        homeModel = HomeModel.fromJson(value.data);
        for (var element in homeModel!.data.products) {
          favorite.addAll({element.id: element.inFavorites});
          cart.addAll({element.id: element.inCart});
        }
        print(favorite);
        print(cart);
        print(homeModel?.data.banners[0].id);
        emit(ShopGetHomeDataSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(ShopGetHomeDataErrorState());
      });


  }

  CategoryModel? categoryModel;

  void getCategoryData() {

      DioHelper.getData(url: CATEGORY, token: token).then((value) {
        categoryModel = CategoryModel.fromJson(value.data);
        print(categoryModel?.data.data[0].name);
        emit(ShopGetCategorySuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(ShopGetCategoryErrorState());
      });

  }

  ChangeFavoriteModel? changeFavoriteModel;

  void changeFavorite(int productId) {
    favorite[productId] = !favorite[productId]!;
    emit(ShopChangeFavState());
    DioHelper.postData(
        url: FAVORITE,
        token: token,
        data: {'product_id': productId}).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data);
      if (!changeFavoriteModel!.status) {
        favorite[productId] != favorite[productId];
      } else {
        getFavoriteData();
      }
      print(changeFavoriteModel!.message);
      emit(ShopChangeFavSuccessState());
    }).catchError((error) {
      favorite[productId] != favorite[productId];
      print(error.toString());
      emit(ShopChangeFavErrorState());
    });
  }

  GetFavoritesModel? getFavoritesModel;

  void getFavoriteData() {
      emit(ShopGetFavLoadingState());

      DioHelper.getData(url: FAVORITE, token: token).then((value) {
        getFavoritesModel = GetFavoritesModel.fromJson(value.data);
        emit(ShopGetCategorySuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(ShopGetCategoryErrorState());
      });


  }

  ShopLoginModel? shopLoginModel;

  void getProfileData() {
    emit(ShopGetProfileLoadingState());
    DioHelper.getData(url: PROFILE, token: token).then((value) {
      shopLoginModel = ShopLoginModel.fromJson(value.data);
      print(shopLoginModel!.data.name);
      emit(ShopGetProfileSuccessState(shopLoginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopGetProfileErrorState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopUpdateUserDataLoadingState());
    DioHelper.putData(url: UPDATE_PROFILE, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
    }).then((value) {
      shopLoginModel = ShopLoginModel.fromJson(value.data);
      print(shopLoginModel!.data.name);
      emit(ShopUpdateUserDataSuccessState(shopLoginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopUpdateUserDataErrorState());
    });
  }

  SearchModel? searchModel;

  void getSearchData({required String text}) {
    emit(ShopSearchLoadingState());

    DioHelper.postData(url: SEARCH, token: token, data: {'text': text})
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(ShopSearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopSearchErrorState());
    });
  }

  UpdateCartData? updateCartData;
  bool inCart=false;
  void changeCart(int productId) async{
    cart[productId] != cart[productId];
    emit(ShopChangeCartLoadingState());
   await DioHelper.postData(
        url: GET_CART,
        token: token,
        data: {'product_id': productId}).then((value) {
      updateCartData = UpdateCartData.fromJson(value.data);
      if (!updateCartData!.status!) {
        cart[productId] != cart[productId];
      } else {
        getCartData();
      }
      print(updateCartData!.message);
     // print('in caaaaaaaaart :$cart');
      emit(ShopChangeCartSuccessState());
    }).catchError((error) {
      cart[productId] != cart[productId]!;
      print(error.toString());
      emit(ShopChangeCartErrorState());
    });
  }

  GetCartModel? getCartModel;

  void getCartData() {

      emit(ShopGetCartDataLoadingState());

      DioHelper.getData(url: GET_CART, token: token).then((value) {
        getCartModel = GetCartModel.fromJson(value.data);
        //print('caart$getCartModel');
        emit(ShopGetCartDataSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(ShopGetCartDataErrorState());
      });


  }

  void updateCart({
    required int quantity,
    required int cartId,
  }) {
    if (quantity > 0) {
      emit(ShopUpdateCartDataLoadingState());
      DioHelper.putData(url: 'carts/$cartId', token: token, data: {
        'quantity': quantity,
      }).then((value) {
        updateCartData = UpdateCartData.fromJson(value.data);
        print(updateCartData!.data!.quantity);
        if (updateCartData!.status!) {
          getCartData();
        }
        emit(ShopUpdateCartDataSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(ShopUpdateCartDataErrorState());
      });
    }
  }

  GetProductDetailsModel? getProductDetails;

  void getProduct(
    int productId,
  ) {

      emit(ShopGetProductDetailsLoadingState());
      DioHelper.getData(
        url: 'products/$productId',
        token: token,
      ).then((value) {
        getProductDetails = GetProductDetailsModel.fromJson(value.data);
        inCart= getProductDetails!.data!.inCart!;
        print(getProductDetails!.data!.name);
        emit(ShopGetProductDetailsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(ShopGetProductDetailsErrorState());
      });


  }

  CategoriesDetailsModel? categoriesDetailsModel;

  void getCategoryDetails(
      int categoryId,
      ) {

      emit(ShopGetCategoriesDetailsLoadingState());
      DioHelper.getData(
        url: 'categories/$categoryId',
        token: token,
      ).then((value) {
        categoriesDetailsModel = CategoriesDetailsModel.fromJson(value.data);
        print(categoriesDetailsModel!.data!.data![0].name);
        emit(ShopGetCategoriesDetailsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(ShopGetCategoriesDetailsErrorState());
      });


  }

}
