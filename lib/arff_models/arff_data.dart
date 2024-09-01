/// Represents a data entry in an ARFF (Attribute-Relation File Format) file.
///
/// This class stores a single data entry consisting of a name-value pair
/// associated with an attribute in the ARFF file.
class ARFFData {
  /// The name of the attribute for this data entry.
  final String name;

  /// The value of the attribute for this data entry.
  final String value;

  /// Creates an ARFF data entry with the given [name] and [value].
  ///
  /// Both [name] and [value] are required to represent a valid data entry
  /// in the ARFF file.
  ARFFData({required this.name, required this.value});
}
