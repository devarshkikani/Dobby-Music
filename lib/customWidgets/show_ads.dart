import 'package:musify/customWidgets/ads_id.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class ShowAds {
  factory ShowAds() {
    return showAds;
  }
  ShowAds._internal();
  static final ShowAds showAds = ShowAds._internal();

  Map<String, bool> placements = <String, bool>{
    AdsIds.interstitialVideoAdPlacementId: false,
    AdsIds.rewardedVideoAdPlacementId: false,
  };

  void loadAds() {
    // ignore: prefer_foreach
    for (final String element in placements.keys) {
      _loadAd(element);
    }
  }

  void _loadAd(String placementId) {
    UnityAds.load(
      placementId: placementId,
      onComplete: (String placementId) {
        print('Load Complete $placementId');
        placements[placementId] = true;
      },
      onFailed: (String placementId, UnityAdsLoadError error, String message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  void showAd(String placementId, Function() nextStep) {
    placements[placementId] = false;
    UnityAds.showVideoAd(
      placementId: placementId,
      onComplete: (String placementId) {
        print('Video Ad $placementId completed');
        _loadAd(placementId);
        nextStep();
      },
      onFailed: (String placementId, UnityAdsShowError error, String message) {
        print('Video Ad $placementId failed: $error $message');
        _loadAd(placementId);
        nextStep();
      },
      onStart: (String placementId) => print('Video Ad $placementId started'),
      onClick: (String placementId) => print('Video Ad $placementId click'),
      onSkipped: (String placementId) {
        print('Video Ad $placementId skipped');
        _loadAd(placementId);
        nextStep();
      },
    );
  }
}
