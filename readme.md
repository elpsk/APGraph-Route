iOS Dijkstra [![Build Status](https://raw.github.com/elpsk/APGraph-Route/master/passing.png)](https://raw.github.com/elpsk/APGraph-Route/master/passing.png)
------------

A simple iOS Dijkstra algorithm implementation applied on the Milan ATM Metro.

Screenshot
------------
![SS Screenshot](https://raw.github.com/elpsk/APGraph-Route/master/sshot.png "SS")


Requirements
------------
`ARC`, `iOS 6+`, `Xcode 4+`


Workspace
------------
- Metro Full iPad app
- APGraphLib ( target )
- APGraph-lib-test ( target test )
- Test Case


How to use
------------

Copy in your project the files:

```
APGraph.h
APGraphVertex.h
APGraphEdge.h
APGraphRoute.h
APGraphRouteStep.h
APGraphPoint.h
APGraphPointGeo.h
APGraphPointPixel.h

libAPGraph.a
```

and add an import for:

`#import "APGraphLib.h"`

Next, make a graph, adding vertex, edges and point (Geo or Pixel), like in the TestCase.



Todo
------------
A lot of customization. It's only an example.


Copyrigth
------------

(c)2013 Alberto Pasca - albertopasca.it.


MIT License
------------

The MIT License (MIT)

(c)2013 Alberto Pasca

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

