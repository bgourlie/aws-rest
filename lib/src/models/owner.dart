part of aws_rest;

class Owner {
  final String id;
  final String displayName;

  Owner(this.id, this.displayName);

  factory Owner.fromXmlElement(xml.XmlElement ownerElem) {
    final idElem = ownerElem.findElements('ID').first;
    final displayNameElem = ownerElem.findElements('DisplayName').first;
    return new Owner(idElem.text, ownerElem.text);
  }
}