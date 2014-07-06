part of aws_rest;

class DeleteRequest {
  final List<S3Object> _objects;

  DeleteRequest(this._objects);

  String toString(){
    final builder = new xml.XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('Delete', nest: () {
      builder.element('Quiet', nest: () => builder.text('true'));
      this._objects.forEach((obj) {
        builder.element('Object', nest: () {
          builder.element('Key', nest: obj.key);
        });
      });
    });

    return builder.build().toXmlString();
  }
}
