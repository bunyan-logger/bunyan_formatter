# BunyanFormatter

You probably want:

* documentation on [using the Bunyan
  Logger](https://github.com/bunyan-logger/bunyan_docs/blob/master/README.md
)

* notes on [writing plugins](https://github.com/bunyan-logger/bunyan_docs/blob/master/plugins.md
) for the Bunyan logger

* stories about a [lumberjack](http://www.americanfolklore.net/.search?results_page=my_results.html&query=paul+bunyan&name=Search).


## Summary

This is a library component with a single external function:
`Bunyan.Formatter.compile_format`. If takes a format specification and
returns an anonymous function that will render a log message using that
specification.

This formatter is included by default if you include
`Bunyan.Writer.Device` in your application. It is also potentially
useful in other writer plugins, which is why it's in its own module.
