import 'dart:convert';

import 'package:mlp/enums.dart';
import 'package:mlp/mlp_models/layer.dart';

import 'edge.dart';
import 'neuron.dart';

/// The [Model] class represents a neural network model, composed of a list of layers.
/// This class is fundamental for defining the structure of a neural network, where
/// each layer contains neurons that are connected to form the network.
/// **Make sure to connect all layers with edges before building the model.**
class Model {
  final List<Layer> layers;

  Model({required this.layers});

  ///The `toJson()` method serializes the model's layers and their contents into a JSON format.
  ///Each layer's type, number of neurons, neuron names, values, and edge weights are included in the JSON string, which is returned when the operation is complete.
  Future<String> toJson() async {
    Map<String, Map<String, String>> layerMap = {};
    int index = 0;
    for (Layer layer in layers) {
      layerMap[index.toString()] = {
        'layerType': jsonEncode(layer.layerType.name),
        'neuronCount': jsonEncode(layer.neurons.length),
        'neuronNames':
            jsonEncode(layer.neurons.map((neuron) => neuron.name).toList()),
        'neuronValues':
            jsonEncode(layer.neurons.map((neuron) => neuron.value).toList()),
        'neuronOutputEdgeWeights': jsonEncode(layer.neurons
            .map((neuron) =>
                neuron.outputEdges?.map((edge) => edge.weight).toList())
            .toList()),
        'neuronInputEdgeWeights': jsonEncode(layer.neurons
            .map((neuron) =>
                neuron.inputEdges?.map((edge) => edge.weight).toList())
            .toList()),
        'neuronOldValues':
            jsonEncode(layer.neurons.map((neuron) => neuron.oldValue).toList()),
        'neuronError':
            jsonEncode(layer.neurons.map((neuron) => neuron.error).toList()),
      };
      index += 1;
    }
    String jsonString = jsonEncode(layerMap);
    return jsonString;
  }

