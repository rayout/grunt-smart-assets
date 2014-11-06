"use strict";
define([config.appName], function(app) {
  app.register.controller("StatusController", [
    "$scope", "$http", "$stateParams", function($scope, $http, $stateParams) {
      return $scope.title = "Document " + ("" + $stateParams.id);
    }
  ]);
});

//# sourceMappingURL=StatusController.js.map
