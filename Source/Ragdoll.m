//
//  Ragdoll.m
//  GameOfStudios
//
//  Created by Cutsinger, Paul on 4/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Ragdoll.h"

@implementation Ragdoll

{
    //ragdoll parts
    CCNode* _ragdollTorso;
    CCNode* _ragdollLeftArm;
    CCNode* _ragdollRightArm;
    
    //left arm
    CCPhysicsJoint* _leftArmToTorso;
    //right arm
    CCPhysicsJoint* _rightArmToTorso;
    
    
}

-(id)init{
    self = [super init];
    
    if(self){
        CCLOG(@"Ragdoll init");
    }
    return self;
}

-(void)didLoadFromCCB
{
    CCLOG(@"Ragdoll didLoadFromCCB!!");
    
    //connect arms to Torso
    _leftArmToTorso = [CCPhysicsJoint connectedPivotJointWithBodyA:_ragdollLeftArm.physicsBody bodyB:_ragdollTorso.physicsBody anchorA:_ragdollLeftArm.anchorPointInPoints];
    _rightArmToTorso = [CCPhysicsJoint connectedPivotJointWithBodyA:_ragdollRightArm.physicsBody bodyB:_ragdollTorso.physicsBody anchorA:_ragdollRightArm.anchorPointInPoints];
    
    
    
    
}
/*
 -(void)applyForceToTorsoInDirection:(CGPoint)forceDirection withMagnitude:(float)mag
 {
 CGPoint force = ccpMult(forceDirection, mag);
 [_upperTorso.physicsBody applyForce:force];
 }
 
 */


@end
