# Shopping Cart

A simple drag 'n drop shopping cart for iOS.

Created for a stackoverflow question, this one:
http://stackoverflow.com/questions/3960960/drag-an-uiimageview-from-uiscrollview-to-another-view

![SS Screenshot](http://i.stack.imgur.com/I0ekn.png "SS")


iOS 5.0+. ARC.

![A Screenshot](https://raw.github.com/elpsk/Shopping-Cart/master/A.png "A")
![B Screenshot](https://raw.github.com/elpsk/Shopping-Cart/master/B.png "B")
![C Screenshot](https://raw.github.com/elpsk/Shopping-Cart/master/C.png "A")
![D Screenshot](https://raw.github.com/elpsk/Shopping-Cart/master/D.png "B")

More example on www.albertopasca.it/whiletrue


## How to use

```
	APChartObject appleObject = [[APChartObject alloc] initWithFrame:CGRectMake(0, 0, 80, 80) target:self selector:@selector(panDetected:)];
	appleObject.image		 = [UIImage imageNamed:@"apple"];
	appleObject.text		 = @"apple";
	appleObject.price		 = 1.30;
	appleObject.quantity = 3;

	[ _scrollview addSubview:appleObject.imageView ];   
```

## TODO
Everithing!
You can set quantity, add, remove objects, etc...
Nothing implemented seriously.


## Copyrigth

(c)2012 Alberto Pasca - albertopasca.it.

## License

Have fun.

