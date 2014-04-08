//
//  GameScene.m
//  GameOfStudios
//
//  Created by Cutsinger, Paul on 3/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//


#import "GameScene.h"
#import "Foundation/NSSet.h"
#import "Foundation/NSObject.h"
#import <tgmath.h>
#import "Peg.h"

@implementation GameScene {
    CCPhysicsNode *_physicsNode;
    CCNode *_field;
    NSInteger _points;
    CGFloat _playerCount; //cleanup: delete?
    NSInteger _impressions;
    CGFloat _dollars;
    CGFloat _installs;
    //CGFloat _deltaInstalls;
    //CGFloat _previousInstalls;

    CGFloat _1DayRetained;
    CGFloat _3DayRetained;
    CGFloat _7DayRetained;
    CGFloat _30DayRetained;
    CGFloat _DAU;
    CGFloat _oddsToInstall;
    CGFloat _oddsToRetain;
    CGFloat _userAcquisitionCost;
    BOOL isFPSLimited;
  
    BOOL isAnalyticsOn;
    BOOL isTargetedTouch; //False is drop ragdoll from the top. True is spawn at touch
    CGFloat _FPS;
    
    
    CCLabelTTF *_scoreLabel;
    CCNode* _bottomBounds;
    CCNode* _leftBounds;
    CCNode* _rightBounds;
    CCNode* _topBounds;
    
    //CCLabelTTF *_playerCountLabel;
    CCLabelTTF *_dollarsScoreLabel;
    CCLabelTTF *_impressionsScoreLabel;
    CCLabelTTF *_installsScoreLabel;
    CCLabelTTF *_viralityScoreLabel;
    CCLabelTTF *_1DayScoreLabel;
    CCLabelTTF *_3DayScoreLabel;
    CCLabelTTF *_7DayScoreLabel;
    CCLabelTTF *_30DayScoreLabel;
    CCLabelTTF *_DAUScoreLabel;
    CCLabelTTF *_ARPUScoreLabel;
    CCLabelTTF *_LTVScoreLabel;
    CCLabelTTF *_cpImpressionScoreLabel;
    CCLabelTTF *_cpInstallScoreLabel;
    
    CCLabelTTF *_dollarsLabel;
    CCLabelTTF *_impressionsLabel;
    CCLabelTTF *_installsLabel;
    CCLabelTTF *_viralityLabel;
    CCLabelTTF *_1DayLabel;
    CCLabelTTF *_3DayLabel;
    CCLabelTTF *_7DayLabel;
    CCLabelTTF *_30DayLabel;
    CCLabelTTF *_DAULabel;
    CCLabelTTF *_ARPULabel;
    CCLabelTTF *_LTVLabel;
    CCLabelTTF *_cpImpressionLabel;
    CCLabelTTF *_cpInstallLabel;
    
    //CCLabelTTF *_moneyBoxValue;
    //CGFloat value;
    
    CGFloat _totalTime;
    CGFloat _timePerDay;
    CGFloat _currentDay;
    NSInteger _countOfPegs;
    NSInteger _level; // for switch of level in game
    
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    NSLog(@"Loaded");
    NSLog(@"Bounds Loaded");
    
    // set this class as delegate
    _physicsNode.collisionDelegate = self;
    // set collision txpe
    _level = 1;  //global start level of game
    [self resetAll];
    
}

#pragma Initialize


