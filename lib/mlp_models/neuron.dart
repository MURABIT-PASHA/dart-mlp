
import 'edge.dart';

/// The `Neuron` class represents a single neuron in a neural network,
/// encapsulating its value, name, input and output edges, error, and old value.
///
/// This class is essential for managing the state and connections of neurons
/// in neural networks, particularly in machine learning models and algorithms
/// such as feedforward neural networks and backpropagation.
///
/// Properties:
/// - double? value: The current value of the neuron.
/// - String? name: The name or identifier of the neuron.
/// - List<Edge>? inputEdges: A list of edges coming into this neuron.
/// - List<Edge>? outputEdges: A list of edges going out from this neuron.
/// - double? error: The computed error value of the neuron.
/// - double? oldValue: The previous value of the neuron.
///
class Neuron {
  double? value;
  String? name;
  List<Edge>? inputEdges;
  List<Edge>? outputEdges;
  double? error;
  double? oldValue;
  Neuron({
    this.value,
    this.name,
    this.inputEdges,
    this.outputEdges,
    this.error,
    this.oldValue,
  });
}