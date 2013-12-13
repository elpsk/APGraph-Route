//
//  APGraph.m
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


#import "APGraph.h"
#import "APGraphEdge.h"
#import "APGraphVertex.h"
#import "APGraphRoute.h"
#import "APGraphPoint.h"
#import "APGraphPointPixel.h"
#import "APGraphPointGeo.h"


@interface APGraph ()
{
	NSMutableDictionary *_vertexEdges;
	NSMutableDictionary *_vertices;
}

- (id) keyOfSmallestValue:(NSDictionary *)aDictionary withInKeys:(NSArray *)anArray;

@end


@implementation APGraph


// +---------------------------------------------------------------------------+
#pragma mark - Initialization
// +---------------------------------------------------------------------------+


- (id)init
{
	self = [super init];
	
	if (self)
  {
		_vertexEdges	= [[NSMutableDictionary alloc] init];
		_vertices			= [[NSMutableDictionary alloc] init];
	}
	
	return self;
}


// +---------------------------------------------------------------------------+
#pragma mark - Edges and Vertices
// +---------------------------------------------------------------------------+


- (APGraphVertex *)vertexInGraphWithIdentifier:(NSString *)identifier
{
	return [_vertices objectForKey:identifier];
}

- (APGraphEdge *)edgeFromVertex:(APGraphVertex *)fVertex toNeighboringVertex:(APGraphVertex *)tVertex
{
	if ( ! [_vertexEdges objectForKey:fVertex.point.identifier])
		return nil;

	return [[_vertexEdges objectForKey:fVertex.point.identifier]
          objectForKey:tVertex.point.identifier];
}

- (NSNumber *)weightFromVertex:(APGraphVertex *)fVertex toNeighboringVertex:(APGraphVertex *)tVertex
{
	APGraphEdge *graphEdge = [self edgeFromVertex:fVertex toNeighboringVertex:tVertex];
	return (graphEdge) ? graphEdge.weight : nil;
}

- (NSSet *)neighborsOfVertex:(APGraphVertex *)Vertex
{
	NSDictionary *edgesFromVertex = [_vertexEdges objectForKey:Vertex.point.identifier];

	if ( !edgesFromVertex )
		return nil;


	NSMutableSet *neighboringVertices = [NSMutableSet set];
	for (NSString *neighboringVertexIdentifier in edgesFromVertex)
	{
		[neighboringVertices addObject:[_vertices objectForKey:neighboringVertexIdentifier]];
	}

	return neighboringVertices;
}

- (NSSet *)neighborsOfVertexWithIdentifier:(NSString *)identifier
{
	APGraphVertex *identifiedVertex = [ _vertices objectForKey:identifier ];
	
	return (identifiedVertex == nil) ? nil : [self neighborsOfVertex:identifiedVertex];
}

- (void) addEdge:(APGraphEdge *)anEdge fromVertex:(APGraphVertex *)fVertex toVertex:(APGraphVertex *)tVertex
{
	[_vertices setObject:fVertex forKey:fVertex.point.identifier];
	[_vertices setObject:tVertex forKey:tVertex.point.identifier];
	
	if ( [_vertexEdges objectForKey:fVertex.point.identifier] == nil )
	{
    NSMutableDictionary *dic = [NSMutableDictionary
                                dictionaryWithObject:anEdge
                                forKey:tVertex.point.identifier];
    
		[_vertexEdges setObject:dic forKey:fVertex.point.identifier];
	}
	else
	{
		[(NSMutableDictionary *)
     [_vertexEdges objectForKey:fVertex.point.identifier]
     setObject:anEdge forKey:tVertex.point.identifier];
	}
}

- (BOOL) removeEdgeFromVertex:(APGraphVertex*)fVertex toVertex:(APGraphVertex*)tVertex
{
	if ( [[_vertexEdges objectForKey:fVertex.point.identifier] objectForKey:tVertex.point.identifier] == nil )
		return NO;

	[[_vertexEdges objectForKey:fVertex.point.identifier] removeObjectForKey:tVertex.point.identifier];
	return YES;
}

- (void)addBiDirectionalEdge:(APGraphEdge *)anEdge fromVertex:(APGraphVertex *)fVertex toVertex:(APGraphVertex *)tVertex
{
	[self addEdge:anEdge fromVertex:fVertex toVertex:tVertex];
	[self addEdge:anEdge fromVertex:tVertex toVertex:fVertex];
}

- (BOOL)removeBiDirectionalEdgeFromVertex:(APGraphVertex*)fVertex toVertex:(APGraphVertex*)tVertex
{
	APGraphEdge *toEdge		= [self edgeFromVertex:fVertex toNeighboringVertex:tVertex];
	APGraphEdge *fromEdge = [self edgeFromVertex:tVertex toNeighboringVertex:fVertex];
	
	if (toEdge == nil || fromEdge == nil)
		return NO;


	[self removeEdgeFromVertex:fVertex toVertex:tVertex];
	[self removeEdgeFromVertex:tVertex toVertex:fVertex];
	
	return YES;
}


// +---------------------------------------------------------------------------+
#pragma mark - Core
// +---------------------------------------------------------------------------+


