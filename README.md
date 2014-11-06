# grunt-smart-assets

>  if necessary, converts all files within the directory, and the remaining copies.. Then, change path in html files to new converted and copied files
>  Supports all plug-ins which you can specify the SRC and DEST

## Getting Started
This plugin requires Grunt.

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-smart-assets --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-smart-assets');
```

## The "smart_assets" task

### Overview
In your project's Gruntfile, add a section named `smart_assets` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  smart_assets: {
    compile:{
      options: {
        files: {
            cwd: 'test-app/app',
	        dest: 'test-app/dist',
	        cleanDist: true,
	        src: '**/*' //available by default
        },
        html:{
            cwd: 'test-app/html',
            dest: 'test-app/html-dest',
            src: '*.html',
            assetDir: 'test-app'
        }
        //if need transformation
        tasks:
            coffee: {
                from: ['.coffee']
                to: '.js'
                options: {
                    sourceMap: true,
                    bare: true
                }    
            }
            sass: {
                from: ['.sass', '.scss']
                to: '.css'
            }
      }
    }
})
```

### Options

#### options.files.cleanDist
Type: `Bool`
Default value: `true`

Clean dist foldr before convert`

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_

## License
Copyright (c) 2014 Shapovalov Alexandr. Licensed under the MIT license.
