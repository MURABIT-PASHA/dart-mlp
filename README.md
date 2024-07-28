# mlp

`mlp` is a Dart package for constructing and working with multi-layer perceptron (MLP) neural networks. It provides classes to define neurons, layers, edges, and the overall model, enabling easy creation and manipulation of neural networks for machine learning tasks.

## Features

- Define neurons (`Neuron` class) with various attributes such as value, name, and connections.
- Create layers (`Layer` class) with different types (input, hidden, output) and manage their connectivity.
- Establish connections between neurons using edges (`Edge` class) with optional weights.
- Build and manage the entire neural network model (`Model` class).

## Getting started

To start using the `mlp` package, add it to your `pubspec.yaml`:

```yaml
dependencies:
  mlp: ^1.0.0
```
Then, run `pub get` to install the package.

## Usage
Here is a simple example to demonstrate how to use the mlp package to create a neural network:
```dart
import 'package:mlp/mlp.dart';

void main() {
  // Create neurons
  final inputNeurons = [Neuron(name: 'Input1'), Neuron(name: 'Input2')];
  final hiddenNeurons = [Neuron(name: 'Hidden1'), Neuron(name: 'Hidden2')];
  final outputNeurons = [Neuron(name: 'Output1')];

  // Create layers
  final inputLayer = Layer.input(neurons: inputNeurons);
  final hiddenLayer = Layer.hidden(neurons: hiddenNeurons, previousLayer: inputLayer);
  final outputLayer = Layer.output(neurons: outputNeurons);

  // Connect layers
  inputLayer.nextLayer = hiddenLayer;
  hiddenLayer.nextLayer = outputLayer;

  // Build the model
  final model = Model(layers: [inputLayer, hiddenLayer, outputLayer]);

  print('Neural network model created successfully!');
}
```

## Additional information

To contribute to this package, please visit the GitHub repository and follow the contribution guidelines.

If you encounter any issues, please file them on the issue tracker. The package authors will try to respond as quickly as possible.