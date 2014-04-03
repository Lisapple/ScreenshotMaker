//
//  Screenshot_Maker.h
//  Screenshot Maker
//
//  Created by Max on 1/1/11.
//  Copyright 2011 Lisacintosh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>
#import <QuartzCore/QuartzCore.h>
#import <OSAKit/OSAKit.h>

@interface Screenshot_Maker : AMBundleAction 
{
	NSDictionary ** errorInfoDictionary;
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;
- (void)cropImagesFromAction:(AMAction *)inputAction;

@end
