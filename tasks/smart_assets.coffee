#
# * grunt-smart-assets
# * 
# *
# * Copyright (c) 2014 Shapovalov Alexandr
# * Licensed under the MIT license.
# 
"use strict"

module.exports = (grunt) ->

	path = require('path')
	_ = require('lodash');

	run_task = (task, config) ->
		default_config = grunt.config.get('task') || {};
		default_config['smart_assets'] = config
		grunt.config.set(task, default_config);
		grunt.task.run(task + ':smart_assets');

	# Please see the Grunt documentation for more information regarding task
	# creation: http://gruntjs.com/creating-tasks
	grunt.registerMultiTask "smart_assets", ->

		# Merge task-specific and/or target-specific options with these defaults.
		options = @options(
			cwd: 'test-app/app'
			dest: 'test-app/dist'
			cleanDist: true

			#register extensions
			ext:
				coffee:
					from: ['.coffee']
					to: '.js'
				sass:
					from: ['.sass', '.scss']
					to: ['.css']
			#custom options for tasks
			tasks:
				coffee: {
					options:
						sourceMap: true,
						bare: true
				}
		)

		if !options.cwd? or !options.dest? or !options.ext?
			grunt.log.warn "Your config is wrong!"
			return false

		#clean dist before other tasks run
		if options.cleanDist
			run_task 'clean', options.dest

		grunt.registerTask "smart_assets_run", ->
			files = {}
			grunt.file.expand({cwd: options.cwd, filter: 'isFile'}, '**/*').forEach (file)->

				ext = path.extname file;
				find = -1;
				_.forEach options.ext, (values,key)->
					find = key unless _.indexOf(values.from, ext) is -1

				unless find is -1
					files[find] = new Array() unless _.isArray files[find]
					files[find].push file
				else
					files['copy'] = new Array() unless _.isArray files[find]
					files['copy'].push file

			_.forEach files, (val, task) ->
				options.tasks[task] = {} unless _.isObject options.tasks[task]

				src = {};
				_.forEach val, (file) ->
					src[options.dest + '/' + file + (if options.ext[task]?.to? then options.ext[task].to else '')] = options.cwd + '/' + file

				options.tasks[task]['files'] = src
				run_task task, options.tasks[task]



		grunt.task.run(['smart_assets_run']);

		# Iterate over all specified file groups.
#		@files.forEach (file) ->
			# Concat specified files.
#			console.lg(file);
			# Warn on and remove invalid source files (if nonull was set).

			# Read file source.
#			src = file.src.filter((filepath) ->
#				unless grunt.file.exists(filepath)
#					grunt.log.warn "Source file \"" + filepath + "\" not found."
#					false
#				else
#					true
#			).map((filepath) ->
#				grunt.file.read filepath
#			).join(grunt.util.normalizelf(options.separator))
#
#			# Handle options.
#			src += options.punctuation
#
#			# Write the destination file.
#			grunt.file.write file.dest, src
#
#			# Print a success message.
#			grunt.log.writeln "File \"" + file.dest + "\" created."
#			return
