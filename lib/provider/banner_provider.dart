import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/banner_model.dart';

class BannerProvider extends StateNotifier<List<BannerModel>> {
  BannerProvider() : super([]);

  //set the list of banners
  void setBanners(List<BannerModel> banners) {
    state = banners;
  }
}

final bannerProvider =
    StateNotifierProvider<BannerProvider, List<BannerModel>>((ref) {
  return BannerProvider();
});
