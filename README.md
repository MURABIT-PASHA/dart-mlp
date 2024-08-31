# mlp

`mlp` is a Dart package for constructing and working with multi-layer perceptron (MLP) neural networks. It provides classes to define neurons, layers, edges, and the overall model, enabling easy creation and manipulation of neural networks for machine learning tasks.

## Features

<img src="https://github.com/MURABIT-PASHA/Images/raw/main/mlp_example.gif" alt="Flutter App Demo" width="230" height="400">

- Define neurons (`Neuron` class) with various attributes such as value, name, and connections.
- Create layers (`Layer` class) with different types (input, hidden, output) and manage their connectivity.
- Establish connections between neurons using edges (`Edge` class) with optional weights.
- Build and manage the entire neural network model (`Model` class).

## Getting started

To start using the `mlp` package, add it to your `pubspec.yaml`:

```yaml
dependencies:
  mlp: ^0.0.3
```
Then, run `pub get` to install the package.

## Usage
Here is a simple example to demonstrate how to use the mlp package to create a neural network:
```dart
void main() async{
  ARFFConverter arffConverter = ARFFConverter();
  ARFF arff = await arffConverter.parseARFFFile(fileName: 'assets/penguins.arff');
  // Or csv file like that one:
  // ARFF arff = await arffConverter.parseARFFFile(fileName: 'assets/penguins.csv');
  MultilayerPerceptron mlp = MultilayerPerceptron(
    inputLayer: Layer.input(
        neurons: arff.getInputLayerNeurons(className: 'species')),
    outputLayer:
    Layer.output(neurons: arff.getOutputLayerNeurons(className: 'species')),
  );
  // 'Gentoo','Biscoe',42.8,14.2,209,4700,'female'
  // 'Adelie','Biscoe',37.8,20.0,190,4250,'male'
  var model = mlp.createModelFromArff(ARFFModelCreationParameter(arff: arff, className: 'species'));
  var prediction = mlp.getPrediction(arff: arff, model: model, data: [
    ARFFData(name: 'island', value: 'Biscoe'),
    ARFFData(name: 'flipper_length_mm', value: '209'),
    ARFFData(name: 'bill_length_mm', value: '42.8'),
    ARFFData(name: 'bill_depth_mm', value: '14.2'),
    ARFFData(name: 'sex', value: 'female'),
    ARFFData(name: 'body_mass_g', value: '4700'),
  ]);
  var prediction2 = mlp.getPrediction(arff: arff, model:model, data: [
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
```

## Additional information

To contribute to this package, please visit the GitHub repository and follow the contribution guidelines.

If you encounter any issues, please file them on the issue tracker. The package authors will try to respond as quickly as possible.