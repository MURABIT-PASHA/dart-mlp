library mlp;

import 'dart:math';

import 'package:mlp/mlp_models/model.dart';

import 'arff_models/arff.dart';
import 'arff_models/arff_attributes.dart';
import 'arff_models/arff_data.dart';
import 'enums.dart';
import 'mlp_models/edge.dart';
import 'mlp_models/layer.dart';
import 'mlp_models/neuron.dart';


class MultilayerPerceptron {
  final int hiddenLayerCount;
  final int hiddenLayerNeuronCount;
  final Layer inputLayer;
  final Layer outputLayer;
  final int epoch;
  final bool useBias;
  final double learningRate;
  final Function activationFunction;

  MultilayerPerceptron({
    required this.inputLayer,
    required this.outputLayer,
    this.hiddenLayerCount = 1,
    this.hiddenLayerNeuronCount = 2,
    this.epoch = 500,
    this.useBias = false,
    this.learningRate = 0.01,
    this.activationFunction = defaultActivationFunction,
  });

  static double defaultActivationFunction(double x) {
    // Default activation function (e.g., sigmoid)
    return 1 / (1 + exp(-x));
  }

  List<Layer> createLayers() {
    Layer previousLayer = inputLayer;
    List<Layer> hiddenLayers = [];

    for (int i = 0; i < hiddenLayerCount; i++) {
      List<Neuron> neuronList = [];
      for (int j = 0; j < hiddenLayerNeuronCount; j++) {
        Neuron neuron = Neuron(value: 0.0);
        neuronList.add(neuron);
      }
      Layer layer = Layer.hidden(
        previousLayer: previousLayer,
        nextLayer: null,
        neurons: neuronList,
      );
      if (i == hiddenLayerCount - 1) {
        layer.nextLayer = outputLayer;
      }

      previousLayer.nextLayer ??= layer;

      hiddenLayers.add(layer);
      previousLayer = layer;
    }
    List<Layer> layers = [];
    outputLayer.previousLayer = hiddenLayers.last;
    layers.add(inputLayer);
    layers.addAll(hiddenLayers);
    layers.add(outputLayer);
    return layers;
  }

  List<Layer> connectLayers({required List<Layer> layers}) {
    for (Layer layer in layers) {
      if (layer.layerType == LayerType.input) {
        for (Neuron neuron in layer.neurons) {
          neuron.outputEdges = [];
          for (Neuron nextLayerNeuron in layer.nextLayer!.neurons) {
            Random random = Random();
            double randomDouble = (random.nextDouble() * 2) - 1;
            Edge edge = Edge(
                weight: randomDouble,
                inputNeuron: neuron,
                outputNeuron: nextLayerNeuron);
            neuron.outputEdges!.add(edge);
          }
        }
      } else if (layer.layerType == LayerType.hidden) {
        for (Neuron neuron in layer.neurons) {
          neuron.inputEdges = [];
          neuron.outputEdges = [];
          for (Neuron nextLayerNeuron in layer.nextLayer!.neurons) {
            Random random = Random();
            double randomDouble = (random.nextDouble() * 2) - 1;
            Edge edge = Edge(
                weight: randomDouble,
                inputNeuron: neuron,
                outputNeuron: nextLayerNeuron);
            neuron.outputEdges!.add(edge);
          }
          for (Neuron previousLayerNeuron in layer.previousLayer!.neurons) {
            for (Edge previousEdge in previousLayerNeuron.outputEdges!) {
              if (previousEdge.outputNeuron == neuron) {
                neuron.inputEdges!.add(previousEdge);
              }
            }
          }
        }
      } else {
        for (Neuron neuron in layer.neurons) {
          neuron.inputEdges = [];
          for (Neuron previousLayerNeuron in layer.previousLayer!.neurons) {
            for (Edge previousEdge in previousLayerNeuron.outputEdges!) {
              if (previousEdge.outputNeuron == neuron) {
                neuron.inputEdges!.add(previousEdge);
              }
            }
          }
        }
      }
    }
    return layers;
  }

