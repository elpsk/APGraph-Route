//
//  APGraphVertex.h
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

@class APGraphPoint, APGraphPointPixel, APGraphPointGeo;


// +---------------------------------------------------------------------------+
//	APGraphVertex
// +---------------------------------------------------------------------------+

/**
 *  The vertex class
 */
@interface APGraphVertex : NSObject

/**
 *  The point of vertex
 */
@property (nonatomic, strong) APGraphPoint *point;


/**
 *  Get a vertex
 *
 *  @param anIdentifier Vertex identifier
 *
 *  @return The vertex
 */
+ (APGraphVertex *) vertexWithIdentifier:(NSString *)anIdentifier;

/**
 *  Get a vertex
 *
 *  @param anIdentifier Vertex identifier
 *  @param title        Vertex title
 *
 *  @return The vertex
 */
+ (APGraphVertex *) vertexWithIdentifier:(NSString *)anIdentifier title:(NSString*)title;

/**
 *  Get a vertex
 *
 *  @param point Vertex point
 *
 *  @return The vertex
 */
+ (APGraphVertex *) vertexWithPoint		: (APGraphPoint*)				point;


@end
