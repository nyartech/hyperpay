// Setup using your own endpoints.
// https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server.

String _host = 'YOUR_HOST';

Uri checkoutEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '',
);

Uri statusEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '',
);
