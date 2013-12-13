 //
//  APViewController.m
//
// Created by Alberto Pasca on 08/11/13.
// Copyright (c) 2013 albertopasca.it
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import "APViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
//
// graph
//
#import "APGraph.h"
#import "APGraphVertex.h"
#import "APGraphEdge.h"
#import "APGraphRoute.h"
#import "APGraphRouteStep.h"
#import "APGraphPoint.h"
#import "APGraphPointGeo.h"
#import "APGraphPointPixel.h"


// +---------------------------------------------------------------------------+
//	APPassThroughUIView
// +---------------------------------------------------------------------------+

@interface APPassThroughUIView : UIView
@end
@implementation APPassThroughUIView
- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	for  (UIView *v in self.subviews) {
		CGPoint localPoint = [v convertPoint:point fromView:self];
		if ( v.alpha > 0.01 && ![v isHidden] && v.userInteractionEnabled && [v pointInside:localPoint withEvent:event] )
			return YES;
	}
	return NO;
}
@end


@interface APViewController ()
@end


@implementation APViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	_fromPicker.delegate = self;
	_toPicker.delegate	 = self;
}


// +---------------------------------------------------------------------------+
#pragma mark - Layout drawing
// +---------------------------------------------------------------------------+


- (void) drawPath:(NSArray*)data
{
  NSAssert( data, @"KO - No valid data." );

  APGraphRoute	*route          = data[0];
  APGraph				*graph          = data[1];
  APGraphVertex *vertex         = data[2];


  UIBezierPath *path            = [[ UIBezierPath alloc ] init ];
  BOOL skip                     = NO;

	for ( APGraphRouteStep *step in route.steps )
	{
		APGraphPointPixel *pixel = (APGraphPointPixel*)step.vertex.point;
		CGPoint stepPosition = CGPointZero;
		
		if ( step.isLast )
		{
			APGraphPointPixel *px = (APGraphPointPixel*)((APGraphVertex*)[graph.vertices valueForKey:vertex.point.identifier]).point;
			stepPosition = px.position;
		}
		else stepPosition = pixel.position;
		
		if ( !skip ) {
			[ path moveToPoint: stepPosition ];
			skip = !skip;
		}
		else [ path addLineToPoint: stepPosition ];
	}
	
	[[ self.view viewWithTag:999] removeFromSuperview];


  CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] initWithLayer:self.view.layer];
  shapeLayer.frame         = self.view.bounds;
  shapeLayer.lineWidth     = 7.0;
  shapeLayer.strokeColor   = [UIColor purpleColor].CGColor;
  shapeLayer.borderColor   = [UIColor blackColor].CGColor;
  shapeLayer.borderWidth   = 2;
  shapeLayer.fillColor     = [UIColor clearColor].CGColor;
  shapeLayer.path          = path.CGPath;

  APPassThroughUIView *v   = [[APPassThroughUIView alloc] initWithFrame:shapeLayer.frame];
  v.tag                    = 999;
  v.clipsToBounds          = YES;
	[ v.layer addSublayer:shapeLayer ];

	[self.view addSubview:v];
}


// +---------------------------------------------------------------------------+
#pragma mark - Dijistra
// +---------------------------------------------------------------------------+


- (void) getPath:(NSString*)from to:(NSString*)to
{
  NSAssert( from || to, @"KO - No valid data." );

	APGraph *graph = [[APGraph alloc] init];
	
	NSDictionary *jDict = [ self loadJson ];
	
	int tot = (int)[[jDict valueForKey:@"fermate"] count];
  NSAssert( tot > 0, @"KO - No valid json content." );

	for ( int i=0; i<tot; i++ )
	{
    NSDictionary *stop  = [jDict valueForKey:@"fermate"][i];
    NSString *sId       = [ stop valueForKey:@"id" ];
    NSString *links     = [ stop valueForKey:@"links"];
    NSArray *linksArray = [ links componentsSeparatedByString:@"," ];

		for ( NSString* lnk in linksArray )
		{
      NSString		*currName       = [[[ jDict valueForKey:@"fermate"] objectAtIndex:[sId intValue] ] valueForKey:@"name"];
      NSString		*linkedName     = [[[ jDict valueForKey:@"fermate"] objectAtIndex:[lnk intValue] ] valueForKey:@"name"];

      int xCurr                   = [[[[[[ jDict valueForKey:@"fermate"] objectAtIndex:[sId intValue] ]
                valueForKey:@"position"] valueForKey:@"x"] objectAtIndex:0] intValue];
      int yCurr                   = [[[[[[ jDict valueForKey:@"fermate"] objectAtIndex:[sId intValue] ]
                valueForKey:@"position"] valueForKey:@"y"] objectAtIndex:0] intValue];
      CGPoint posCurrent          = CGPointMake(xCurr, yCurr);

      int xLnk                    = [[[[[[ jDict valueForKey:@"fermate"] objectAtIndex:[lnk intValue] ]
               valueForKey:@"position"] valueForKey:@"x"] objectAtIndex:0] intValue];
      int yLnk                    = [[[[[[ jDict valueForKey:@"fermate"] objectAtIndex:[lnk intValue] ]
               valueForKey:@"position"] valueForKey:@"y"] objectAtIndex:0] intValue];
      CGPoint posLinked           = CGPointMake(xLnk, yLnk);


			//
			//	first point
      APGraphPointPixel *currPx   = [[APGraphPointPixel alloc] init];
      currPx.position             = posCurrent;
      currPx.identifier           = currName;

			//
			//	last point
      APGraphPointPixel *linkPx   = [[APGraphPointPixel alloc] init];
      linkPx.position             = posLinked;
      linkPx.identifier           = linkedName;

      APGraphVertex *currVertex   = [ APGraphVertex vertexWithPoint:currPx ];
      APGraphVertex *linkedVertex = [ APGraphVertex vertexWithPoint:linkPx ];


      int weigth            = [[[[ jDict valueForKey:@"fermate"] objectAtIndex:[sId intValue] ] valueForKey:@"weight"] intValue];
      APGraphEdge *currEdge = [ APGraphEdge edgeWithName:currName andWeight:[NSNumber numberWithInt:weigth]];
			
			[ graph addBiDirectionalEdge: currEdge fromVertex: currVertex toVertex: linkedVertex ];
		}
	}
	
	
	APGraphVertex *fVertex  = [ APGraphVertex vertexWithIdentifier:from ];
	APGraphVertex *tVertex  = [ APGraphVertex vertexWithIdentifier:to ];
	APGraphRoute *route			= [graph shortestRouteFromVertex:fVertex toVertex:tVertex];

  NSAssert ( route, @"KO. Problems with data. Check json and/or names array." );
  //	NSLog(@"%@", route);

	NSArray *data = @[route, graph, tVertex];
	[ self drawPath:data ];
}


