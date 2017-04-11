//
//  ArrowSprite.m
//  Maatchee
//
//  Created by Giri Prahasta Putra on 7/24/14.
//  Copyright (c) 2014 Giri Putra. All rights reserved.
//

#import "ArrowSprite.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ArrowSprite()
@property (nonatomic) SKSpriteNode * arrow;
@property (nonatomic) SKSpriteNode * arrowBg;

@property (nonatomic) SKColor * prevColor;
@end

@implementation ArrowSprite

-(id)initWithImageNamed:(NSString *)name{
    if (self = [super initWithImageNamed:name]) {
        NSLog(@"ini arrow Sprite");
    }
    return self;
}

+(id)initSprite{
    ArrowSprite *arSprite = [[ArrowSprite alloc] init];
    
    NSLog(@"Init in arrow sprite");
    [arSprite initComponents];
    
    return arSprite;
}

-(void)initComponents{
    self.arrow   = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
    self.arrowBg = [SKSpriteNode spriteNodeWithImageNamed:@"arrow_bg"];
    
    [self addChild:self.arrowBg];
    [self addChild:self.arrow];
}

-(void)showArrow:(BOOL)show{
    [self.arrow setHidden:!show];
}

-(void)setArrowDirection:(int)direction{
    
    switch (direction) {
        case 1:
        {
            self.arrow.zRotation = DEGREES_TO_RADIANS(0);
        }
            break;
        case 2:
        {
            self.arrow.zRotation = DEGREES_TO_RADIANS(270);
        }
            break;
        case 3:
        {
            self.arrow.zRotation = DEGREES_TO_RADIANS(180);
        }
            break;
        case 4:
        {
            self.arrow.zRotation = DEGREES_TO_RADIANS(90);
        }
            break;
        default:
            break;
    }
    
}

@end