-(void)resetAll{


    _bottomBounds.physicsBody.collisionType = @"bottomBounds";
    _bottomBounds.physicsBody.sensor = TRUE;
    _leftBounds.physicsBody.collisionType = @"leftBounds";
    _leftBounds.physicsBody.sensor = TRUE;
    _rightBounds.physicsBody.collisionType = @"rightBounds";
    _rightBounds.physicsBody.sensor = TRUE;
    _topBounds.physicsBody.collisionType = @"topBounds";
    _topBounds.physicsBody.sensor = TRUE;
  
    _totalTime=0;
    _timePerDay=2;
    _oddsToInstall=.9;
    _oddsToRetain=.5;
    _playerCount=0; // this may not be used. Delete?
    _impressions=0;
    _dollars=0.0;
    _installs=0;
    _userAcquisitionCost=2;
    isAnalyticsOn = NO;
    isFPSLimited=FALSE;
    isTargetedTouch=FALSE;
    [self clearLevel];
    [self clearScoreBoard];
    [self showScoreBoard:isAnalyticsOn];
    
   // [self setLevel3];
   [self gameLoop:_level]; // Start switch
    [self makePeg];
    
    
}

-(void)gameLoop:(int)level{
    
    switch(level){
        case 1:
        [self setLevel1];
        break;
        case 2:
        [self setLevel2];
        break;
        case 3:
        [self setLevel3];
        break;
        default: // should end game here
        _level = 1;
        [self resetGame];
        break;
    }
}
        
    }

-(void)makePeg {
    
    //Make a peg that's a phy
    Peg *engagementPeg = [[Peg alloc] init];
    engagementPeg.value=4.0;
    //BOOL isPhysics = engagementPeg.physicsNode;
    engagementPeg.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, 10, 10) cornerRadius:0.0];
    engagementPeg.physicsBody.type = CCPhysicsBodyTypeStatic;
    //engagementPeg.
    engagementPeg.position = CGPointMake(100.0f, 100.0f);
    engagementPeg.physicsBody.collisionType = @"PayBox";
    engagementPeg.zOrder=-10;
    //NSLog(@"%d",isPhysics );
    
    [_physicsNode addChild:engagementPeg];
    
    
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0f green:0.2f blue:0.2f alpha:1.0f]];
        [background setContentSize:CGSizeMake(10, 10)];
    NSString *value = [NSString stringWithFormat:@"$%0.1f",engagementPeg.value];
    CCLabelTTF *pegLabel = [CCLabelTTF labelWithString:value fontName:@"Helvetica" fontSize:8];
    pegLabel.zOrder=11;
    
    [engagementPeg addChild:pegLabel];
    [engagementPeg addChild:background];
  
    
    }





-(void)showScoreBoard :(BOOL) isShown {
    
    //show or hide the score board
    
    _dollarsLabel.visible = isShown;
    _impressionsLabel.visible = isShown;
    _installsLabel.visible = isShown;
    _viralityLabel.visible = isShown;
    _1DayLabel.visible = isShown;
    _3DayLabel.visible = isShown;
    _7DayLabel.visible = isShown;
    _30DayLabel.visible = isShown;
    _DAULabel.visible = isShown;
    _ARPULabel.visible = isShown;
    _LTVLabel.visible = isShown;
    _cpImpressionLabel.visible = isShown;
    _cpInstallLabel.visible = isShown;
    

    _installsScoreLabel.visible = isShown;
    _viralityScoreLabel.visible = isShown;
    _1DayScoreLabel.visible = isShown;
    _3DayScoreLabel.visible = isShown;
    _7DayScoreLabel.visible = isShown;
    _30DayScoreLabel.visible = isShown;
    _DAUScoreLabel.visible = isShown;
    _ARPUScoreLabel.visible = isShown;
    _LTVScoreLabel.visible = isShown;
    _cpImpressionScoreLabel.visible = isShown;
    _cpInstallScoreLabel.visible = isShown;
    
    //except always show impressions and dollars
    
    //_dollarsScoreLabel.visible = isShown;
    //_impressionsScoreLabel.visible = isShown;
    
}

-(void)clearLevel{
    for (int i = 0; i < _physicsNode.children.count; i++) {
        
        CCNode *node = [_physicsNode.children objectAtIndex:i];
         NSLog(@"name:%i of %lu,%@",i,(unsigned long)_physicsNode.children.count,node.name);
        if ([node.name isEqual:@"grayPeg"] || [node.name isEqual:@"greenPeg"]  ) {
           
            [_physicsNode removeChild:node];
            i--;
        }

    }
    
}

