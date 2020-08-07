const GOOGLE_API_KEY = 'AIzaSyDZQiTjmUsm8HEJ3qtgiT0nCc3u68Oj0Tw';

class LocationHelper {
  // here we return a url to such image created by google passed on these coordinates
  //  search on google maps static api to fing the document
  // https://developers.google.com/maps/documentation/maps-static/overview
  static String generateLocationPreviewImage({double latitude, double longitude,}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }
}