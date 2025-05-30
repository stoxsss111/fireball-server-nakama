const InitModule = function(ctx, logger, nk, initializer) {
    initializer.registerRpcBeforeHook(function(ctx, logger, nk, rpcInfo) {
      logger.info('Received RPC call: %s', rpcInfo.id);
    });
  
    initializer.registerHttpHandler("/test", function(context, request) {
      return {
        status: 200,
        headers: {
          "Content-Type": ["text/html"]
        },
        body: `
          <!DOCTYPE html>
          <html>
          <head>
              <title>Nakama Test</title>
          </head>
          <body>
              <h1>Nakama HTTP Test</h1>
              <p>This page is served by a Nakama runtime HTTP handler.</p>
              <p>Try accessing the admin console at: <a href="/console/">/console/</a></p>
          </body>
          </html>
        `
      };
    });
  
    logger.info('Module loaded successfully');
    return {
      // no methods to register
    };
  };
  
  // Register the module
  var module = {
    name: "testmodule",
    version: "1.0.0",
    init: InitModule
  };
  module.exports = module;