-(void)clearScoreBoard{
    
    NSString *zero = @"0";
    _dollarsScoreLabel.string=@"$0";
    _impressionsScoreLabel.string = zero;
    _installsScoreLabel.string = zero;
    _viralityScoreLabel.string = zero;
    _1DayScoreLabel.string = zero;
    _3DayScoreLabel.string = zero;
    _7DayScoreLabel.string = zero;
    _30DayScoreLabel.string = zero;
    _DAUScoreLabel.string = zero;
    _ARPUScoreLabel.string = zero;
    _LTVScoreLabel.string = zero;
    _cpImpressionScoreLabel.string = zero;
    _cpInstallScoreLabel.string = zero;
    
  
    
}

-(void)setLevel1{
    [self setGreenPegs:250.0f:75.0f];
    [self setGreenPegs:200.0f:100.0f];
    [self setGreenPegs:250.0f:150.0f];
    [self setGreenPegs:300.0f:100.0f];
    [self setGreenPegs:200.0f:175.0f];
    [self setGreenPegs:250.0f:225.0f];
    [self setGreenPegs:300.0f:175.0f];
    [self setGreenPegs:200.0f:250.0f];
    [self setGreenPegs:300.0f:250.0f];
    
}

-(void)setLevel2{
    [self setGrayPegs:200.0f:100.0f];
    [self setGrayPegs:250.0f:75.0f];
    [self setGrayPegs:300.0f:100.0f];
    [self setGrayPegs:200.0f:175.0f];
    [self setGrayPegs:250.0f:150.0f];
    [self setGrayPegs:300.0f:175.0f];
    [self setGrayPegs:200.0f:250.0f];
    [self setGrayPegs:250.0f:225.0f];
    [self setGrayPegs:300.0f:250.0f];
    
}

-(void)setLevel3{
    int heightGrid=5;
    int widthGrid=6;
    int numNodesInGrid = heightGrid*widthGrid;
    BOOL isStaggered=TRUE;
    BOOL showLastPegInColumn=TRUE;
    CGFloat fieldWidth = _field.boundingBox.size.width;
    CGFloat fieldHeight = _field.boundingBox.size.height;
    CGPoint lowerLeftFieldInWorld = [_field convertToWorldSpace: CGPointMake(0, 0)];
    CGFloat x;
    CGFloat y;
    
    
    
    for (int i=0; i<numNodesInGrid; i++) {
        int column = i % widthGrid;
        int row = i/widthGrid;
        
        //Get actual screensize
        
        //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
        //NSLog(@"lowerLeft:%@ width:%0.1f height:%0.1f",NSStringFromCGPoint(lowerLeftFieldInWorld), fieldWidth,fieldHeight);
        x=column*fieldWidth/(widthGrid-1)+lowerLeftFieldInWorld.x;
        y=row*fieldHeight/(numNodesInGrid/(widthGrid+1))+lowerLeftFieldInWorld.y;
        
        if (isStaggered) {
            if (row%2) {
                x=x+.5*(fieldWidth/(widthGrid-1));
                if (column==widthGrid-1) {
                    showLastPegInColumn=FALSE;
                }
            }
        }
        //NSLog(@"row:%i , col:%i", row, column);
        if (showLastPegInColumn) {
            [self setGrayPegs:x :y];
        }
        else {showLastPegInColumn=TRUE;}
        
        
    }
        //******* Now, Place Money Boxes along the bottom
        
        //Assume that the anchor is at the middle top of the box
        //Attach to the bottom of the field
        //use the same spacing as the pegs
    CGFloat value = 0.5;
        for (int i=0; i<widthGrid;i++) {
            x=i*fieldWidth/(widthGrid-1)+lowerLeftFieldInWorld.x;
            y=lowerLeftFieldInWorld.y-30; //TODO hardcoded offset...
            value=value+1;
            
            [self setMoneyBox:x :y :value];
        }
        
        
    
}


    /*
     NSMutableArray *curRow; // use to access the row while loading with objects
    NSMutableArray *array = [[NSMutableArray alloc] init]; // your main multidim array
    curRow = [NSMutableArray array];
    [curRow addObject: what you want here ];
    [curRow addObject: what you want here ];
    [curRow addObject: what you want here ];
    [array addObject:curRow];  //first row is added
    
    //rinse and repeat
    curRow = [NSMutableArray array];
    [curRow addObject: what you want here ];
    [curRow addObject: what you want here ];
    [curRow addObject: what you want here ];
    [array addObject:curRow];
    
    [(NSMutableArray *)[array objectAtIndex:X] objectAtIndex:Y];
    */
    


