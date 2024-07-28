class ARFFAttributes {
  final String name;
  final String type;
  final List<String>? nominalValues;

  ARFFAttributes(this.name, this.type, [this.nominalValues]);

  @override
  String toString() {
    return 'ARFFAttributes{name: $name, type: $type, nominalValues: $nominalValues}';
  }
}