// +---------------------------------------------------------------------------+
#pragma mark - JSON
// +---------------------------------------------------------------------------+


- (NSDictionary*) loadJson
{
	NSString *fPath = [[NSBundle mainBundle] pathForResource:@"MetroMilan" ofType:@"json"];
	NSData    *data = [NSData dataWithContentsOfFile:fPath];
  NSAssert( data, @"KO - No valid json data." );

	return
	[ NSJSONSerialization JSONObjectWithData: data
																	 options: NSJSONReadingMutableContainers
																		 error: nil ];
}


// +---------------------------------------------------------------------------+
#pragma mark - UIPickerView
// +---------------------------------------------------------------------------+


- (NSInteger)  pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { return [ self metroNames ].count; }
- (NSInteger)  numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 	return [self metroNames][row]; }


// +---------------------------------------------------------------------------+
#pragma mark - Actions
// +---------------------------------------------------------------------------+


- (void)calcola:(id)sender
{
	NSString *from = [[ self metroNames ] objectAtIndex:[ _fromPicker selectedRowInComponent:0 ]];
	NSString *to   = [[ self metroNames ] objectAtIndex:[ _toPicker   selectedRowInComponent:0 ]];
	
	[ self getPath:from to:to ];
}

- (void)reset:(id)sender
{
	// not yet implemented.
}


// +---------------------------------------------------------------------------+
#pragma mark - DEV Names
// +---------------------------------------------------------------------------+


- (NSArray*) metroNames
{
	NSArray *names = @[
										 @"Sesto FS", @"Sesto Rondo'", @"Sesto Marelli",
										 @"Villa San Giovanni", @"Precotto", @"Gorla",
										 @"Turro", @"Rovereto", @"Pasteur",
										 @"Loreto", @"LoretoRV", @"Lima", @"Porta Venezia",
										 @"Palestro", @"San Babila", @"Cordusio", @"Cairoli",
										 @"CadornaR", @"CadornaV", @"CadornaRV", @"Conciliazione",
                     @"Pagano", @"Buonarroti",
										 @"Amendola", @"Lotto", @"QT8", @"Lampugnano", @"Uruguay",
										 @"Bonola", @"San Leonardo", @"Molino Dorino", @"Pero",
										 @"Rho Fiera", @"Wagner", @"De Angeli", @"Gambara",
										 @"Bande Nere", @"Primaticcio", @"Inganni", @"Bisceglie",
										 @"Cologno Nord", @"Cologno Centro", @"Cologno Sud",
										 @"Gessate", @"Cascina Antonietta", @"Gorgonzola",
										 @"Villa Pompea", @"Bussero", @"Cassina de' Pecchi",
										 @"Villa Fiorita", @"Cernusco sul Naviglio", @"Cascina Burrona",
										 @"Vimodrone", @"Cascina Gobba", @"Crescenzago", @"Cimiano",
										 @"Udine", @"Lambrate", @"Piola-Città Studi", @"Caiazzo",
										 @"Centrale", @"CentraleGV",
                     @"Gioia", @"Garibaldi FS", @"Moscova",
										 @"Lanza", @"Sant'Ambrogio", @"Sant'Agostino", @"Porta Genova",
										 @"Romolo", @"Famagosta", @"Abbiategrasso", @"Assago Nord",
										 @"Assago Forum", @"Comasina", @"Affori FN", @"Affori Centro",
										 @"Dergano", @"Maciachini", @"Sondrio", @"Repubblica",
										 @"Turati", @"Montenapoleone", @"Duomo", @"DuomoRG", @"Missori",
										 @"Crocetta", @"Porta Romana", @"Lodi T.I.B.B.", @"Brenta",
										 @"Corvetto", @"Porto di Mare", @"Rogoredo", @"San Donato",
										 @"Bignami", @"Ponale", @"Bicocca", @"Ca' Granda",
										 @"Istria", @"Marche", @"Zara", @"ZaraLG"
										 ];
	
	NSArray *sortedArray =
	[names sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b){
		return [a compare:b];
	}];
	
	return sortedArray;
}


@end
