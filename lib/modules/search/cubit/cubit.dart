import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ecommerce/models/search_model.dart';
import 'package:shop_ecommerce/modules/search/cubit/states.dart';
import 'package:shop_ecommerce/shared/components/constants.dart';
import 'package:shop_ecommerce/shared/network/end_point.dart';
import 'package:shop_ecommerce/shared/network/remote/dio_helper.dart';


class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel ?model;

  void search(String text) {
    emit(SearchLoadingState());

    DioHelper.postData(
      url: '',
     // url: SEARCH,
      data: {
        'text': text,
      },
    ).then((value)
    {
      model = SearchModel.fromJson(value.data);

      emit(SearchSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
