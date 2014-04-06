//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
    //show FPS and node count
    [[CCDirector sharedDirector] setDisplayStats:YES];
}

@end
