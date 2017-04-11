//
//  ArrowSprite.h
//  Maatchee
//
//  Created by Giri Prahasta Putra on 7/24/14.
//  Copyright (c) 2014 Giri Putra. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ArrowSprite : SKSpriteNode
{
    
}

+(id)initSprite;
-(void)showArrow:(BOOL)show;
-(void)setArrowDirection:(int)direction;
@end
