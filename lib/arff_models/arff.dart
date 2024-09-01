import 'package:mlp/arff_models/arff_exceptions.dart';
import 'package:mlp/mlp_models/neuron.dart';

import 'arff_attributes.dart';
import 'arff_data.dart';

/// Represents an ARFF (Attribute-Relation File Format) object.
///
/// This class provides methods to handle ARFF files, including obtaining
/// input and output layer neurons for a machine learning model.
class ARFF {
  /// The relation name of the ARFF file.
  String relation;

  /// A list of attributes in the ARFF file.
  List<ARFFAttributes> attributesList;

  /// A list of data entries in the ARFF file.
  List<List<ARFFData>> data;

  /// Creates an ARFF object with the specified [relation], [attributesList], and [data].
  ARFF(this.relation, this.attributesList, this.data);

  @override
  String toString() {
    return 'ARFF{relation: $relation, attributesList: $attributesList, data: $data}';
  }

  /// Gets the output layer neurons based on the provided class attribute [className].
  ///
  /// This method searches for the attribute with the name [className] in the
  /// [attributesList]. If the attribute type is 'nominal', it creates a [Neuron]
  /// for each nominal value. If the attribute type is 'numeric', it creates a single
  /// [Neuron] with the attribute name. Throws [OutputLayerNameError] if the attribute
  /// is not found.
  ///
  /// - Parameters:
  ///   - className: The name of the class attribute for which output neurons are needed.
  ///
  /// - Returns: A list of [Neuron]s representing the output layer.
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

  /// Gets the input layer neurons by excluding the provided class attribute [className].
  ///
  /// This method removes the attribute with the name [className] from the [attributesList]
  /// and creates a [Neuron] for each remaining attribute. If the attribute type is 'nominal',
  /// it creates a neuron for each nominal value. Otherwise, it creates a neuron with the
  /// attribute name. Throws [OutputLayerNameError] if an error occurs.
  ///
  /// - Parameters:
  ///   - className: The name of the class attribute to exclude.
  ///
  /// - Returns: A list of [Neuron]s representing the input layer.
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
