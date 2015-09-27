## What's Lutachu
Lutachu is a front-end framework based on [Stylus](https://github.com/stylus/stylus). It makes website building easier.

## Download
Before building, you need to execute `npm intall` to install dependencies.

### Source Code
Lutachu uses [gulp.js](http://gulpjs.com/) for building.
```
git clone https://github.com/lingoys/Lutachu.git
```

## Build
### Stylus Version
```
gulp
```

### Sass Version
```
gulp sass
```

You only need one command to build.

## What's included
```
Lutachu
|-- docs
|   `-- getting-started.md
|-- fonts
|   |-- foundation-icons.eot
|   |-- foundation-icons.svg
|   |-- foundation-icons.ttf
|   `-- foundation-icons.woff
|-- sass
|   |-- base
|   |   |-- foundation.scss
|   |   |-- normalize.scss
|   |   `-- print.scss
|   |-- components
|   |   |-- acommet.scss
|   |   |-- card.scss
|   |   |-- msg.scss
|   |   |-- nav.scss
|   |   `-- poem.scss
|   |-- elements
|   |   |-- button.scss
|   |   |-- code.scss
|   |   |-- form.scss
|   |   `-- table.scss
|   |-- layout
|   |   |-- grid.scss
|   |   `-- typography.scss
|   |-- lutachu.scss
|   |-- mixins.scss
|   |-- utillyties.scss
|   `-- variables.scss
|-- src
|   |-- base
|   |   |-- foundation.styl
|   |   |-- normalize.styl
|   |   `-- print.styl
|   |-- components
|   |   |-- acommet.styl
|   |   |-- card.styl
|   |   |-- msg.styl
|   |   |-- nav.styl
|   |   `-- poem.styl
|   |-- elements
|   |   |-- button.styl
|   |   |-- code.styl
|   |   |-- form.styl
|   |   `-- table.styl
|   |-- layout
|   |   |-- grid.styl
|   |   `-- typography.styl
|   |-- lutachu.styl
|   |-- mixins.styl
|   |-- utillyties.styl
|   `-- variables.styl
```

## Create a simple page
Copy the HTML below to begin working with Lutachu.
```
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
  <title>Hello, Lutachu</title>
  <meta name="description" content="">
  <meta name="keywords" content="">
  
  <meta name="renderer" content="webkit">
  
  <link rel="stylesheet" href="assets/css/lutachu.min.css">
</head>
<body>
  <h1>Hello, Lutachu</h1>
  <p>You're already using Lutachu</p>
</body>
</html>
```

## Bugs and feature reporting
Search for existing and closed issues, if it's not addressed yet, [open a new issue](https://github.com/lingoys/lutachu/issues/new).

## License
This software is free to use under [the MIT License](https://github.com/lingoys/Lutachu/blob/master/LICENSE.md).

The documentation is free to use under [Attribution 3.0 Unported (CC BY 3.0)](http://creativecommons.org/licenses/by/3.0/).

Enjoy!