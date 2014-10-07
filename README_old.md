# X3dom-Fiddle Prototype
* based ony MEAN-CS template [MongoDB, ExpressJS, AngularJS, NodeJS - CoffeeScript, SASS]

Start an app with AngularJS on the client, Express + Node + Socket.IO as your back-end, all written in CoffeeScript.

Supports SASS for styling and Bower for front end package manager.

This version includes the following components:

* AngularJS 
* Express 
* Socket.IO 
* Jade 
* UglifyJS 
* Node-Sass
* Mongoose

## Installation

You need to have installed node (http://nodejs.org/), CoffeeScript (http://coffeescript.org/), make sure
you install CoffeeScript globally. You also need BOWER (http://bower.io/).

## Configuration

There's no configuration for using Angular Espresso, all you need to do is download the project, install its
dependencies with npm and run your node app.

Your .coffee files should be under the "app" folder. The project structure is the following:

NOTE: Each directory has a README file with more detail

* Angular: Your AngularJS app should go in this directory
* Services: Backend logic goes here
* Config: Configuration that may be used to set up different values for a specific environment or a common config
* Routes: This directory should contain the routing functions for your views. Define an entry point for a major
component of your site and then use partials for all its sub-components
* Resources: Any client scripts not related to AngularJS

At the root folder, there are two more folders to consider:

* Styles: Include all into ./styles directory and it will be compiled upon node server start. 
* Views: Your views/partial views should go here

## References

For more on AngularJS: http://angularjs.org
For more on CoffeeScript: http://coffeescript.org
For more on Express: http://expressjs.com
For more on Jade: http://jade-lang.com
For more on Socket.IO: http://socket.io/
For more on Bower: http://bower.io/
For more on SASS: http://sass-lang.com/
