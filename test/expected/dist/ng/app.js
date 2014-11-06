"use strict";
define(["services/routeResolver"], function() {
  var app;
  app = angular.module(config.appName, ["ngRoute", "ngAnimate", "routeResolverServices", "pochtaServices", "ui.router", "angular-loading-bar"]);
  app.config([
    "$stateProvider", "$urlRouterProvider", "$locationProvider", "$routeProvider", "routeResolverProvider", "$controllerProvider", "$compileProvider", "$filterProvider", "$provide", "$httpProvider", function($stateProvider, $urlRouterProvider, $locationProvider, $routeProvider, routeResolverProvider, $controllerProvider, $compileProvider, $filterProvider, $provide, $httpProvider) {
      var error, route;
      app.register = {
        controller: $controllerProvider.register,
        directive: $compileProvider.directive,
        filter: $filterProvider.register,
        factory: $provide.factory,
        service: $provide.service
      };
      route = routeResolverProvider.route;
      $locationProvider.html5Mode(true);
      $provide.decorator("$exceptionHandler", function($delegate) {
        return function(exception, cause) {
          alert(exception.message);
          return $delegate(exception, cause);
        };
      });
      try {
        angular.forEach(routes, function(value, key) {
          if (value.error === undefined) {
            return $stateProvider.state(key, route.resolve(value));
          } else {
            $stateProvider.state(key, route.resolve(value));
            return $urlRouterProvider.otherwise(value.url);
          }
        });
        return $urlRouterProvider.rule(function($injector, $location) {
          var normalized, path;
          path = $location.path();
          normalized = path.toLowerCase();
          if (path !== normalized) {
            return $location.replace().path(normalized);
          }
        });
      } catch (_error) {
        error = _error;
        return console.log(error);
      }
    }
  ]);
  return app;
});

//# sourceMappingURL=app.js.map
