addStorage(String url) {
  return 'https://storage-halls.s3-us-west-2.amazonaws.com/' + url;
}

addEndpoint(String url) {
  return 'http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/' +
      url;
}