  /// The `fromJson()` method takes a JSON string as input and reconstructs the model.
  /// It reads the JSON data, creates the input, hidden, and output layers, and establishes the connections (edges) between neurons.
  /// It returns the fully constructed model if successful; otherwise, it throws an exception.
  static Future<Model> fromJson({required String jsonString}) async {
    try {
      Map<String, dynamic> layerMap = jsonDecode(jsonString);
      Layer? inputLayer;
      List<Layer> hiddenLayers = [];
      Layer? outputLayer;

      for (String key in layerMap.keys) {
        int neuronCount = int.parse(layerMap[key]['neuronCount']);
        LayerType layerType = LayerType.values.firstWhere((element) =>
            element.name == jsonDecode(layerMap[key]['layerType']));
        if (layerType == LayerType.input) {
          if (neuronCount != 0) {
            List<Neuron> inputLayerNeurons = [];
            for (int i = 0; i < neuronCount; i++) {
              inputLayerNeurons.add(Neuron(
                value: jsonDecode(layerMap[key]['neuronValues'])[i] ?? 0.0,
                name: jsonDecode(layerMap[key]['neuronNames'])[i],
                oldValue:
                    jsonDecode(layerMap[key]['neuronOldValues'])[i] ?? 0.0,
                error: jsonDecode(layerMap[key]['neuronError'])[i] ?? 0.0,
              ));
            }
            inputLayer = Layer.input(neurons: inputLayerNeurons);
          } else {
            throw Exception(
                "Can't found any neuron in this ${layerMap[key]['layerType']}");
          }
        } else if (layerType == LayerType.hidden) {
          if (neuronCount != 0) {
            List<Neuron> hiddenLayerNeurons = [];
            for (int i = 0; i < neuronCount; i++) {
              hiddenLayerNeurons.add(Neuron(
                value: jsonDecode(layerMap[key]['neuronValues'])[i] ?? 0.0,
                name: jsonDecode(layerMap[key]['neuronNames'])[i],
                oldValue:
                    jsonDecode(layerMap[key]['neuronOldValues'])[i] ?? 0.0,
                error: jsonDecode(layerMap[key]['neuronError'])[i] ?? 0.0,
              ));
            }
            if (inputLayer != null && hiddenLayers.isEmpty) {
              Layer hiddenLayer = Layer.hidden(
                  neurons: hiddenLayerNeurons, previousLayer: inputLayer);
              inputLayer.nextLayer = hiddenLayer;
              hiddenLayers.add(hiddenLayer);
            } else {
              Layer previousHiddenLayer = hiddenLayers.last;
              Layer hiddenLayer = Layer.hidden(
                  neurons: hiddenLayerNeurons,
                  previousLayer: previousHiddenLayer);
              previousHiddenLayer.nextLayer = hiddenLayer;
              hiddenLayers.add(hiddenLayer);
            }
          }
        } else if (layerType == LayerType.output) {
          if (neuronCount != 0) {
            List<Neuron> outputLayerNeurons = [];
            for (int i = 0; i < neuronCount; i++) {
              outputLayerNeurons.add(Neuron(
                value: jsonDecode(layerMap[key]['neuronValues'])[i] ?? 0.0,
                name: jsonDecode(layerMap[key]['neuronNames'])[i],
                oldValue:
                    jsonDecode(layerMap[key]['neuronOldValues'])[i] ?? 0.0,
                error: jsonDecode(layerMap[key]['neuronError'])[i] ?? 0.0,
              ));
            }
            outputLayer = Layer.output(neurons: outputLayerNeurons);
            if (hiddenLayers.isNotEmpty) {
              Layer lastHiddenLayer = hiddenLayers.last;
              lastHiddenLayer.nextLayer = outputLayer;
              outputLayer.previousLayer = lastHiddenLayer;
            }
          } else {
            throw Exception(
                "Can't found any neuron in this ${layerMap[key]['layerType']}");
          }
        } else {
          throw Exception('Unknown layer type: ${layerMap[key]['layerType']}');
        }
      }

      int index = 0;
      for (String key in layerMap.keys) {
        LayerType layerType = LayerType.values.firstWhere((element) =>
            element.name == jsonDecode(layerMap[key]['layerType']));
        if (layerType == LayerType.input) {
          for (int i = 0; i < inputLayer!.neurons.length; i++) {
            List<double> outputEdgeWeights = List<double>.from(
                jsonDecode(layerMap[key]['neuronOutputEdgeWeights'])[i]);
            inputLayer.neurons[i].outputEdges = outputEdgeWeights
                .map((entry) => Edge(
                      weight: entry,
                      inputNeuron: inputLayer!.neurons[i],
                      outputNeuron: inputLayer.nextLayer!.neurons[
                          outputEdgeWeights
                              .indexWhere((test) => test == entry)],
                    ))
                .toList();
          }
        } else if (layerType == LayerType.hidden) {
          Layer hiddenLayer = hiddenLayers[index];

          for (int i = 0; i < hiddenLayer.neurons.length; i++) {
            List<double> inputEdgeWeights = List<double>.from(
                jsonDecode(layerMap[key]['neuronInputEdgeWeights'])[i]);
            hiddenLayer.neurons[i].inputEdges = inputEdgeWeights
                .asMap()
                .entries
                .map((entry) => Edge(
                      weight: entry.value,
                      inputNeuron:
                          hiddenLayer.previousLayer!.neurons[entry.key],
                      outputNeuron: hiddenLayer.neurons[i],
                    ))
                .toList();
          }

          for (int i = 0; i < hiddenLayer.neurons.length; i++) {
            List<double> outputEdgeWeights = List<double>.from(
                jsonDecode(layerMap[key]['neuronOutputEdgeWeights'])[i]);
            hiddenLayer.neurons[i].outputEdges = outputEdgeWeights
                .asMap()
                .entries
                .map((entry) => Edge(
                      weight: entry.value,
                      inputNeuron: hiddenLayer.neurons[i],
                      outputNeuron: hiddenLayer.nextLayer!.neurons[entry.key],
                    ))
                .toList();
          }
          index += 1;
        } else if (layerType == LayerType.output) {
          for (int i = 0; i < outputLayer!.neurons.length; i++) {
            List<double> inputEdgeWeights = List<double>.from(
                jsonDecode(layerMap[key]['neuronInputEdgeWeights'])[i]);
            outputLayer.neurons[i].inputEdges = inputEdgeWeights
                .asMap()
                .entries
                .map((entry) => Edge(
                      weight: entry.value,
                      inputNeuron:
                          outputLayer!.previousLayer!.neurons[entry.key],
                      outputNeuron: outputLayer.neurons[i],
                    ))
                .toList();
          }
        }
      }
      List<Layer> tmpLayers = [];
      tmpLayers.add(inputLayer!);
      tmpLayers.addAll(hiddenLayers);
      tmpLayers.add(outputLayer!);
      return Model(layers: tmpLayers);
    } catch (e) {
      throw Exception("Can't read from string");
    }
  }
}
