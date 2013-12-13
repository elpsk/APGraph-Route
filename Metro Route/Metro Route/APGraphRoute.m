//
//  APGraphRoute.m
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


#import "APGraphRoute.h"
#import "APGraphRouteStep.h"
#import "APGraphVertex.h"
#import "APGraphEdge.h"
#import "APGraphPointPixel.h"
#import "APGraphPointGeo.h"


@implementation APGraphRoute


// +---------------------------------------------------------------------------+
#pragma mark - Initialization
// +---------------------------------------------------------------------------+


- (id)init
{
	if ( self = [super init] )
	{
		_steps = [[NSMutableArray alloc] init];
	}
	
	return self;
}


// +---------------------------------------------------------------------------+
#pragma mark - Steps
// +---------------------------------------------------------------------------+


- (void)addStepFromVertex:(APGraphVertex *)fVertex withEdge:(APGraphEdge *)edge
{
	APGraphRouteStep *aStep = [[APGraphRouteStep alloc] initWithVertex:fVertex
																													 andEdge:edge
																											 asBeginning:([_steps count] == 0)];
	
	[_steps addObject:aStep];
}


// +---------------------------------------------------------------------------+
#pragma mark - Getters
// +---------------------------------------------------------------------------+


- (int) count
{
	return (int)[_steps count];
}

- (float) length
{
	float totalLength = 0;
	for (APGraphRouteStep *aStep in _steps)
	{
		if (aStep.edge) totalLength += [aStep.edge.weight floatValue];
	}
	
	return totalLength;
}

- (APGraphVertex *) startingVertex
{
	return ([self count] > 0) ? [[_steps objectAtIndex:0] vertex] : nil;
}

- (APGraphVertex *) endingVertex
{
	return ([self count] > 0) ? [[_steps objectAtIndex:([self count] - 1)] vertex] : nil;
}



// +---------------------------------------------------------------------------+
#pragma mark - Override
// +---------------------------------------------------------------------------+


- (NSString *) description
{
	NSMutableString *string = [NSMutableString string];
	
	[string appendString:@"Start: \n"];
	for (APGraphRouteStep *aStep in _steps)
	{
		if ( aStep.edge )
			[string appendFormat:@"\t%@ -> %@\n", aStep.vertex.point.identifier, aStep.edge];
		else [string appendFormat:@"\t%@", aStep.vertex.point.identifier];
	}
	
	return string;
}


@end
