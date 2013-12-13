//
//  APGraphEdge.h
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


#import <Foundation/Foundation.h>

// +---------------------------------------------------------------------------+
//	APGraphEdge
// +---------------------------------------------------------------------------+

/**
 *  Edge class
 */
@interface APGraphEdge : NSObject

/**
 *  Edge weight
 */
@property (nonatomic, strong)						 NSNumber *weight;

/**
 *  Edge name
 */
@property (nonatomic, unsafe_unretained) NSString *name;

/**
 *  Edge description
 */
@property (nonatomic, unsafe_unretained) NSString *text;

/**
 *  Add edge with name and default weight
 *
 *  @param aName Edge name
 *
 *  @return The edge
 */
+ (APGraphEdge *) edgeWithName:(NSString *)aName;

/**
 *  Add edge with name and custom weight
 *
 *  @param aName   Edge name
 *  @param aNumber Weight
 *
 *  @return The Edge
 */
+ (APGraphEdge *) edgeWithName:(NSString *)aName andWeight:(NSNumber *)aNumber;

/**
 *  Add edge with name, text, and custom weight
 *
 *  @param aName   Edge name
 *  @param aNumber Weight
 *  @param aText   Edge description
 *
 *  @return The Edge
 */
+ (APGraphEdge *) edgeWithName:(NSString *)aName andWeight:(NSNumber *)aNumber andText:(NSString*)aText;


@end