-(void)setMoneyBox:(CGFloat)x :(CGFloat)y :(CGFloat)v {
    //cleanup. This method should be setPayBox rather than setMoneyBox
    
    
    CCNode* payBox =[CCBReader load:@"PayBox"];
    CGPoint location = CGPointMake(x, y);
    payBox.position = location;
    payBox.physicsBody.collisionType = @"payBox";
    payBox.zOrder=5;
    payBox.name=@"payBox";
    
    
    //TODO need to figure out how to update the box and it's label to have the proper value. Stuck on this...
    
    [_physicsNode addChild:payBox];
    
    //see collisions section to see what happends when ragdoll collides with this.
    
}


-(void)setGreenPegs:(CGFloat)x :(CGFloat)y  {
    CCNode* greenPeg = [CCBReader load:@"GreenPeg"];
    CGPoint location = CGPointMake(x, y);
    greenPeg.position = location;
    greenPeg.physicsBody.collisionType = @"greenPeg";
    greenPeg.zOrder=5;
    greenPeg.name=@"greenPeg";
    //greenPeg.physicsBody.sensor = TRUE; //if sensor is true it detects collision but doesn't react like objects
    [_physicsNode addChild:greenPeg];
}

-(void)setGrayPegs:(CGFloat)x :(CGFloat)y {
    CCNode* grayPeg = [CCBReader load:@"GrayPeg"];
    CGPoint location = CGPointMake(x, y);
    grayPeg.position = location;
    grayPeg.physicsBody.collisionType = @"grayPeg";
    grayPeg.visible=NO;
    grayPeg.zOrder=5;
    grayPeg.name=@"grayPeg";
    //greenPeg.physicsBody.sensor = TRUE; //if sensor is true it detects collision but doesn't react like objects
    [_physicsNode addChild:grayPeg];
}

-(void)printPegs {
    
    for (CCNode* greenPeg in _physicsNode.children){
        NSLog(@" x:%0.1f y:%0.1f tag:%@", greenPeg.position.x, greenPeg.position.y, greenPeg.name);
        
    }
}

-(void)changePegs {
    
    NSLog(@"start change pegs");
    
    
    for (int i = 0; i < _physicsNode.children.count; i++) {
        NSLog(@"i:%i",i);
        
        CCNode *node = [_physicsNode.children objectAtIndex:i];
        NSLog(@"name:%@",node.name);
        if ([node.name isEqual:@"grayPeg"]) {
            CCNode* greenPeg = [CCBReader load:@"GreenPeg"];
            
            greenPeg.position = node.position;
            greenPeg.physicsBody.collisionType = @"greenPeg";
            greenPeg.zOrder=5;
            greenPeg.name=@"greenPeg";
            //greenPeg.physicsBody.sensor = TRUE; //if sensor is true it detects collision but doesn't react like objects
            [_physicsNode addChild:greenPeg];
            [_physicsNode removeChild:node];
            break;
        }

    }
    /*
    
    for (CCNode* grayPeg in _physicsNode.children){
        CCNode* greenPeg = [CCBReader load:@"GreenPeg"];
        
        greenPeg.position = grayPeg.position;
        greenPeg.physicsBody.collisionType = @"greenPeg";
        greenPeg.zOrder=5;
        //greenPeg.physicsBody.sensor = TRUE; //if sensor is true it detects collision but doesn't react like objects
        [_physicsNode addChild:greenPeg];
        grayPeg.visible=NO;
        //[_physicsNode removeChild:grayPeg];
        

        
    }
    */
    
}

