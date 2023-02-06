import 'package:flutter_test/flutter_test.dart';
import 'package:journeyhazard/features/mobile/data/repositories/mobile-repositories-implementation.dart';

Future<void> main() async {

  test(
    'test destinations',//name
        () async {
     MobileRepositoryImplementation remoteDataSource =MobileRepositoryImplementation();
      await remoteDataSource.getAllDestinations();
    }
  );
}