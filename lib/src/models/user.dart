part of aws_rest;

class User {
  final String id;
  final String displayName;

  User(this.id, this.displayName);

  factory User.fromElement(xml.XmlElement ownerElem) {
    final idElem = ownerElem.findElements('ID').first;
    final displayNameElem = ownerElem.findElements('DisplayName').first;
    return new User(idElem.text, ownerElem.text);
  }
}
