import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_ecommerce/layout/cubit/cubit.dart';
import 'package:shop_ecommerce/layout/cubit/states.dart';
import 'package:shop_ecommerce/shared/adaptive/adaptivw_indicator.dart';
import 'package:shop_ecommerce/shared/components/componets.dart';
import 'package:shop_ecommerce/shared/components/constants.dart';
import 'package:shop_ecommerce/shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if(ShopCubit.get(context).favoritesModel == null){
           return Center(child: Text('Empty'),);
        } else{
          return Conditional.single(
            context: context,
            conditionBuilder: (context) => state is! ShopLoadingGetFavoritesState,
            widgetBuilder: (context) =>ShopCubit.get(context).favoritesModel!.data!.data!.length == 0
                ? Center(child:Text('You don\'t have item',),)
                : ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder:(context, index){ return Container();},
              // itemBuilder: (context, index) =>
              // buildListProduct(ShopCubit.get(context).favoritesModel!.data!.data![index].product, context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount:
              ShopCubit.get(context).favoritesModel!.data!.data!.length,
            ),
            fallbackBuilder: (context) => Center(
                child: AdaptiveIndicator(
                  os: getOS(),
                )),
          );
        }

      },
    );
  }

  Widget buildListProduct(model, context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 120.0,
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(model.image),
                    width: 120.0,
                    height: 120.0,
                  ),
                  if (model.discount != 0)
                    Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Text(
                        'DISCOUNT',
                        style: TextStyle(
                          fontSize: 8.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        height: 1.3,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          model.price.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: defaultColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (model.discount != 0)
                          Text(
                            model.oldPrice.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Spacer(),
                        Expanded(
                          child: IconButton(
                              icon: ShopCubit.get(context).favorites[model.id]!
                                  ? Icon(
                                      Icons.favorite,
                                      size: 17.0,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      size: 17.0,
                                      // color: Colors.white,
                                    ),
                              onPressed: () {
                                ShopCubit.get(context)
                                    .changeFavorites(model.id);
                                print(model.id);
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
