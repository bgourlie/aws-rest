part of aws_rest;

class Content {
  final String key;
  final DateTime lastModified;
  final String etag;
  final int size;
  final Owner owner;
  final String storageClass;

  Content(this.key, this.lastModified, this.etag, this.size, this.owner, this.storageClass);

  factory Content.fromXmlElement(xml.XmlElement contentElem){
    final keyElem = contentElem.findElements('Key').first;
    final lastModifiedElem = contentElem.findElements('LastModified').first;
    final etagElem = contentElem.findElements('ETag').first;
    final sizeElem = contentElem.findElements('Size').first;
    final ownerElem = contentElem.findElements('Owner').first;
    final storageClassElem = contentElem.findElements('StorageClass').first;
    final owner = new Owner.fromXmlElement(ownerElem);
    final lastModified = DateTime.parse(lastModifiedElem.text);
    final size = int.parse(sizeElem.text);
    return new Content(keyElem.text, lastModified, etagElem.text, size, owner, storageClassElem.text);
  }
}