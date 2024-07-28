import 'package:mlp/enums.dart';

import 'neuron.dart';

/// The [Layer] class represents a layer in a neural network, containing a list of neurons
/// and references to the previous and next layers. This class provides factory constructors
/// for creating input, hidden, and output layers, facilitating the construction of different
/// types of layers in a neural network.
///
/// The [Layer] class is essential for organizing neurons into structured layers, enabling
/// the definition of the network's architecture and the flow of data through the network.
///
/// **Properties:**
/// - LayerType layerType: The type of the layer (input, hidden, or output).
/// - List<Neuron> neurons: A list of neurons in the layer.
/// - Layer? previousLayer: A reference to the previous layer in the network.
/// - Layer? nextLayer: A reference to the next layer in the network.
///
/// **Example usage:**
/// ```dart
/// final inputNeurons = [Neuron(name: 'Input1'), Neuron(name: 'Input2')];
/// final inputLayer = Layer.input(neurons: inputNeurons);
///
/// final hiddenNeurons = [Neuron(name: 'Hidden1'), Neuron(name: 'Hidden2')];
/// final hiddenLayer = Layer.hidden(neurons: hiddenNeurons, previousLayer: inputLayer);
///
/// final outputNeurons = [Neuron(name: 'Output1')];
/// final outputLayer = Layer.output(neurons: outputNeurons);
///
/// inputLayer.nextLayer = hiddenLayer;
/// hiddenLayer.nextLayer = outputLayer;
/// ```
///
/// The [Layer] class enables the construction of a neural network by linking layers of neurons together.
/// Each layer can reference the previous and next layers, allowing for the creation of complex network
/// architectures and the propagation of data through the network.
class Layer {
  final LayerType layerType;
  final List<Neuron> neurons;
  Layer? previousLayer;
  Layer? nextLayer;

  Layer._({
    required this.layerType,
    required this.neurons,
    this.previousLayer,
    this.nextLayer,
  });

  factory Layer.input({required List<Neuron> neurons}) {
    return Layer._(
      layerType: LayerType.input,
      neurons: neurons,
      previousLayer: null,
      nextLayer: null,
    );
  }

  factory Layer.hidden({
    required List<Neuron> neurons,
    required Layer previousLayer,
    Layer? nextLayer,
  }) {
    return Layer._(
      layerType: LayerType.hidden,
      neurons: neurons,
      previousLayer: previousLayer,
      nextLayer: nextLayer,
    );
  }

  factory Layer.output({required List<Neuron> neurons}) {
    return Layer._(
      layerType: LayerType.output,
      neurons: neurons,
      previousLayer: null,
      nextLayer: null,
    );
  }
}