  Map<String, List<double>> _normalizationReferenceValues(
      {required List<List<ARFFData>> arffData}) {
    int numColumns = arffData.first.length;
    List<double> minValues = List.filled(numColumns, double.infinity);
    List<double> maxValues = List.filled(numColumns, double.negativeInfinity);

    for (int col = 0; col < numColumns; col++) {
      for (List<ARFFData> dt in arffData) {
        try {
          double value = double.parse(dt[col].value);
          if (value < minValues[col]) {
            minValues[col] = value;
          }
          if (value > maxValues[col]) {
            maxValues[col] = value;
          }
        } catch (ex) {
          continue;
        }
      }
    }
    return {'minValues': minValues, 'maxValues': maxValues};
  }
  
  /// This function creates a model from given [ARFF] file and class name
  Model createModelFromArff({required ARFF arff, required String className}) {
    List<Layer> mlp = connectLayers(layers: createLayers());
    List<List<ARFFData>> data =
    arff.data.map((list) => List<ARFFData>.from(list)).toList();
    int dataLineIndex = 0;
    int classIndex =
    arff.attributesList.indexWhere((attrs) => attrs.name == className);
    for (List<ARFFData> dt in data) {
      dt.removeAt(classIndex);
    }

    Map<String, List<double>> normalizationValues =
    _normalizationReferenceValues(arffData: data);

    List<ARFFAttributes> attrs = [];
    attrs.addAll(arff.attributesList);
    attrs.removeAt(classIndex);

    for (int i = 0; i < epoch; i++) {
      data = arff.data.map((list) => List<ARFFData>.from(list)).toList();
      dataLineIndex = 0;
      classIndex =
          arff.attributesList.indexWhere((attrs) => attrs.name == className);
      for (List<ARFFData> dt in data) {
        dt.removeAt(classIndex);
      }
      do {
        Map<String, double> inputNomAttribValue = {};
        for (ARFFAttributes attr in attrs) {
          if (attr.type == 'nominal') {
            for (ARFFData arffDt in data.first) {
              if (arffDt.name == attr.name) {
                inputNomAttribValue[arffDt.value] = 1.0;
              }
            }
          }
        }

        Map<String, double> outputNomAttribValue = {};
        if (arff.attributesList[classIndex].type == 'nominal') {
          if (arff.data[dataLineIndex][classIndex].name ==
              arff.attributesList[classIndex].name) {
            outputNomAttribValue[arff.data[dataLineIndex][classIndex].value] =
            1.0;
          }
        }

        for (Layer layer in mlp) {
          if (layer.layerType == LayerType.input) {
            for (Neuron neuron in layer.neurons) {
              try {
                if (inputNomAttribValue.containsKey(neuron.name)) {
                  neuron.value = inputNomAttribValue[neuron.name];
                } else if (neuron.name ==
                    data.first
                        .firstWhere((dt) => dt.name == neuron.name)
                        .name) {
                  int index =
                  data.first.indexWhere((dt) => dt.name == neuron.name);
                  neuron.value = (double.parse(data.first
                      .firstWhere((dt) => dt.name == neuron.name)
                      .value) -
                      normalizationValues['minValues']![index]) /
                      (normalizationValues['maxValues']![index] -
                          normalizationValues['minValues']![index]);
                }
              } catch (exception) {
                neuron.value = 0.0;
              }
            }
          } else if (layer.layerType == LayerType.output) {
            for (Neuron neuron in layer.neurons) {
              try {
                if (outputNomAttribValue.containsKey(neuron.name)) {
                  neuron.value = outputNomAttribValue[neuron.name];
                } else if (neuron.name ==
                    arff.data[dataLineIndex][classIndex].name) {
                  neuron.value =
                      double.parse(arff.data[dataLineIndex][classIndex].value);
                } else {
                  neuron.value = 0.0;
                }
              } catch (except) {
                neuron.value = 0.0;
              }
            }
          }
        }

        for (Layer layer in mlp) {
          if (layer.layerType == LayerType.hidden ||
              layer.layerType == LayerType.output) {
            for (Neuron neuron in layer.neurons) {
              double net = 0.0;
              for (Edge edge in neuron.inputEdges!) {
                net += edge.weight! * edge.inputNeuron.value!;
              }
              neuron.oldValue = neuron.value;
              neuron.value = activationFunction(net);
            }
          }
        }

        // ERROR CALCULATION
        Layer currentLayer = mlp.last;
        for (Layer layer in mlp) {
          if (layer.layerType == LayerType.output) {
            currentLayer = layer;
            for (Neuron neuron in layer.neurons) {
              neuron.error = neuron.value! *
                  (1 - neuron.value!) *
                  (neuron.oldValue! - neuron.value!);
            }
          }
        }

        do {
          for (Neuron neuron in currentLayer.neurons) {
            for (Edge inEdge in neuron.inputEdges!) {
              double error = 0;
              for (Edge outEdge in inEdge.inputNeuron.outputEdges!) {
                error += outEdge.weight! * outEdge.outputNeuron.error!;
              }
              inEdge.inputNeuron.error = inEdge.inputNeuron.value! *
                  (1 - inEdge.inputNeuron.value!) *
                  error;
            }
          }
          currentLayer = currentLayer.previousLayer!;
        } while (currentLayer.layerType != LayerType.input);

        //WEIGHT UPDATES
        do {
          for (Neuron neuron in currentLayer.neurons) {
            for (Edge edge in neuron.outputEdges!) {
              edge.weight = edge.weight! +
                  learningRate *
                      edge.outputNeuron.error! *
                      edge.inputNeuron.value!;
            }
          }
          currentLayer = currentLayer.nextLayer!;
        } while (currentLayer.layerType != LayerType.output);

        dataLineIndex++;
        data.removeAt(0);
      } while (data.isNotEmpty);
    }
    return Model(layers: mlp);
  }

