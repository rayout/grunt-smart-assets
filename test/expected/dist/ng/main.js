require.config({
  baseUrl: "/assets-dist/ng/",
  urlArgs: "bust=" + (new Date()).getTime()
});

require(["conf/config", "conf/routes", "app", "services/routeResolver", "services/pochta"], function() {
  angular.bootstrap(document, [config.appName]);
});

//# sourceMappingURL=main.js.map