#pragma onTouch
- (void)launchBlock:(CGPoint)location {
    //cleanup: "launchBlock" should be named spawn ragdoll or maybe player. "ball" should also be renamed to ragdoll or maybe player...
    
    CCNode* ball = [CCBReader load:@"Ragdoll"];
    ball.position = location;
    ball.physicsBody.collisionType = @"ball";
    ball.zOrder=10;
    
    //NSLog(@"%@",ball.physicsBody.collisionType);
    
    [_physicsNode addChild:ball];
    //NSLog(@"%lu",(unsigned long)_physicsNode.children.count);
    _dollars=_dollars-_userAcquisitionCost;
    _dollarsScoreLabel.string = [NSString stringWithFormat:@"$%0.1f", _dollars]; //TODO: format so that the negative is before the $ or so it's red.
    

}



// called on every touch in this scene

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Received a touch");
    
    if (!isFPSLimited) {
    CGPoint location = [touch locationInNode:self];
    //NSLog(@"%@",NSStringFromCGPoint(location));
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(screen);
    //Bonus height.
    CGFloat height = CGRectGetHeight(screen);
    //NSLog(@"%0.2f, %0.2f",width,height);
    //location.x=location.x - height/2;
        
        if (!isTargetedTouch){
            //If not targeted touch, spawn ragdolls at the top of the screen, else, spawn from tap location.
            location.y=370; // TODO: NEED TO CHANGE THIS TO BE HEIGHT AND NOT HARD CODED TO 370.
        }

        
    NSLog(@"%@",NSStringFromCGPoint(location));
    [self launchBlock:location];
    }
    
    _impressions++;
    _playerCount++; //cleanup: delete?

    _installs=_impressions*_oddsToInstall;

    
    
    //_scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    _impressionsScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_impressions];
    _installsScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_installs];
    _viralityScoreLabel.string = [NSString stringWithFormat:@"%d", 0];
    /*
    _1DayScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    _3DayScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    _7DayScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    _30DayScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    _DAUScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    _ARPUScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    _LTVScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    _cpImpressionScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    _cpInstallScoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
     */
    
}

#pragma Update loop

- (void)update:(CCTime)delta {
    //_playerCountLabel.string = [NSString stringWithFormat:@"%1.0f", (CGFloat)_playerCount];
    
   
    
    //NSLog(@"%f",delta);
    
    
    _totalTime=_totalTime+delta;
    _currentDay = (_totalTime - fmodf(_totalTime, _timePerDay))/_timePerDay;
    
    //NSLog (@"%0.2f, %0.2f, %0.2f", (CGFloat)_totalTime, (CGFloat)_currentDay, (CGFloat)fmodf(_totalTime, _timePerDay));
    _FPS=1/delta;
    if (_FPS<11) {
        isFPSLimited=TRUE;
    }
    else {
        isFPSLimited=FALSE;
    }
   // NSLog(@"%0.3f %d",_FPS,isFPSLimited);

        if (_currentDay>=1){
            _1DayRetained=_installs*.4;
            _1DayScoreLabel.string = [NSString stringWithFormat:@"%1.0f", (CGFloat)_1DayRetained];
            
        }
        if (_currentDay>=3){
            _3DayRetained=_1DayRetained*.5;
            _3DayScoreLabel.string = [NSString stringWithFormat:@"%1.0f", (CGFloat)_3DayRetained];
        }
        if (_currentDay>=7) {
            _7DayRetained=_3DayRetained*.4;
            _7DayScoreLabel.string = [NSString stringWithFormat:@"%1.0f", (CGFloat)_7DayRetained];
        }
        if (_currentDay>=30) {
            _30DayRetained=_7DayRetained*.4;
            _30DayScoreLabel.string = [NSString stringWithFormat:@"%1.0f", (CGFloat)_30DayRetained];
        }
   
   if(_dollars >= 200){ 
        _level = _level +1;
        [self resetAll];
    }
    
}

