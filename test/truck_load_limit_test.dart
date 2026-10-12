import 'package:flutter_test/flutter_test.dart';
import 'package:mz_logistics_service_provider_app/shared/models/truck.dart';

void main() {
  test('trip load defaults to 25 tons without exceeding capacity', () {
    const large = Truck(id: 1, capacityTons: 40);
    const small = Truck(id: 2, capacityTons: 12);
    const custom = Truck(id: 3, capacityTons: 40, tripLoadLimitTons: 30);

    expect(large.tripLoadTons, 25);
    expect(small.tripLoadTons, 12);
    expect(custom.tripLoadTons, 30);
    expect(large.canCarry(25), isTrue);
    expect(large.canCarry(26), isFalse);
  });
}
