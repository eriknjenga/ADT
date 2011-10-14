To view export component demos, please make sure of following:

When running client-side/batch/JavaScript export examples:
==========================================================
Make sure you've copied pasted the files (including ../FusionCharts folder)
to your localhost (or any remove server). Since JavaScript is used for these
examples, they would not run on your local file system (as Adobe Flash Player
blocks Flash-JavaScript communication on local file system, unless otherwise
configured). If you do not take this step, the examples will fail silently.

When running server-side export examples
==========================================================
1. Make sure you've copied the pertinent server-side handler to your server.
2. Make sure that your server has necessary pre-requisites to execute that handler.
   See documentation for details on this.
3. Make sure to update each example's XML to reflect the new path of server-side export
   handler.