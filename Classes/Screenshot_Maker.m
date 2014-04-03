//
//  Screenshot_Maker.m
//  Screenshot Maker
//
//  Created by Max on 1/1/11.
//  Copyright 2011 Lisacintosh. All rights reserved.
//

#import "Screenshot_Maker.h"

/*
 To Do List:
 - when saving pictures, change extension to .png
 */

@implementation Screenshot_Maker

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo
{
	/*
	 NSArray * objsArray = [NSArray arrayWithObjects:
	 [NSNumber numberWithInt:errOSASystemError],
	 @"ERROR !!!\n", nil];
	 
	 NSArray * keysArray = [NSArray arrayWithObjects:OSAScriptErrorNumber, OSAScriptErrorMessage, nil];
	 
	 *errorInfo = [NSDictionary dictionaryWithObjects:objsArray
	 forKeys:keysArray];
	 return nil;
	 */
	
	errorInfoDictionary = errorInfo;
	[self performSelectorOnMainThread:@selector(cropImagesFromAction:) withObject:input waitUntilDone:YES];
	
	return input;
}

- (void)cropImagesFromAction:(AMAction *)inputAction
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	/*
	 iPhone (standard):
	 - portrait: from 320x480 to 320x460
	 - landscape: from 480x320 to 480x300
	 
	 iPhone 4 (Retina Display):
	 - portrait: from 640x960 to 640x920
	 - landscape: from 960x640 to 960x600
	 
	 iPad:
	 
	 768, 1024
	 - portrait: from 768x1024 to 768x1004
	 - landscape: from 1024x768 to 1024x748
	 
	 
	 /!\ in Mac OS X, (0, 0) is the corner down-left
	 */
	
	for (NSString * path in (NSArray *)inputAction) {
		CIImage * ciImage = [[CIImage alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
		
		NSBitmapImageRep * imageRep = [[NSBitmapImageRep alloc] initWithCIImage:ciImage];
		NSSize size = [imageRep size];
		[imageRep release];
		
		CGRect rect = CGRectNull;
		if (size.width == 320. && size.height == 480.)// iPhone portait
			rect = CGRectMake(0., 0., 320., 460.);
		else if (size.width == 480. && size.height == 320.)// iPhone landscape
			rect = CGRectMake(0., 0., 480., 300.);
		else if (size.width == 640. && size.height == 960.)// iPhone 4 portait
			rect = CGRectMake(0., 0., 640., 920.);
		else if (size.width == 960. && size.height == 640.)// iPhone 4 landscape
			rect = CGRectMake(0., 0., 960., 600.);
		else if (size.width == 768. && size.height == 1024.)// iPad portait
			rect = CGRectMake(0., 0., 768., 1004.);
		else if (size.width == 1024. && size.height == 768.)// iPad landscape
			rect = CGRectMake(0., 0., 1024., 748.);
		/* Maybe for an Retina iPad!!! */
		else if (size.width == 1536. && size.height == 2048.)// iPad (Retina Display???) portait
			rect = CGRectMake(0., 0., 1536., 2008.);
		else if (size.width == 2048. && size.height == 1536.)// iPad (Retina Display???) landscape
			rect = CGRectMake(0., 0., 2048., 1496.);
		
		if (!CGRectIsNull(rect)) {//If size has not be correct, ignore the conversion and go to next image
			CIImage * croppedCIImage = [ciImage imageByCroppingToRect:rect];
			
			imageRep = [[NSBitmapImageRep alloc] initWithCIImage:croppedCIImage];
			
			NSDictionary * properties = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSImageInterlaced, nil];
			NSData * data = [imageRep representationUsingType:NSPNGFileType properties:properties];
			NSError * error = nil;
			
			if (![data writeToURL:[NSURL fileURLWithPath:path] options:NSAtomicWrite error:&error]) {
				NSString * errorString = [NSString stringWithFormat:@"Image output can't be write (%@). Check you have permissions to write or you have some space available on hard disk.\n", [error localizedDescription]];
				
				NSArray * objsArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:errOSASystemError], errorString, nil];
				NSArray * keysArray = [[NSArray alloc] initWithObjects:OSAScriptErrorNumber, OSAScriptErrorMessage, nil];
				
				*errorInfoDictionary = [NSDictionary dictionaryWithObjects:objsArray
														 forKeys:keysArray];
				[objsArray release];
				[keysArray release];
				
				return;
			}
			
			[properties release];
			[imageRep release];
		}
		
		[ciImage release];
	}
	
	[pool drain];
}

@end
