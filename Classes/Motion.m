//
//  Motion.m
//  Motion
//
//  Created by Max on 31/10/2009.
//  Copyright (c) 2009 Lis@cintosh, All Rights Reserved.
//

#import "Motion.h"


@implementation Motion

@synthesize slider, label;

- (id)initWithDefinition:(NSDictionary *)dict fromArchive:(BOOL)archived
{
	if (self = [super initWithDefinition:dict fromArchive:archived]) {
		NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Movies"];
		[[self parameters] setObject:path forKey:@"path"];
		
		movie = nil;
	}
	return self;
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo
{
	if ([input respondsToSelector:@selector(count)] && [input count] > 0) {
		[self performSelectorOnMainThread:@selector(createMovieFrom:) withObject:input waitUntilDone:YES];
		
		if ([[[self parameters] objectForKey:@"save"] boolValue]) {
			NSString * path = [[self parameters] objectForKey:@"path"];
			
			NSInteger index = 0;
			NSString * exportPath = [path stringByAppendingString:@"/Export.mov"];
			BOOL fileExist = YES;
			while (fileExist) {
				if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
					exportPath = [path stringByAppendingString:[NSString stringWithFormat:@"/Export %i.mov", ++index]];
				} else {
					fileExist = NO;
				}
			}
			
			NSDictionary * attributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] 
																	forKey:QTMovieFlatten];
			[movie writeToFile:exportPath withAttributes:attributes];
			return exportPath;
		} else {
			return movie;
		}
	}
	
	return input;
}

- (void)createMovieFrom:(id)input
{
	NSError * error = nil;
	movie = [[QTMovie alloc] initToWritableData:[NSMutableData data] error:&error];
		
	[movie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute];
	
	NSNumber * number = [NSNumber numberWithFloat:codecHighQuality];
	NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								 @"jpeg", QTAddImageCodecType,
								 number, QTAddImageCodecQuality, nil];
		
	long long timeValue = 1;
	long timeScale = [[[self parameters] objectForKey:@"duration"] longValue];
	QTTime duration = QTMakeTime(timeValue, timeScale);
	
	for (NSString * path in input) {
		NSImage * image = [[NSImage alloc] initWithContentsOfFile:path];
		NSLog(@"%@", image);
		[movie addImage:image forDuration:duration withAttributes:attributes];
		[image release];
	}
}

- (void)sliderDidChange:(id)sender
{
	[label setStringValue:[NSString stringWithFormat:@"%ifps", [sender intValue]]];
}

@end