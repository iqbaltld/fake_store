import 'dart:io';

String fixture(String name) => File('test/helpers/dummy_data/$name').readAsStringSync();