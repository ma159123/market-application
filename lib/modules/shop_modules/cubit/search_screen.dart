import 'package:first_app/layout/shopCubitt/cubit.dart';
import 'package:first_app/layout/shopCubitt/states.dart';
import 'package:first_app/models/search_model.dart';
import 'package:first_app/modules/shop_modules/cubit/products/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ShopSearch extends StatelessWidget {
  const ShopSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey=GlobalKey<FormState>();
    var searchController=TextEditingController();
    return  BlocConsumer<ShopCubit,ShopStates>(
        builder: (context,state)=>Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {
              Navigator.pop(context);
            },),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: searchController,
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return 'search must not be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (text){
                      ShopCubit.get(context).getSearchData(text: searchController.text);
                    },
                    decoration:  InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Search',
                        prefixIcon: IconButton(icon:  const Icon(Icons.search),
                        onPressed: () {
                          ShopCubit.get(context).getSearchData(text: searchController.text);
                        },
                        ),),
                    keyboardType: TextInputType.text,
                  ),
                  if(state is ShopSearchLoadingState)
                  const LinearProgressIndicator(),
                  const SizedBox(height: 10.0,),
                  if(state is ShopSearchSuccessState)
                  Expanded(
                    child: ListView.separated(
                      itemCount: ShopCubit.get(context).searchModel!.data!.data!.length,
                      itemBuilder: (BuildContext context, int index) =>buildSearchItem(ShopCubit.get(context).searchModel!.data!.data![index], context,isOldPrice: false),
                      separatorBuilder: (BuildContext context, int index) =>const SizedBox(height: 5.0,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        listener: (context,state){},
    );
  }

  Widget buildSearchItem(Product model,context, {isOldPrice = true})=>Padding(
    padding: const EdgeInsets.all(10.0),
    child: InkWell(
      onTap: (){
        //print(model.id);
        ShopCubit.get(context).getProduct(model.id!);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProductDetails()));
      },
      child: Container(
        height: 120,
        color: Colors.white,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage('${model.image}'),
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                if (model.discount != 0&&isOldPrice)
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      color: Colors.orangeAccent[200],
                      child: Text(
                        '-${model.discount}%',
                        style: const TextStyle(fontSize: 18),
                      ))
              ],
            ),
            const SizedBox(
              width: 5.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    style: const TextStyle(
                      fontSize: 20.0,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
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
                      if (model.discount != 0&&isOldPrice)
                        Text(
                          '${model.oldPrice}',
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      // IconButton(
                      //   color:ShopCubit.get(context)
                      //       .favorite[model.id!]!
                      //       ? Colors.orangeAccent
                      //       : Colors.grey,
                      //   onPressed: () {
                      //     ShopCubit.get(context).changeFavorite(model.id!);
                      //   },
                      //   icon: ShopCubit.get(context).favorite[model.id!]! ?const Icon(Icons.favorite):const Icon(Icons.favorite_border_outlined),
                      //   padding: EdgeInsets.zero,
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
