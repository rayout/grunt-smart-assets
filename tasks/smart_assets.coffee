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

	patterns = [
		[/<script.+src=['"]([^"']+)["']/gim]
		[/<link[^\>]+href=['"]([^"']+)["']/gim]
		[/<img[^\>]*[^\>\S]+src=['"]([^"']+)["']/gim]
		[/<image[^\>]*[^\>\S]+xlink:href=['"]([^"']+)["']/gim]
		[/<image[^\>]*[^\>\S]+src=['"]([^"']+)["']/gim]
		[/<(?:img|source)[^\>]*[^\>\S]+srcset=['"]([^"'\s]+)(?:\s\d[mx])["']/gim]
		[/<source[^\>]+src=['"]([^"']+)["']/gim]
		[/<a[^\>]+href=['"]([^"']+)["']/gim]
		[/<input[^\>]+src=['"]([^"']+)["']/gim]
		[/data-(?!main).[^=]+=['"]([^'"]+)['"]/gim]
		[
			[/data-main\s*=['"]([^"']+)['"]/gim]
			(m) ->
				if m.match(/\.js$/)
					return m
				else
					return m + '.js'

			(m) ->
				return m.replace('.js', '')
		]
		[/<object[^\>]+data=['"]([^"']+)["']/gim]
	]
	# Please see the Grunt documentation for more information regarding task
	# creation: http://gruntjs.com/creating-tasks
	grunt.registerMultiTask "smart_assets", ->

		# Merge task-specific and/or target-specific options with these defaults.
		options = @options(
			files:
				cwd: 'test-app/app'
				dest: 'test-app/dist'
				cleanDist: true
			html:
				cwd: 'test-app/html'
				dest: 'test-app/html-dest'
				src: '*.html'
				assetDir: 'test-app'


			#register extensions
			ext:
				coffee:
					from: ['.coffee']
					to: '.js'
				sass:
					from: ['.sass', '.scss']
					to: '.css'
			#custom options for tasks
			tasks:
				coffee: {
					options:
						sourceMap: true,
						bare: true
				}
		)

		if !options.files.cwd? or !options.files.dest? or !options.ext? or !options.html?
			grunt.log.warn "Your config is wrong!"
			return false

		#clean dist before other tasks run
		if options.files.cleanDist
			run_task 'clean', options.files.dest

		grunt.registerTask "smart_assets_files", ->
			files = {}
			grunt.file.expand({cwd: options.files.cwd, filter: 'isFile'}, '**/*').forEach (file)->

				ext = path.extname file;
				find = -1;
				_.forEach options.ext, (values,key)->
					find = key unless _.indexOf(values.from, ext) is -1

				unless find is -1
					files[find] = new Array() unless _.isArray files[find]
					files[find].push file
				else
					files['copy'] = new Array() unless _.isArray files['copy']
					files['copy'].push file

			_.forEach files, (val, task) ->
				options.tasks[task] = {} unless _.isObject options.tasks[task]

				src = {};
				_.forEach val, (file) ->
					src[path.join(options.files.dest , file) + (if options.ext[task]?.to? then options.ext[task].to else '')] = path.join( options.files.cwd , file)

				options.tasks[task]['files'] = src
				run_task task, options.tasks[task]

		grunt.registerTask "smart_assets_html", ->
			grunt.file.expand({cwd: options.html.cwd, filter: 'isFile'}, options.html.src).forEach (file_name)->
				content = grunt.file.read path.join(options.html.cwd, file_name)
				patterns.forEach (pattern) ->

					patrn = if pattern[0]?[0]? then  pattern[0][0] else pattern[0]
					match =  content.match patrn

					if match != null
						match.forEach (result) ->
							result.match pattern[0]

							file = RegExp.$1
							file_ext = path.extname(file) #берем расширение файла
							#ищем результирующее
							result_ext = if options.ext[file_ext.split('.').pop()]?.to? then options.ext[file_ext.split('.').pop()].to else ''
							result_file = file + result_ext

							re = new RegExp(options.html.assetDir, 'gi')


							if pattern[1]? then result_file = pattern[1](result_file)
							result_file_path = path.join(options.html.assetDir, result_file).replace(options.files.cwd, options.files.dest)
							result_file = path.join(options.html.assetDir, result_file).replace(options.files.cwd, options.files.dest).replace(options.html.assetDir, '')

							if grunt.file.exists(result_file_path)
								if pattern[2]? then result_file = pattern[2](result_file)
								content = content.replace file, result_file

				#console.log path.join(options.html.dest, file_name)
				grunt.file.write path.join(options.html.dest, file_name), content

		grunt.task.run(['smart_assets_files', 'smart_assets_html']);



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
