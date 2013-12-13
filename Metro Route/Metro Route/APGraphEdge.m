//
//  APGraphEdge.m
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

#import "APGraphEdge.h"

@implementation APGraphEdge


// +---------------------------------------------------------------------------+
#pragma mark - Class methods
// +---------------------------------------------------------------------------+

+ (APGraphEdge *)edgeWithName:(NSString *)aName andWeight:(NSNumber *)aNumber andText:(NSString*)aText
{
	APGraphEdge *anEdge = [[APGraphEdge alloc] init];
	
	anEdge.weight = aNumber;
	anEdge.name		= aName;
	anEdge.text   = aText;
	
	return anEdge;
}

+ (APGraphEdge *)edgeWithName:(NSString *)aName andWeight:(NSNumber *)aNumber
{
	APGraphEdge *anEdge = [[APGraphEdge alloc] init];

	anEdge.weight = aNumber;
	anEdge.name		= aName;

	return anEdge;
}

+ (APGraphEdge *)edgeWithName:(NSString *)aName
{
	APGraphEdge *anEdge = [[APGraphEdge alloc] init];
	anEdge.name = aName;
	return anEdge;
}


// +---------------------------------------------------------------------------+
#pragma mark - Initializers
// +---------------------------------------------------------------------------+


- (id) init
{
	self = [super init];
	
	if (self)
	{
		_weight = [NSNumber numberWithInt:1];

		_name		= @"";
		_text   = @"";
	}
	
	return self;
}


// +---------------------------------------------------------------------------+
#pragma mark - Overrides
// +---------------------------------------------------------------------------+


- (NSString *) description
{
	return [NSString stringWithFormat:
					@"Edge: %@ (%@) with Weight:%@",
					self.name,
					self.text,
					self.weight
					];
}


@end
