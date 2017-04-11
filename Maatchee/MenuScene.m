//
//  MenuScene.m
//  Maatchee
//
//  Created by Giri Prahasta Putra on 7/24/14.
//  Copyright (c) 2014 Giri Putra. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

#define UP_KEY 126
#define DOWN_KEY 125
#define RIGHT_KEY 124
#define LEFT_KEY 123
#define SPACE_KEY 49

@implementation MenuScene


-(id)initWithSize:(CGSize)size{
    if (self= [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
     
        
        SKSpriteNode *logoNode = [SKSpriteNode spriteNodeWithImageNamed:@"logo"];
        logoNode.position = CGPointMake(self.size.width/2, (self.size.height/2)+50);
        [self addChild:logoNode];
        
        SKSpriteNode *tutorialNode = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial"];
        tutorialNode.size = CGSizeMake(500, 130);
        tutorialNode.position = CGPointMake((self.size.width/2), 100);
        [self addChild:tutorialNode];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        myLabel.color = [SKColor colorWithRed:0 green:0 blue:0 alpha:1];
        myLabel.colorBlendFactor = 1;
        myLabel.text = @"@igrir 2014";
        myLabel.fontSize = 20;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       8);

        [self addChild:myLabel];
    }
    return self;
}

-(void)keyDown:(NSEvent *)theEvent{
   
    int keyCode = theEvent.keyCode;
    
    NSLog(@"%d", theEvent.keyCode);
    
    switch (keyCode) {
        case UP_KEY:
            NSLog(@"pressed up key");
            break;
            
        case SPACE_KEY:
            NSLog(@"pressed space key");
            
            [self showGame];
            
            break;
        default:
            break;
    }
}

-(void)showGame{
    SKTransition * reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * gameScene = [[GameScene alloc] initWithSize:self.size];
    [self.view presentScene:gameScene transition:reveal];
}


@end
