import 'package:first_app/modules/shop_modules/cubit/login/cubit/screens/login.dart';
import 'package:first_app/shared/network/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login/cubit/cubit.dart';
import 'login/cubit/states.dart';

class ShopOnBoarding extends StatelessWidget {
  const ShopOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onSubmit(){
      CacheHelper.saveData(key: 'onBoarding', value: true)! .then((value) {
        if(value){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ShopLogin()),
                  (route) => false);
        }
      });

    }
    var cubit = ShopLoginCubit.get(context);
    var boardController = PageController();
    List<DataBoardingModel> modeList = [
      DataBoardingModel(
          title: 'Choose your product',
          title1: 'There are many of products ',
          image:
              'assets/images/Shopping-online1.png'),
      DataBoardingModel(
          title: 'Add to cart',
          title1: 'Just two click and you can buy the product you want',
          image:
              'assets/images/add_to_cart1.png'),
      DataBoardingModel(
          title: 'Pay by card',
          title1: 'The order can be paid by credit card',
          image:
              'assets/images/payment1.png'),
    ];
    return BlocConsumer<ShopLoginCubit, ShopLoginStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  onSubmit();
      },
                child: Text('Skip'))
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: PageView.builder(
              controller: boardController,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildBoardingItem(modeList, index),
              itemCount: modeList.length,
            )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  SmoothPageIndicator(
                    controller: boardController,
                    count: modeList.length,
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.deepOrange,
                      dotHeight: 10,
                      dotWidth: 10.0,
                      spacing: 5.0,
                      expansionFactor: 4,
                    ),
                  ),
                  const Spacer(),
                  FloatingActionButton(
                    backgroundColor: Colors.deepOrange,
                    onPressed: () {
                      if (cubit.index == modeList.length - 1) {
                        onSubmit();
                      } else {
                        boardController.nextPage(
                            duration: const Duration(
                              milliseconds: 750,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn);
                        cubit.changeBoardingIndex();
                      }
                    },
                    child: const Icon(Icons.arrow_forward),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(List<DataBoardingModel> model, index) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Image(
              image: AssetImage(model[index].image),
            )),
            const SizedBox(
              height: 40.0,
            ),
            Text(
              model[index].title,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              model[index].title1,
              style:
                  const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.grey),
            ),
            const SizedBox(
              height: 60.0,
            ),
          ],
        ),
      );
}

class DataBoardingModel {
  late String title, title1, image;

  DataBoardingModel(
      {required this.title, required this.title1, required this.image});
}
