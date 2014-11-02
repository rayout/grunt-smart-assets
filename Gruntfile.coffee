#
# * grunt-smart-assets
# *
# *
# * Copyright (c) 2014 Shapovalov Alexandr
# * Licensed under the MIT license.
#
"use strict"
module.exports = (grunt) ->

	# load all npm grunt tasks
	require("load-grunt-tasks") grunt

	# Project configuration.
	grunt.initConfig
		jshint:
			all: [
				"Gruntfile.js"
				"tasks/*.js"
				"<%= nodeunit.tests %>"
			]
			options:
				jshintrc: ".jshintrc"
				reporter: require("jshint-stylish")


	# Before generating any new files, remove any previously-created files.
		clean:
			tests: ["tmp"]


	# Configuration to be run (and then tested).
		smart_assets:
			compile:
				options:
					files:
						cwd: 'test-app/app'
						dest: 'test-app/dist'
						cleanDist: true
					html:
						cwd: 'test-app/html'
						dest: 'test-app/html-dest'
						src: '*.php'
						assetDir: 'test-app'


	# Unit tests.
		nodeunit:
			tests: ["test/*_test.js"]


	# Actually load this plugin's task(s).
	grunt.loadTasks "tasks"

	# Whenever the "test" task is run, first clean the "tmp" dir, then run this
	# plugin's task(s), then test the result.
	grunt.registerTask "test", [
		"clean"
		"smart_assets"
		"nodeunit"
	]

	# By default, lint and run all tests.
	grunt.registerTask "default", [
		"jshint"
		"test"
	]
	return