#pragma Collisions


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ball:(CCNode *)ball greenPeg:(CCNode *)greenPeg {
    
    
    
    
    
    
    NSLog(@"Hit a ball");
    // load particle effect
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"HitGreen"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the ball position
    explosion.position = greenPeg.position;
    // add the particle effect to the same node the ball is on
    [greenPeg.parent addChild:explosion];
    
    return YES;
    

}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ball:(CCNode *)ball bottomBounds:(CCNode *)_bottomBounds {
   /*
    NSLog(@"Hit the bottom");
    // load particle effect
    
    if (!isFPSLimited) {
    
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"HitGreen"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the ball position
    explosion.position = ball.position;
    // add the particle effect to the same node the ball is on
    [ball.parent addChild:explosion];
    }
    */
    [self removeBall : ball];
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ball:(CCNode *)ball leftBounds:(CCNode *)_leftBounds {
    [self removeBall : ball];
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ball:(CCNode *)ball rightBounds:(CCNode *)_rightBounds {
    [self removeBall : ball];
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ball:(CCNode *)ball topBounds:(CCNode *)_topBounds {
    [self removeBall : ball];
    return TRUE;
}

 
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ball:(CCNode *)ball payBox:(CCNode *)payBox {
    
    _dollars=_dollars+10;//TODO use the value of the box instead of a hard coded value.
    _dollarsScoreLabel.string = [NSString stringWithFormat:@"$%0.1f", _dollars]; //TODO: format so that the negative is before the $ or so it's red.
    
    //TODO add a timer call back to the ragdoll to gain $ over time. See the targeted touch method for the example of the timer with a call back. I'd put that into the ragdoll class and then have a BOOL that toggles it on and off on collision. The nice thing about this is that once the ragdoll is removed, it would stop earning money.
    return TRUE;
}

-(void)removeBall : (CCNode*) ball {
    NSLog(@"removed: %lu",(unsigned long)_physicsNode.children.count);
    // NSLog(@"%@",bottomBounds.physicsBody.collisionType);
    [_physicsNode removeChild:ball cleanup:YES];
}

#pragma Buttons

-(void)ABTest {
    NSLog(@"AB Test Pressed");
    [self changePegs];
    

}

-(void)Analytics {
    NSLog(@"Analytics Pressed");
    if (isAnalyticsOn) {
        isAnalyticsOn=NO;
    }
    else {
        isAnalyticsOn=YES;
    }
    [self showScoreBoard:isAnalyticsOn];
    
}

-(void)ResetGame {
    [self resetAll];
}

-(void)TargetedTouch{
    
    //powerUp to enable targeted touch for a period of time
    
    //spawn ragdoll at location of tap

    isTargetedTouch=TRUE;
    
    
    //now reset it back to the top of the screen after time
    double delayInMilliseconds = 1500.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInMilliseconds * NSEC_PER_MSEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // callback invocation
        isTargetedTouch=FALSE;
    });
}

@end


/*
 green pegs = money = AB monetization
 blue pegs = force up = retention = AB retention
 social power up = free players.
 
 use 1,3,7,30 to scale monetization and retention.
 
 ----
 
 Make a money box.
 money box can have various values.
 When ragdoll collides with money box they generate that revenue every second until removed.
 
 -----
 
 Possible GAME OVER events
 Dollars go below zero
 
 */


