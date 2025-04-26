enum ApiHeader {
  contentType('Content-Type'),
  stackAccessType('X-Stack-Access-Type'),
  stackProjectId('X-Stack-Project-Id'),
  stackClientKey('X-Stack-Publishable-Client-Key');

  final String value;
  const ApiHeader(this.value);
}
