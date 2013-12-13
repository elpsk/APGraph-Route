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
#import "APGraphLib.h"


@interface APViewController ()
@end


@implementation APViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  
  
	APGraph *graph = [[APGraph alloc] init];
  
	NSMutableArray *vertexArray = [[NSMutableArray alloc] init];
  
	for ( int i=0; i<7; i++ )
	{
		APGraphPointPixel *pPix = [[APGraphPointPixel alloc] init];
		pPix.position		= CGPointZero;
		pPix.identifier = [NSString stringWithFormat:@"%c", i+65];
		
		APGraphVertex *vertex = [APGraphVertex vertexWithPoint:pPix];
		[ vertexArray addObject:vertex ];
	}
  
  
	[graph addBiDirectionalEdge:
	 [APGraphEdge edgeWithName:@"A <-> B" andWeight:[NSNumber numberWithInt:7]]
                   fromVertex:vertexArray[0] toVertex:vertexArray[1]];
	[graph addBiDirectionalEdge:
	 [APGraphEdge edgeWithName:@"A <-> C" andWeight:[NSNumber numberWithInt:9]]
                   fromVertex:vertexArray[0] toVertex:vertexArray[2]];
	[graph addBiDirectionalEdge:
	 [APGraphEdge edgeWithName:@"A <-> F" andWeight:[NSNumber numberWithInt:14]]
                   fromVertex:vertexArray[0] toVertex:vertexArray[6]];
	[graph addBiDirectionalEdge:
	 [APGraphEdge edgeWithName:@"B <-> C" andWeight:[NSNumber numberWithInt:10]]
                   fromVertex:vertexArray[1] toVertex:vertexArray[2]];
	[graph addBiDirectionalEdge:
	 [APGraphEdge edgeWithName:@"B <-> D" andWeight:[NSNumber numberWithInt:15]]
                   fromVertex:vertexArray[1] toVertex:vertexArray[3]];
	[graph addBiDirectionalEdge:
	 [APGraphEdge edgeWithName:@"C <-> F" andWeight:[NSNumber numberWithInt:2]]
                   fromVertex:vertexArray[2] toVertex:vertexArray[6]];
	[graph addBiDirectionalEdge:
	 [APGraphEdge edgeWithName:@"C <-> D" andWeight:[NSNumber numberWithInt:11]]
                   fromVertex:vertexArray[2] toVertex:vertexArray[4]];
	[graph addBiDirectionalEdge:
	 [APGraphEdge edgeWithName:@"D <-> E" andWeight:[NSNumber numberWithInt:6]]
                   fromVertex:vertexArray[4] toVertex:vertexArray[5]];
	[graph addBiDirectionalEdge:
	 [APGraphEdge edgeWithName:@"E <-> F" andWeight:[NSNumber numberWithInt:9]]
                   fromVertex:vertexArray[5] toVertex:vertexArray[6]];
  
  
	APGraphRoute *route = [graph shortestRouteFromVertex:vertexArray[0] toVertex:vertexArray[5]];
	NSLog(@"%@", route);
	NSLog(@"%f", [route length]);
  
  
	route = [graph shortestRouteFromVertex:vertexArray[1] toVertex:vertexArray[5]];
	NSLog(@"%@", route);
	NSLog(@"%f", [route length]);
	
}


@end
