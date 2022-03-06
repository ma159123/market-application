import 'package:first_app/modules/shop_modules/cubit/login/cubit/states.dart';
import 'package:first_app/modules/shop_modules/cubit/login/cubit/screens/shop_login_model.dart';
import 'package:first_app/shared/constants/constants.dart';
import 'package:first_app/shared/network/local/cache.dart';
import 'package:first_app/shared/network/remote/shop_dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  int index = 0;

  void changeBoardingIndex() {
    index = index + 1;
    emit(ChangeBoardingIndexState());
  }

  late ShopLoginModel shopLoginModel;

  void userLogin({required String password, required String email}) {
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
      token:token,
    ).then((value)async {
     await CacheHelper.saveData(key: 'token', value: token,);
      shopLoginModel = ShopLoginModel.fromJson(value.data);
      if (shopLoginModel.status!) {
        emit(ShopLoginSuccessState(shopLoginModel));
      } else {
        emit(ShopLoginErrorState(shopLoginModel.message));
      }
      print(shopLoginModel.data.token);
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
      print(error.toString());
    });
  }

  Future<void> userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(ShopRegisterLoadingState());
    await DioHelper.postData(url: Register, data: {
      'email': email,
      'password': password,
      'phone': phone,
      'name': name
    }).then((value) {
      emit(ShopRegisterSuccessState());
      print(value.data);
    }).catchError((error) {
      emit(ShopRegisterErrorState());
      print(error.toString());
    });
  }

  void verifyEmail({required String email}){
    emit(ShopVerifyEmailLoadingState());
    DioHelper.postData(url: VERIFY_EMAIL, data: {
      'email': email,
    }).then((value) {
      shopLoginModel=ShopLoginModel.fromJson(value);
      emit(ShopVerifyEmailSuccessState());
      print(value.data);
    }).catchError((error) {
      emit(ShopVerifyEmailErrorState());
      print(error.toString());
    });
  }

}
