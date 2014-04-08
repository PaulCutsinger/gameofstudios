//
//  GlobalVariables.h
//  GameOfStudios
//
//  Created by Cutsinger, Paul on 4/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVariables : NSObject

@property (nonatomic) CGFloat testFloat;
+ (GlobalVariables*) sharedInstance;

@end
