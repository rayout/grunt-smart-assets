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

	#require('time-grunt')(grunt)

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
						cwd: 'test/test-app/app'
						dest: 'test/test-app/dist'
						cleanDest: true
					html:
						cwd: 'test/test-app/html'
						dest: 'test/test-app/html-dest'
						src: '*.html'
						assetDir: 'test/test-app'
						rev: true
					tasks:
						coffee:
							from: ['.coffee']
							to: '.js'
							options:
								sourceMap: true,
								bare: true
						sass:
							from: ['.sass', '.scss']
							to: '.css'




	# Unit tests.
		nodeunit:
			tests: ["test/*_test.coffee"]


	# Actually load this plugin's task(s).
	grunt.loadTasks "tasks"

	# Whenever the "test" task is run, first clean the "tmp" dir, then run this
	# plugin's task(s), then test the result.
	grunt.registerTask "test", [
		"smart_assets"
		"nodeunit"
	]

	# By default, lint and run all tests.
	grunt.registerTask "default", [
		"jshint"
		"test"
	]
	return
