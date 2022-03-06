import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio = Dio(); // with default Options

// new Dio with a BaseOptions instance.
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
        connectTimeout: 5000,
        receiveTimeout: 3000,
        //يعني لو حصل ايرور والداتا راجعه يجيبها بردو
      ),
    );
  }

  static Future getData(
      {
        required String url,
         Map<String, dynamic>? query,
         String lang='en',
        String?token,
      }) async {
    dio.options.headers={
      'Content-Type': 'application/json',
     'lang':lang,
      'Authorization':token??'',
    };
    return await dio.get(url, queryParameters: query);
  }

  static Future postData({
    required String url,
    required dynamic data,
    String lang='ar',
    String?token,
  }) async {
    dio.options.headers={
      'Content-Type': 'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.post(url, data: data);
  }

  static Future putData({
    required String url,
    required dynamic data,
    String lang='ar',
    String?token,
  }) async {
    dio.options.headers={
      'Content-Type': 'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.put(url, data: data);
  }
}
