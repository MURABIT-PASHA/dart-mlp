import 'package:flutter/services.dart' show rootBundle;
import 'arff.dart';
import 'arff_attributes.dart';
import 'arff_data.dart';


/// The `ARFFConverter` class is responsible for parsing ARFF (Attribute-Relation File Format)
/// files and converting them into a structured `ARFF` object. This class reads ARFF files,
/// extracts the relation, attributes, and data, and organizes them into appropriate structures.
///
/// The ARFF format is commonly used for representing datasets in machine learning, and this
/// class facilitates the conversion of ARFF files into Dart objects for further processing.
///
/// **Example usage:**
/// ```dart
/// final converter = ARFFConverter();
/// final arff = await converter.parseARFFFile(fileName: 'path/to/arff/file.arff');
/// ```
///
/// The `parseARFFFile` method reads the contents of the ARFF file, processes each line,
/// and constructs the [ARFF] object. It handles the relation, attributes, and data sections
/// of the ARFF file format.
///
class ARFFConverter {

  Future<ARFF> parseARFFFile({required String fileName}) async {
    final fileContent = await rootBundle.loadString(fileName);
    final lines = fileContent.split('\n');
    String relation = '';
    List<ARFFAttributes> attributesList = [];
    List<List<ARFFData>> arffData = [];
    bool dataSection = false;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('%')) continue;

      if (line.startsWith('@relation')) {
        relation = line.split(' ')[1];
      } else if (line.startsWith('@attribute')) {
        final parts = line.split(' ');
        final name = parts[1];
        final type = parts
            .sublist(2)
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .replaceAll(' ', '')
            .replaceAll(',,', ',');

        if (type.startsWith('{')) {
          final values = type
              .substring(1, type.length - 1)
              .split(',')
              .map((v) => v
              .trim()
              .replaceAll('\'', '')
              .replaceAll('}', '')
              .replaceAll(']', ''))
              .toList();
          attributesList.add(ARFFAttributes(name, 'nominal', values));
        } else {
          attributesList.add(ARFFAttributes(name, type));
        }
      } else if (line.startsWith('@data')) {
        dataSection = true;
      } else if (dataSection) {
        List<dynamic> values =
        line.split(',').map((v) => v.trim().replaceAll("\'", "")).toList();
        List<ARFFData> arffDtList = [];
        for (int index = 0; index < attributesList.length; index++) {
          ARFFData arffDt =
          ARFFData(name: attributesList[index].name, value: values[index]);
          arffDtList.add(arffDt);
        }
        arffData.add(arffDtList);
      }
    }
    print(attributesList);
    return ARFF(relation, attributesList, arffData);
  }

  Future<ARFF> parseCSVFile({required String fileName}) async {
    final fileContent = await rootBundle.loadString(fileName);
    final lines = fileContent.split('\n');
    String relation = fileName;
    List<ARFFAttributes> attributesList = [];
    List<List<ARFFData>> arffData = [];

    if (lines.isEmpty) return ARFF(relation, attributesList, arffData);

    List<String> header = lines.first.split(',').map((h) => h.trim().replaceAll('"', '')).toList();
    lines.removeAt(0);

    List<Set<String>> nominalValues = List.generate(header.length, (_) => <String>{});
    List<bool> isNumericColumn = List.generate(header.length, (_) => true);

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      final values = line.split(',').map((v) => v.trim().replaceAll('"', '')).toList();

      for (int i = 0; i < values.length; i++) {
        final value = values[i];

        if (double.tryParse(value) == null) {
          isNumericColumn[i] = false;
          nominalValues[i].add(value);
        }
      }
    }

    for (int i = 0; i < header.length; i++) {
      final name = header[i];

      if (isNumericColumn[i]) {
        attributesList.add(ARFFAttributes(name, 'numeric'));
      } else {
        attributesList.add(ARFFAttributes(name, 'nominal', nominalValues[i].toList()));
      }
    }
    for (var line in lines) {
      final values = line.split(',').map((v) => v.trim().replaceAll('"', '')).toList();
      List<ARFFData> arffDtList = [];
      for (int index = 0; index < attributesList.length; index++) {
        ARFFData arffDt = ARFFData(name: attributesList[index].name, value: values[index]);
        arffDtList.add(arffDt);
      }

      arffData.add(arffDtList);
    }
    print(attributesList);
    return ARFF(relation, attributesList, arffData);

  }
}