import 'package:flutter/material.dart';
import 'package:shop_ecommerce/layout/cubit/cubit.dart';
import 'package:shop_ecommerce/layout/cubit/states.dart';
 import 'package:shop_ecommerce/modules/search/search_screen.dart';
import 'package:shop_ecommerce/shared/components/componets.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit= ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Shop App'),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                 navigateTo(context, SearchScreen());
                },
              ),
            ],
          ),
          body: cubit.listScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: cubit.bottomItem,
            currentIndex: cubit.currentIndex,
            onTap: (value) {
              cubit.changeBottomNav(value);
            },
          ),
        );
      },
    );
  }
}
