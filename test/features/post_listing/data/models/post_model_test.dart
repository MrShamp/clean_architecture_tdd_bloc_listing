import 'dart:convert';

import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/data/models/post_model.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tPostModel = PostModel(
    id: '0',
    author: 'Alejandro Escamilla',
    url: 'https://unsplash.com/photos/yC-Yzbqy7PY',
    downloadUrl: 'https://picsum.photos/id/0/5616/3744',
    width: 5616,
    height: 3741,
  );

  test(
    'Should be a subclass of Post entity',
    () async {
      // assert
      expect(tPostModel, isA<Post>());
    },
  );
  group('fromJson', () {
    test(
      'Should return valid model when JSON receive',
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('post.json'));
        // act
        final result = PostModel.fromJson(jsonMap);
        // assert
        expect(result, tPostModel);
      },
    );
  });

  group('toJson', () {
    test(
      'Should return a JSON map containing the proper data',
      () async {
        // act
        final result = tPostModel.toJson();
        // assert
        final expectedMap = {
          "id": "0",
          "author": "Alejandro Escamilla",
          "width": 5616,
          "height": 3741,
          "url": "https://unsplash.com/photos/yC-Yzbqy7PY",
          "download_url": "https://picsum.photos/id/0/5616/3744"
        };
        expect(result, expectedMap);
      },
    );
  });
}
