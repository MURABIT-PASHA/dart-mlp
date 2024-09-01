/// Represents an attribute in an ARFF (Attribute-Relation File Format) file.
///
/// This class stores information about a specific attribute, including its name,
/// type, and, if applicable, its nominal values.
class ARFFAttributes {
  /// The name of the attribute.
  final String name;

  /// The type of the attribute (e.g., 'numeric', 'nominal').
  final String type;

  /// A list of nominal values if the attribute type is 'nominal'.
  ///
  /// If the attribute type is not 'nominal', this will be `null`.
  final List<String>? nominalValues;

  /// Creates an ARFF attribute with the given [name], [type], and optional [nominalValues].
  ///
  /// The [type] should be either 'numeric' or 'nominal'. If the [type] is 'nominal',
  /// a list of nominal values can be provided.
  ARFFAttributes(this.name, this.type, [this.nominalValues]);

  @override
  String toString() {
    return 'ARFFAttributes{name: $name, type: $type, nominalValues: $nominalValues}';
  }
}