  Map<String, double> getPrediction(
      {required ARFF arff,
        required Model model,
        required List<ARFFData> data}) {
    Map<String, double> nomInputValues = {};
    Map<String, List<double>> normalizationValues =
    _normalizationReferenceValues(arffData: arff.data);
    for (ARFFAttributes arffAttributes in arff.attributesList) {
      for (ARFFData arffData in data) {
        if (arffData.name == arffAttributes.name) {
          if (arffAttributes.type == 'nominal') {
            for (String nomValue in arffAttributes.nominalValues!) {
              if (arffData.value == nomValue) {
                nomInputValues[nomValue] = 1.0;
              } else {
                nomInputValues[nomValue] = 0.0;
              }
            }
          } else if (arffAttributes.type == 'numeric') {
            int index = arff.attributesList
                .indexWhere((val) => val.name == arffData.name);
            double min = normalizationValues['minValues']![index];
            double max = normalizationValues['maxValues']![index];
            nomInputValues[arffData.name] =
                (double.parse(arffData.value) - min) / (max - min);
          }
        }
      }
    }
    for (Layer layer in model.layers) {
      if (layer.layerType == LayerType.input) {
        for (Neuron neuron in layer.neurons) {
          if (nomInputValues.containsKey(neuron.name)) {
            neuron.value = nomInputValues[neuron.name];
          } else {
            neuron.value = 0.0;
          }
        }
      } else {
        for (Neuron neuron in layer.neurons) {
          double netVal = 0.0;
          for (Edge edge in neuron.inputEdges!) {
            netVal += edge.weight! * edge.inputNeuron.value!;
          }
          neuron.oldValue = neuron.value;
          neuron.value = activationFunction(netVal);
        }
      }
    }
    Map<String, double> prediction = {};
    for (Layer layer in model.layers) {
      if (layer.layerType == LayerType.output) {
        for (Neuron neuron in layer.neurons) {
          prediction[neuron.name!] = neuron.value!;
        }
      }
    }
    return prediction;
  }
}

