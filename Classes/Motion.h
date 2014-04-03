//
//  Motion.h
//  Motion
//
//  Created by Max on 31/10/2009.
//  Copyright (c) 2009 Lis@cintosh, All Rights Reserved.
//

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>
#import <QTKit/QTKit.h>

@interface Motion : AMBundleAction 
{
	NSSlider * slider;
	NSTextField * label;
	QTMovie * movie;
}

@property (assign) IBOutlet NSSlider * slider;
@property (assign) IBOutlet NSTextField * label;

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;
- (void)createMovieFrom:(id)input;
- (void)sliderDidChange:(id)sender;


@end
