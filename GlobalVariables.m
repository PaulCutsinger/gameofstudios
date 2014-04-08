//
//  GlobalVariables.m
//  GameOfStudios
//
//  Created by Cutsinger, Paul on 4/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables

+ (GlobalVariables*) sharedInstance {
    static GlobalVariables *myInstance = nil;
    if (myInstance == nil) {
        myInstance = [[[self class] alloc] init];
        
        //start the list of variables to share globally
        myInstance.testFloat = 2.0;
        
        
        
    }
    return myInstance;
}

@end
