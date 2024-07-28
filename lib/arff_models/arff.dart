import 'package:mlp/arff_models/arff_exceptions.dart';
import 'package:mlp/mlp_models/neuron.dart';

import 'arff_attributes.dart';
import 'arff_data.dart';

class ARFF {
  String relation;
  List<ARFFAttributes> attributesList;
  List<List<ARFFData>> data;

  ARFF(this.relation, this.attributesList, this.data);

  @override
  String toString() {
    return 'ARFF{relation: $relation, attributesList: $attributesList, data: $data}';
  }

  List<Neuron> getOutputLayerNeurons({required String className}) {
    try {
      List<Neuron> neurons = [];
      ARFFAttributes attributes =
          attributesList.firstWhere((attribute) => attribute.name == className);
      if (attributes.type == 'nominal') {
        for (String name in attributes.nominalValues!) {
          neurons.add(Neuron(name: name));
        }
        return neurons;
      } else if (attributes.type == 'numeric') {
        neurons.add(Neuron(name: attributes.name));
        return neurons;
      } else {
        return [];
      }
    } catch (exception) {
      throw OutputLayerNameError();
    }
  }

  List<Neuron> getInputLayerNeurons({required String className}) {
    try {
      List<Neuron> neurons = [];
      List<ARFFAttributes> attributes = [];
      attributes.addAll(attributesList);
      attributes.removeWhere((attr) => attr.name == className);
      for (ARFFAttributes attribute in attributes) {
        if (attribute.type == 'nominal') {
          for (String name in attribute.nominalValues!) {
            neurons.add(Neuron(name: name));
          }
        } else {
          neurons.add(Neuron(name: attribute.name));
        }
      }
      return neurons;
    } catch (exception) {
      throw OutputLayerNameError();
    }
  }
}
