"use strict"
define ["services/routeResolver"], ->
	app = angular.module(config.appName, [
		"ngRoute"
		"ngAnimate"
		"routeResolverServices"
		"ui.router"
	])
	app.config ["$stateProvider", "$urlRouterProvider","$locationProvider", "$routeProvider", "routeResolverProvider", "$controllerProvider", "$compileProvider", "$filterProvider", "$provide", "$httpProvider"
		($stateProvider, $urlRouterProvider,$locationProvider, $routeProvider, routeResolverProvider, $controllerProvider, $compileProvider, $filterProvider, $provide, $httpProvider) ->
			app.register =
				controller: $controllerProvider.register
				directive: $compileProvider.directive
				filter: $filterProvider.register
				factory: $provide.factory
				service: $provide.service

			route = routeResolverProvider.route

			$locationProvider.html5Mode true

			#exception handler
			$provide.decorator "$exceptionHandler", ($delegate) ->
				return (exception, cause) ->
					alert exception.message
					$delegate exception, cause

			try
				#автоматический роутинг
				angular.forEach routes, (value, key) ->
					if value.error is `undefined`
						$stateProvider.state key, route.resolve(value)
					else
						#go to php router
						#$urlRouterProvider.otherwise ($injector, $location) ->
						#	window.location.href = $location.path()

						#throw error (404?)
						$stateProvider.state key, route.resolve(value)
						$urlRouterProvider.otherwise value.url




				#штуковина для регистронезависимости урлов
				$urlRouterProvider.rule ($injector, $location) ->
					path = $location.path()
					normalized = path.toLowerCase()
					$location.replace().path normalized  unless path is normalized

			catch error
				console.log error;




	]
	return app
