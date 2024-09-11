import 'package:flutter_test/flutter_test.dart';

import 'package:mlp/mlp.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  ARFFConverter arffConverter = ARFFConverter();
  ARFF arff =
      await arffConverter.parseARFFFile(fileName: 'assets/penguins.arff');
  // ARFF arff = await arffConverter.parseCSVFile(fileName: 'assets/penguins.csv');
  MultilayerPerceptron mlp = MultilayerPerceptron(
    hiddenLayerCount: 3,
    hiddenLayerNeuronCount: 7,
    inputLayer:
        Layer.input(neurons: arff.getInputLayerNeurons(className: 'species')),
    outputLayer:
        Layer.output(neurons: arff.getOutputLayerNeurons(className: 'species')),
  );
  // 'Gentoo','Biscoe',42.8,14.2,209,4700,'female'
  // 'Adelie','Biscoe',37.8,20.0,190,4250,'male'
  var model1 = await mlp.createModel(
      ARFFModelCreationParameter(arff: arff, className: 'species'));
  String jsonString = await model1.toJson();

  var model = await Model.fromJson(jsonString: jsonString);
  var prediction = mlp.getPrediction(arff: arff, model: model, data: [
    ARFFData(name: 'island', value: 'Biscoe'),
    ARFFData(name: 'flipper_length_mm', value: '209'),
    ARFFData(name: 'bill_length_mm', value: '42.8'),
    ARFFData(name: 'bill_depth_mm', value: '14.2'),
    ARFFData(name: 'sex', value: 'female'),
    ARFFData(name: 'body_mass_g', value: '4700'),
  ]);
  var prediction2 = mlp.getPrediction(arff: arff, model: model, data: [
    ARFFData(name: 'island', value: 'Biscoe'),
    ARFFData(name: 'flipper_length_mm', value: '190'),
    ARFFData(name: 'bill_length_mm', value: '37.8'),
    ARFFData(name: 'bill_depth_mm', value: '20.0'),
    ARFFData(name: 'sex', value: 'male'),
    ARFFData(name: 'body_mass_g', value: '4250'),
  ]);
  print(prediction);
  print(prediction2);
}
