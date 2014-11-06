'use strict';
define([], function() {
  var services;
  services = angular.module('routeResolverServices', []);
  return services.provider('routeResolver', function() {
    this.$get = function() {
      return this;
    };
    this.routeConfig = (function() {
      var controllersDirectory, getControllersDirectory, getViewsDirectory, setBaseDirectories, viewsDirectory;
      viewsDirectory = config.path.view;
      controllersDirectory = config.path.controller;
      setBaseDirectories = function(viewsDir, controllersDir) {
        viewsDirectory = viewsDir;
        return controllersDirectory = controllersDir;
      };
      getViewsDirectory = function() {
        return viewsDirectory;
      };
      getControllersDirectory = function() {
        return controllersDirectory;
      };
      return {
        setBaseDirectories: setBaseDirectories,
        getControllersDirectory: getControllersDirectory,
        getViewsDirectory: getViewsDirectory
      };
    })();
    this.route = (function(routeConfig) {
      var resolve, resolveDependencies;
      resolve = function(params) {
        var controllers, routeDef;
        if (!params.view) {
          params.view = "";
        }
        controllers = [];
        routeDef = {};
        routeDef.url = params.url;
        if (!'') {
          if (params.view) {
            routeDef.templateUrl = routeConfig.getViewsDirectory() + params.view + config.ext.view;
          }
        }
        if (params.parent != null) {
          routeDef.parent = params.parent;
        }
        if (params.abstract != null) {
          routeDef.abstract = params.abstract;
        }
        if (params.data != null) {
          routeDef.data = params.data;
        }
        if (params.views != null) {
          angular.forEach(params.views, function(stateparams, state) {
            return angular.forEach(stateparams, function(value, key) {
              if (key === 'view') {
                params.views[state].templateUrl = routeConfig.getViewsDirectory() + value + config.ext.view;
                delete params.views[state].view;
              }
              if (key === 'controller') {
                params.views[state].controller = value + config.controllerOutfix;
                return controllers.push(routeConfig.getControllersDirectory() + value + config.controllerOutfix + config.ext.controller);
              }
            });
          });
          routeDef.views = params.views;
        }
        if (params.controller != null) {
          routeDef.controller = params.controller + config.controllerOutfix;
          controllers.push(routeConfig.getControllersDirectory() + routeDef.controller + config.ext.controller);
        }
        if ((params.controller != null) || (controllers != null)) {
          routeDef.resolve = {
            load: [
              '$q', '$rootScope', function($q, $rootScope) {
                var dependencies;
                dependencies = controllers;
                return resolveDependencies($q, $rootScope, dependencies);
              }
            ]
          };
        }
        return routeDef;
      };
      resolveDependencies = function($q, $rootScope, dependencies) {
        var defer;
        defer = $q.defer();
        require(dependencies, function() {
          defer.resolve();
          return $rootScope.$apply();
        });
        return defer.promise;
      };
      return {
        resolve: resolve,
        location: location
      };
    })(this.routeConfig);
  });
});

//# sourceMappingURL=routeResolver.js.map