- (APGraphRoute *)shortestRouteFromVertex:(APGraphVertex *)fVertex toVertex:(APGraphVertex *)tVertex
{
	NSMutableDictionary *unexaminedVertices = [NSMutableDictionary dictionaryWithDictionary:_vertices];

	//
	// La distanza finora trovata dall'origine per ogni nodo nel grafico.
	// Se non c'è, ci metto INFINITO (-1).
	//
	NSMutableDictionary *distancesFromSource = [NSMutableDictionary dictionaryWithCapacity:[unexaminedVertices count]];
	
	//
	// nodo precendente con percorso più rapido
	//
	NSMutableDictionary *previousVertexInOptimalPath = [NSMutableDictionary dictionaryWithCapacity:[unexaminedVertices count]];

	NSNumber *infinity = [ NSNumber numberWithInt: -1 ];
	for (NSString *vertexIdentifier in unexaminedVertices)
	{
		[distancesFromSource setValue:infinity forKey:vertexIdentifier];
	}
	
	[distancesFromSource setValue:[NSNumber numberWithInt:0] forKey:fVertex.point.identifier];
	
	NSString *currentlyExaminedIdentifier = nil;
	while ( [unexaminedVertices count] > 0 )
	{
		//
		// cerco il nodo, tra quelli esaminati che ha il percorso migliore con l'origine
		//
		NSString *identifierOfSmallestDist = [self keyOfSmallestValue:distancesFromSource withInKeys:[unexaminedVertices allKeys]];

		if ( !identifierOfSmallestDist ) break;
		else
		{
			APGraphVertex *vertexMostRecentlyExamined = [self vertexInGraphWithIdentifier:identifierOfSmallestDist];

			//
			// se il nodo più vicino è il nodo ultimo, ci siamo.
			//
			if ( [identifierOfSmallestDist isEqualToString:tVertex.point.identifier] )
			{
				currentlyExaminedIdentifier = tVertex.point.identifier;
				break;
			}
			else
			{
				[unexaminedVertices removeObjectForKey:identifierOfSmallestDist];
				
				for ( APGraphVertex *neighboringVertex in [self neighborsOfVertexWithIdentifier:identifierOfSmallestDist] )
				{
					//
					// calcolo la distanza dal punto di origine al vicino, dai nodi già esaminati.
					// se trovo una strada migliore di quella corrente, la salvo
					//
					NSNumber *alt = [NSNumber numberWithFloat:
													 [[distancesFromSource objectForKey:identifierOfSmallestDist] floatValue] +
													 [[self weightFromVertex:vertexMostRecentlyExamined toNeighboringVertex:neighboringVertex] floatValue]];
					
					NSNumber *distanceFromNeighborToOrigin = [distancesFromSource objectForKey:neighboringVertex.point.identifier];

					if ([distanceFromNeighborToOrigin isEqualToNumber:infinity] || [alt compare:distanceFromNeighborToOrigin] == NSOrderedAscending)
					{
						[distancesFromSource setValue:alt forKey:neighboringVertex.point.identifier];
						[previousVertexInOptimalPath setValue:vertexMostRecentlyExamined forKey:neighboringVertex.point.identifier];
					}
				}
			}
		}
	}

	//
	// ~ abbiamo trovato una strada
	// ~ non ci sono altre strade valide
	//
	if ( currentlyExaminedIdentifier == nil || ! [currentlyExaminedIdentifier isEqualToString:tVertex.point.identifier]) return nil;
	else
	{
		APGraphRoute *route = [[APGraphRoute alloc] init];
		
		NSMutableArray *verticesInRouteInReverseOrder = [NSMutableArray array];
		[verticesInRouteInReverseOrder addObject:tVertex];
		
		APGraphVertex *lastStepVertex = tVertex;
		APGraphVertex *previousVertex;
		
		while ((previousVertex = [previousVertexInOptimalPath objectForKey:lastStepVertex.point.identifier]))
		{
			[verticesInRouteInReverseOrder addObject:previousVertex];
			lastStepVertex = previousVertex;
		}
		
		//
		// revert data
		//
		NSUInteger numVerticesInPath = [verticesInRouteInReverseOrder count];
		for (int i = numVerticesInPath - 1; i >= 0; i--)
		{
			APGraphVertex *currentGraphVertex = [verticesInRouteInReverseOrder objectAtIndex:i];
			APGraphVertex *nextGraphVertex = (i - 1 < 0) ? nil : [verticesInRouteInReverseOrder objectAtIndex:(i - 1)];

			[route addStepFromVertex:currentGraphVertex withEdge:nextGraphVertex ? [self edgeFromVertex:currentGraphVertex toNeighboringVertex:nextGraphVertex] : nil];
		}
		
		return route;
	}
}


// +---------------------------------------------------------------------------+
#pragma mark - Getter
// +---------------------------------------------------------------------------+


- (NSInteger) edgeCount
{
	NSInteger edgeCount = 0;
	
	for (NSString *vertexIdentifier in _vertexEdges)
	{
		edgeCount += [(NSDictionary *)[_vertexEdges objectForKey:vertexIdentifier] count];
	}
	
	return edgeCount;
}


// +---------------------------------------------------------------------------+
#pragma mark - Internals
// +---------------------------------------------------------------------------+


- (id) keyOfSmallestValue:(NSDictionary *)aDictionary withInKeys:(NSArray *)anArray
{
	id keyForSmallestValue	= nil;
	NSNumber *smallestValue = nil;
	NSNumber *infinity			= [NSNumber numberWithInt:-1];
	
	for (id key in anArray)
	{
		NSNumber *currentTestValue = [aDictionary objectForKey:key];
		
		if ( ! [currentTestValue isEqualToNumber:infinity])
		{
			if (smallestValue == nil || [smallestValue compare:currentTestValue] == NSOrderedDescending)
			{
				keyForSmallestValue = key;
				smallestValue = currentTestValue;
			}
		}
	}
	
	return keyForSmallestValue;
}


@end
