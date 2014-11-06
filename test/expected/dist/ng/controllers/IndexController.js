"use strict";
define([config.appName], function(app) {
  app.register.controller("IndexController", [
    "$scope", "$http", "$location", "$stateParams", "cfpLoadingBar", "$rootScope", "pochta", function($scope, $http, $location, $stateParams, cfploadingBar, $rootScope, pochta) {
      $scope.statusId = $stateParams.statusId || '';
      $scope.submit = function() {
        $rootScope.error = '';
        if (!$rootScope.loading) {
          $rootScope.loading = true;
          if ($scope.statusId.match(/[A-Za-z0-9]{10,20}/gi)) {
            $location.path('status/' + $scope.statusId);
            return pochta.get($scope.statusId).success(function(data) {
              $rootScope.status = data;
              return $rootScope.loading = false;
            }).error(function(data) {
              $rootScope.status = '';
              $rootScope.loading = false;
              return $rootScope.error = 'Пчта ответила: "' + data.message + '"';
            });
          } else {
            $scope.error = 'Неправильный формат трекинг номера';
            $rootScope.status = '';
            return $rootScope.loading = false;
          }
        }
      };
      if ($scope.statusId) {
        return $scope.submit();
      }
    }
  ]);
});

//# sourceMappingURL=IndexController.js.map
