//
//  GameOverScene.m
//  Maatchee
//
//  Created by Giri Prahasta Putra on 7/24/14.
//  Copyright (c) 2014 Giri Putra. All rights reserved.
//

#import "GameOverScene.h"
#import "MenuScene.h"

#define UP_KEY 126
#define DOWN_KEY 125
#define RIGHT_KEY 124
#define LEFT_KEY 123
#define SPACE_KEY 49

@implementation GameOverScene

-(id)initWithSize:(CGSize)size score:(int)score{
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
        scoreLabel.fontSize = 350;
        scoreLabel.color = [SKColor colorWithRed:0 green:0 blue:0 alpha:1];
        scoreLabel.colorBlendFactor = 1;
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:scoreLabel];
        
        
        
        
    }
    
    return self;
}

-(void)keyDown:(NSEvent *)theEvent{
    
    int keyCode = theEvent.keyCode;
    
    NSLog(@"%d", theEvent.keyCode);
    
    switch (keyCode) {
        case UP_KEY:
            break;
            
        case SPACE_KEY:{
            NSLog(@"pressed space key");
            
            [self runAction:[SKAction sequence:@[
                                                 [SKAction runBlock:^{
                SKTransition * transition = [SKTransition flipHorizontalWithDuration:0.5];
                MenuScene * menuScene = [[MenuScene alloc] initWithSize:self.size];
                [self.view presentScene:menuScene transition:transition];
            }]
                                                 ]]];
        }
            break;
        default:
            break;
    }
}

@end
