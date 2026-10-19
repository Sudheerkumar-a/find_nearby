import 'package:find_nearby/core/utils/device_actions.dart';
import 'package:find_nearby/domain/entities/place.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('whatsapp link opens a chat for the phone number', () {
    expect(
      DeviceActions.whatsAppChatUri('+971 50 123 4567').toString(),
      'https://wa.me/971501234567',
    );
    expect(DeviceActions.whatsAppDigits('00971501234567'), '971501234567');
    expect(DeviceActions.whatsAppDigits('+44 20 7946 0958'), '442079460958');
    expect(
      DeviceActions.whatsAppDigits(
        '0529098488',
        address: 'Al Quoz, Dubai, United Arab Emirates',
      ),
      '971529098488',
    );
    expect(
      DeviceActions.whatsAppDigits(
        '020 7946 0958',
        address: '10 Downing Street, London, United Kingdom',
      ),
      '442079460958',
    );
    expect(
      DeviceActions.whatsAppDigits('09876543210', address: 'Mumbai, India'),
      '919876543210',
    );
  });

  test('nearby map uri searches the subcategory at the user location', () {
    final uri = DeviceActions.nearbyMapUri(
      latitude: 25.2,
      longitude: 55.27,
      query: 'Car wash',
    );
    expect(uri.scheme, 'https');
    expect(uri.host, 'www.google.com');
    expect(uri.toString(), contains('Car%20wash'));
    expect(uri.toString(), contains('25.2,55.27,14z'));
    expect(uri.toString(), contains('6e1'));
  });

  test('place map uri opens a Google listing by place id', () {
    final uri = DeviceActions.placeMapUri(
      const Place(
        id: 'googlePlaces:ChIJtest',
        provider: PlaceSource.googlePlaces,
        providerPlaceId: 'ChIJtest',
        name: 'Twaddan LLC',
        latitude: 25.2,
        longitude: 55.27,
      ),
    );
    expect(uri.queryParameters['query_place_id'], 'ChIJtest');
    expect(uri.queryParameters['query'], 'Twaddan LLC');
  });

  test('place map uri opens coordinates when there is no Google place id', () {
    final uri = DeviceActions.placeMapUri(
      const Place(
        id: 'geoapify:abc',
        provider: PlaceSource.geoapify,
        providerPlaceId: 'abc',
        name: 'Twaddan LLC',
        latitude: 25.2,
        longitude: 55.27,
      ),
    );
    expect(uri.queryParameters['query'], '25.2,55.27');
    expect(uri.queryParameters.containsKey('query_place_id'), isFalse);
  });
}
