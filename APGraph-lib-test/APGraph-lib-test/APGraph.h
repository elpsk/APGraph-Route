//
//  APGraph.h
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

@class APGraphEdge;
@class APGraphVertex;
@class APGraphRoute;


// +---------------------------------------------------------------------------+
//	APGraph
// +---------------------------------------------------------------------------+

/**
 *  Graph core class
 */
@interface APGraph : NSObject

/**
 *  List of vertices
 */
@property (nonatomic, readonly) NSDictionary *vertices;

/**
 *  Number of edge
 */
@property (nonatomic, readonly) NSInteger     edgeCount;

/**
 *  Get vertex with identifier
 *
 *  @param identifier The identifier
 *
 *  @return The vertex
 */
- (APGraphVertex *)	vertexInGraphWithIdentifier:(NSString *)identifier;

/**
 *  Get edge with vertex
 *
 *  @param source      Source vertex
 *  @param destination Destination xertex
 *
 *  @return The edge
 */
- (APGraphEdge *)		edgeFromVertex:(APGraphVertex *)source toNeighboringVertex:(APGraphVertex *)destination;

/**
 *  Get weight from two vertex
 *
 *  @param source      Source vertex
 *  @param destination Destination vertex
 *
 *  @return Weigth
 */
- (NSNumber *) weightFromVertex:(APGraphVertex *)source toNeighboringVertex:(APGraphVertex *)destination;

/**
 *  Return neighbors of vertex
 *
 *  @param Vertex The vertex
 *
 *  @return An unique set of vertex
 */
- (NSSet *)	neighborsOfVertex:(APGraphVertex *)Vertex;

/**
 *  Return neighbors of vertex identifier
 *
 *  @param identifier The identifier
 *
 *  @return An unique set of vertex
 */
- (NSSet *)	neighborsOfVertexWithIdentifier:(NSString *)identifier;

/**
 *  Add an edge
 *
 *  @param anEdge  Edge to add
 *  @param fVertex From vertex
 *  @param tVertex To vertex
 */
- (void) addEdge:(APGraphEdge *)anEdge fromVertex:(APGraphVertex *)fVertex toVertex:(APGraphVertex *)tVertex;

/**
 *  Remove an edge
 *
 *  @param fVertex From vertex
 *  @param tVertex To vertex
 *
 *  @return Status
 */
- (BOOL) removeEdgeFromVertex:(APGraphVertex*)fVertex toVertex:(APGraphVertex*)tVertex;

/**
 *  Add a bidirectional edge
 *
 *  @param anEdge  Edge to add
 *  @param fVertex From vertex
 *  @param tVertex To vertex
 */
- (void) addBiDirectionalEdge:(APGraphEdge *)anEdge fromVertex:(APGraphVertex *)fVertex toVertex:(APGraphVertex *)tVertex;

/**
 *  Remove a bidirectional edge
 *
 *  @param fVertex From vertex
 *  @param tVertex To vertex
 *
 *  @return Status
 */
- (BOOL) removeBiDirectionalEdgeFromVertex:(APGraphVertex*)fVertex toVertex:(APGraphVertex*)tVertex;

/**
 *  Return the route path
 *
 *  @param fVertex From vertex
 *  @param tVertex To vertex
 *
 *  @return Route path
 */
- (APGraphRoute *) shortestRouteFromVertex:(APGraphVertex *)fVertex toVertex:(APGraphVertex *)tVertex;


@end
