'use strict';
define([], function() {
  var services;
  services = angular.module('pochtaServices', []);
  return services.factory('pochta', function($http) {
    return {
      get: function(id) {
        return $http.get('/statuses/' + id + '.json');
      }
    };
  });
});

//# sourceMappingURL=pochta.js.map
