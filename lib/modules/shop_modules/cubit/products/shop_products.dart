import 'package:carousel_slider/carousel_slider.dart';
import 'package:first_app/layout/shopCubitt/cubit.dart';
import 'package:first_app/layout/shopCubitt/states.dart';
import 'package:first_app/models/shop_category_model.dart';
import 'package:first_app/models/shop_home_model.dart';
import 'package:first_app/modules/shop_modules/cubit/products/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../category/categories_details.dart';

class ShopProducts extends StatelessWidget {
  const ShopProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (BuildContext context, Object? state) {},
        builder: (BuildContext context, state) {
          var model = ShopCubit.get(context).homeModel;
          var category = ShopCubit.get(context).categoryModel;
          return Conditional.single(
            context: context,
            conditionBuilder: (BuildContext context) =>
                model != null && category != null,
            widgetBuilder: (BuildContext context) => productBuilder(
                ShopCubit.get(context).homeModel,
                ShopCubit.get(context).categoryModel,
                context),
            fallbackBuilder: (BuildContext context) =>
                const Center(child: CircularProgressIndicator()),
          );
        });
  }

  Widget productBuilder(HomeModel? model, CategoryModel? catModel, context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
              items: model?.data.banners
                  .map((e) => FadeInImage(
                        image: NetworkImage(e.image),
                        fit: BoxFit.cover,
                        width: double.infinity,
                placeholder: AssetImage('assets/images/default.png'),
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 200,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                scrollDirection: Axis.horizontal,
              )),
          const SizedBox(
            height: 15.0,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('CATEGORIES',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.0,),),
          ),
          SizedBox(
            height: 120.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  buildCategoryItem(catModel!.data.data[index],context),
              separatorBuilder: (context, index) => const SizedBox(
                width: 5.0,
              ),
              itemCount: catModel!.data.data.length,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('PRODUCTS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.0),),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 4.6,
              mainAxisSpacing: 5.4,
              childAspectRatio: 1 / 1.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                  model!.data.products.length,
                  (index) =>
                      buildGridProduct(model.data.products[index], context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridProduct(ProductsModel model, context) {
    return InkWell(
      onTap: (){
        print('mmmmmmmmmm${model.id}');
        ShopCubit.get(context).getProduct(model.id);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProductDetails()));
      },
      child: Container(
        color: Colors.white,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                FadeInImage(
                  image: NetworkImage(model.image),
                  width: double.infinity,
                  height: 182, placeholder:  AssetImage('assets/images/default.png',
                ),),
                if (model.discount != 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.5),
                        color: Colors.orangeAccent[200],
                      ),
                        child: Text(
                          '-${model.discount.round()}%',
                          style: const TextStyle(fontSize: 22,color: Colors.white),
                        )),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    model.name,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price}',
                        style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                            color: Colors.blue),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice}',
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        color: ShopCubit.get(context).favorite[model.id]!
                            ? Colors.orangeAccent
                            : Colors.grey,
                        onPressed: () {
                          ShopCubit.get(context).changeFavorite(model.id);
                        },
                        icon: ShopCubit.get(context).favorite[model.id]! ?Icon(Icons.favorite):Icon(Icons.favorite_border_outlined),
                        padding: EdgeInsets.zero,
                      )
                    ],
                  ),
                ],
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     ShopCubit.get(context).changeCart(model.id);
            //   },
            //   child: Container(
            //     height: 30.0,
            //     color: model.inCart?Colors.green:Colors.orange,
            //     child: Row(
            //       children:  [
            //        model.inCart? const Icon(Icons.check_box_outlined,color: Colors.white,):const Icon(Icons.add_shopping_cart,color: Colors.white,),
            //         const SizedBox(
            //           width: 20.0,
            //         ),
            //         Text(
            //           model.inCart?'ADDED':'ADD TO CART',
            //           style: const TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryItem(DataModel model,context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  ShopCubit.get(context).getCategoryDetails(model.id);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopCategoriesDetails()));
                },
                child: CircleAvatar(
                  child:FadeInImage(image:  NetworkImage(model.image), placeholder: AssetImage('assets/images/default.png'),),
                  radius: 40.0,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 3.0,
              ),
              Text(
                model.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
