// الكلاس دا بنعمله عشان ناخد الداتا من اليوزر وهو بيسجل دا لو كان عمل اكونت ودخله صح
class ShopLoginModel
{
  bool? status;
  String? message;
  late UserData data;
  ShopLoginModel.fromJson(Map<String,dynamic>json)
  {
    status=json['status'];
    message=json['message'];
    data=(json['data'] != null ? UserData.fromJason(json['data']): null)!;  //دي لان الداتا اللي هتجيلي لما اليوزر يسجل ممكن تكون فاضية لو دخل الباس او الايميل غلط
  }

}

class UserData {
  int? id;
  String ?name;
  String ?email;
  String ?phone;
  String ?image;
  int ?points;
  int ?credit;
  String ?token;

//named constructor    >>دا اللي هنستخدمه هناخد منه الداتا ونستخدمها
  UserData.fromJason(Map<String, dynamic>json)
  {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    points = json['points'];
    credit = json['credit'];
    token = json['token'];
  }
}