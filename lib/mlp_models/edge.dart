import 'neuron.dart';

/// The [Edge] class represents a connection between two neurons in a neural network,
/// encapsulating the weight of the connection and references to the input and output neurons.
///
/// This class is essential for managing the connections and weights between neurons
/// in neural networks, facilitating the flow of data and the learning process.
///
/// **Properties:**
/// - double? weight: The weight of the connection between the input and output neurons.
/// - Neuron inputNeuron: The neuron from which the connection originates.
/// - Neuron outputNeuron: The neuron to which the connection leads.
///
/// **Example usage:**
/// ```dart
/// final inputNeuron = Neuron(name: 'Input');
/// final outputNeuron = Neuron(name: 'Output');
/// final edge = Edge(inputNeuron: inputNeuron, outputNeuron: outputNeuron, weight: 0.5);
/// ```
///
/// The [Edge] class is used to define the connections in a neural network, with each edge
/// having a weight that influences the strength of the connection. This is crucial for
/// the propagation of signals and the adjustment of weights during the learning process.
class Edge {
  double? weight;
  final Neuron inputNeuron;
  final Neuron outputNeuron;

  Edge({
    required this.inputNeuron,
    required this.outputNeuron,
    this.weight,
  });
}