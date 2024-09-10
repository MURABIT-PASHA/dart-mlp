import 'package:mlp/mlp_models/layer.dart';

/// The [Model] class represents a neural network model, composed of a list of layers.
/// This class is fundamental for defining the structure of a neural network, where
/// each layer contains neurons that are connected to form the network.
/// **Make sure to connect all layers with edges before building the model.**
class Model {
  final List<Layer> layers;

  Model({required this.layers});

  Future<bool> save() async {
    return false;
  }
}
