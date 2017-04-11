//
//  GameScene.m
//  Maatchee
//
//  Created by Giri Prahasta Putra on 7/24/14.
//  Copyright (c) 2014 Giri Putra. All rights reserved.
//

#define UP_KEY 126
#define DOWN_KEY 125
#define RIGHT_KEY 124
#define LEFT_KEY 123
#define SPACE_KEY 49

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * 180.0 / M_PI)

#define ARROW_WIDTH 200


#import "GameScene.h"
#import "GameOverScene.h"
#import "ArrowSprite.h"

@interface GameScene()
@property (nonatomic) NSMutableArray *arrowArr;
@property (nonatomic) NSMutableArray *arrowSpriteArr;
@property (nonatomic) NSMutableArray *arrowAnswerArr;
@property (nonatomic) NSMutableArray *arrowSpriteAnswerArr;

@property (nonatomic) SKNode* answerNodeParent;
@property (nonatomic) SKLabelNode* scoreNode;

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval elapsedTime;

@property (nonatomic) int rotatePos;
@property (nonatomic) int maxTime;
@property (nonatomic) int score;

@property (nonatomic) SKSpriteNode *timerSprite;

@property (nonatomic) BOOL keyDown;
@end

@interface NSMutableArray (MultidimensionalAdditions)
+(NSMutableArray *) arrayOfWidth:(NSInteger)width andHeight:(NSInteger) height;
- (id) initWithWidth:(NSInteger)width andHeight:(NSInteger)height;

@end

@implementation NSMutableArray (MultidimensionalAdditions)

+ (NSMutableArray *)arrayOfWidth:(NSInteger)width andHeight:(NSInteger)height{
    return [[self alloc]initWithWidth:width andHeight:height];
}

-(id)initWithWidth:(NSInteger)width andHeight:(NSInteger)height{
    if (self = [self initWithCapacity:height]) {
        for (int i = 0; i < height;i++) {
            NSMutableArray *inner = [[NSMutableArray alloc] initWithCapacity:width];
            for (int j = 0; j < width; j++) {
                [inner addObject:[NSNull null]];
            }
            [self addObject:inner];
        }
    }
    return self;
}
@end



@implementation GameScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
        self.keyDown = NO;
        
        self.rotatePos = 1;
        self.maxTime = 8;
        self.score = 0;
        
        // init number array
        self.arrowArr = [NSMutableArray arrayOfWidth:2 andHeight:2];
        [self setArrowArr:self.arrowArr AtRow:0 col:0 value:0];
        [self setArrowArr:self.arrowArr  AtRow:0 col:1 value:1];
        [self setArrowArr:self.arrowArr  AtRow:1 col:0 value:0];
        [self setArrowArr:self.arrowArr  AtRow:1 col:1 value:1];

        
        // init node array
        ArrowSprite *arrSpr1 = [ArrowSprite initSprite];
        ArrowSprite *arrSpr2 = [ArrowSprite initSprite];
        ArrowSprite *arrSpr3 = [ArrowSprite initSprite];
        ArrowSprite *arrSpr4 = [ArrowSprite initSprite];

        self.arrowSpriteArr = [NSMutableArray arrayOfWidth:2 andHeight:2];
        [self setArrowSpriteArr:self.arrowSpriteArr AtRow:0 col:0 value:arrSpr1];
        [self setArrowSpriteArr:self.arrowSpriteArr AtRow:0 col:1 value:arrSpr2];
        [self setArrowSpriteArr:self.arrowSpriteArr AtRow:1 col:0 value:arrSpr3];
        [self setArrowSpriteArr:self.arrowSpriteArr AtRow:1 col:1 value:arrSpr4];
        
        // init answer number array
        self.arrowAnswerArr = [NSMutableArray arrayOfWidth:2 andHeight:2];
        [self setArrowArr:self.arrowAnswerArr AtRow:0 col:0 value:0];
        [self setArrowArr:self.arrowAnswerArr AtRow:0 col:1 value:0];
        [self setArrowArr:self.arrowAnswerArr AtRow:1 col:0 value:0];
        [self setArrowArr:self.arrowAnswerArr AtRow:1 col:1 value:0];
        
        //init node answer array
        self.answerNodeParent = [SKNode node];
        self.answerNodeParent.position = CGPointMake(476+45, 400-100);
        [self addChild:self.answerNodeParent];
        
        ArrowSprite *arrSprAnswer1 = [ArrowSprite initSprite];
        ArrowSprite *arrSprAnswer2 = [ArrowSprite initSprite];
        ArrowSprite *arrSprAnswer3 = [ArrowSprite initSprite];
        ArrowSprite *arrSprAnswer4 = [ArrowSprite initSprite];
        
        self.arrowSpriteAnswerArr = [NSMutableArray arrayOfWidth:2 andHeight:2];
        [self setArrowSpriteArr:self.arrowSpriteAnswerArr AtRow:0 col:0 value:arrSprAnswer1];
        [self setArrowSpriteArr:self.arrowSpriteAnswerArr AtRow:0 col:1 value:arrSprAnswer2];
        [self setArrowSpriteArr:self.arrowSpriteAnswerArr AtRow:1 col:0 value:arrSprAnswer3];
        [self setArrowSpriteArr:self.arrowSpriteAnswerArr AtRow:1 col:1 value:arrSprAnswer4];
        
        // add to scene
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                
                // 1. Question
                
                // 1.1 Number
                NSNumber * value = [self getArrowArr:self.arrowArr AtRow:i col:j];
                int intValue = [value intValue];
                
                // 1.2 Sprite
                ArrowSprite *arrSpr = [self getArrowSpriteArr:self.arrowSpriteArr AtRow:i col:j];
                arrSpr.size = CGSizeMake(200, 200);
                arrSpr.position = CGPointMake((j*90) + 476 ,
                                              self.frame.size.height-(i*90) - 150);
                
                
                if (intValue == 0) {
                    [arrSpr showArrow:YES];
                }else{
                    [arrSpr showArrow:NO];
                }
                
                //add to scene
                [self addChild:arrSpr];
                
                
                // 2.Answer
                
                // 2.1 Sprite
                ArrowSprite *arrSprAnswer = [self getArrowSpriteArr:self.arrowSpriteAnswerArr AtRow:i col:j];
                arrSprAnswer.size = CGSizeMake(ARROW_WIDTH, ARROW_WIDTH);
                arrSprAnswer.position = CGPointMake((j*90) - 45,
                                                      -(i*90) + 45);
//                arrSprAnswer.position = CGPointMake(0,
//                                                    0);
                [self.answerNodeParent addChild:arrSprAnswer];
                
                if (intValue == 0) {
                    [arrSprAnswer showArrow:YES];
                }else{
                    [arrSprAnswer showArrow:NO];
                }
                
                
                

            }
        }
        
        
        // 3. HUD
        
        // 3.1 Timer
        self.timerSprite = [SKSpriteNode spriteNodeWithImageNamed:@"timer"];
        self.timerSprite.centerRect = CGRectMake(0, 0, self.timerSprite.size.width, self.timerSprite.size.height);
        self.timerSprite.position   = CGPointMake(0, self.frame.size.height-self.timerSprite.size.height);
        [self addChild:self.timerSprite];
        
        // 3.2 Score
        self.scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.scoreNode.text = [NSString stringWithFormat:@"%d",self.score ];
        self.scoreNode.color = [SKColor colorWithRed:0 green:0 blue:0 alpha:1];
        self.scoreNode.colorBlendFactor = 1;
        self.scoreNode.fontSize = 50;
        self.scoreNode.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height-150);
        [self addChild:self.scoreNode];
        
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        
        // Initalize everything
        // random number
        [self randomQuestion];
        
    }
    return self;
}


-(void)keyDown:(NSEvent *)theEvent{
    
    int keyCode = theEvent.keyCode;

    if (!self.keyDown) {
        switch (keyCode) {
            case UP_KEY:
            {
                [self flipAnswerY:YES];
                
                float currentYScale = self.answerNodeParent.yScale;
                float currentXScale = self.answerNodeParent.xScale;
                
                
                
                
                if (self.rotatePos == 1 ||
                    self.rotatePos == 3) {
                    SKAction *action = [SKAction scaleYTo:currentYScale*-1 duration:0.1 ];
                    [self.answerNodeParent runAction:[SKAction sequence:@[[SKAction runBlock:^{self.keyDown = YES;}],
                                                                          action,
                                                                          [SKAction runBlock:^{self.keyDown = NO;}]]]];
                }else{
                    SKAction *action = [SKAction scaleXTo:currentXScale*-1 duration:0.1 ];
                    [self.answerNodeParent runAction:[SKAction sequence:@[[SKAction runBlock:^{self.keyDown = YES;}],
                                                                          action,
                                                                          [SKAction runBlock:^{self.keyDown = NO;}]]]];
                }
                

            }
                
                break;
            case RIGHT_KEY:{
                [self rotateAnswerTimes:1 toRight:YES];
                
                //ubah posisi rotate
                if (self.rotatePos >= 4) {
                    self.rotatePos = 1;
                }else{
                    self.rotatePos = self.rotatePos+1;
                }
                
                
                SKAction *action = [SKAction rotateByAngle:DEGREES_TO_RADIANS(-90) duration:0.1];
                [self.answerNodeParent runAction:[SKAction sequence:@[[SKAction runBlock:^{self.keyDown = YES;}], action,[SKAction runBlock:^{
                    self.keyDown = NO;}]]]];
                
                //            [self setArrowSpriteArrView:self.arrowSpriteAnswerArr fromArrowArr:self.arrowAnswerArr];
                
            }
                
                
                
                break;
            case DOWN_KEY:{
                [self flipAnswerY:YES];
                
                float currentYScale = self.answerNodeParent.yScale;
                float currentXScale = self.answerNodeParent.xScale;
                
                
                
                
                if (self.rotatePos == 1 ||
                    self.rotatePos == 3) {
                    SKAction *action = [SKAction scaleYTo:currentYScale*-1 duration:0.1 ];
                    [self.answerNodeParent runAction:[SKAction sequence:@[[SKAction runBlock:^{self.keyDown = YES;}],
                                                                          action,
                                                                          [SKAction runBlock:^{self.keyDown = NO;}]]]];
                }else{
                    SKAction *action = [SKAction scaleXTo:currentXScale*-1 duration:0.1 ];
                    [self.answerNodeParent runAction:[SKAction sequence:@[[SKAction runBlock:^{self.keyDown = YES;}],
                                                                          action,
                                                                          [SKAction runBlock:^{self.keyDown = NO;}]]]];
                }            }
                
                break;
            case LEFT_KEY:{
                
                //ubah posisi rotate
                if (self.rotatePos <= 1) {
                    self.rotatePos = 4;
                }else{
                    self.rotatePos = self.rotatePos-1;
                }
                
                [self rotateAnswerTimes:1 toRight:NO];
                
                SKAction *action = [SKAction rotateByAngle:DEGREES_TO_RADIANS(90) duration:0.1];
                [self.answerNodeParent runAction:[SKAction sequence:@[[SKAction runBlock:^{self.keyDown = YES;}], action,[SKAction runBlock:^{
                    self.keyDown = NO;}]]]];

            }
                
                break;
            case SPACE_KEY:
            {
                
                
                if ([self checkAnswer]) {
                    self.elapsedTime = 0;
                    [self randomQuestion];
                    NSLog(@"BENAR!");
                    
                    //add score
                    self.score++;
                    
                    //tambah kecepatan
                    
                    if (self.score >= 5 && self.score < 10) {
                        self.maxTime = 7;
                    }else if (self.score >= 10 && self.score < 20) {
                        self.maxTime = 5;
                    }else if (self.score >= 20 && self.score < 30) {
                        self.maxTime = 4;
                    }else if (self.score >= 30) {
                        self.maxTime = 3;
                    }
                    
                }else{
                    NSLog(@"SALAH!");
                    
                    self.elapsedTime += floor(self.maxTime*0.3);
                }
                //set text score
                self.scoreNode.text = [NSString stringWithFormat:@"%d",self.score ];
                
               
                
            }
                break;
            default:
                break;
        }

    }

    
}


-(void) setArrowArr:(NSMutableArray *)arrowArr AtRow:(NSInteger)row col:(NSInteger)col value:(int)number{
    [[arrowArr objectAtIndex:row]setObject:[NSNumber numberWithInt:number] atIndex:col];
}

-(NSNumber*) getArrowArr:(NSMutableArray *)arrowArr AtRow:(NSInteger)row col:(NSInteger)col{
    return [[arrowArr objectAtIndex:row]objectAtIndex:col];
}

-(void) setArrowSpriteArr:(NSMutableArray *)arrowSpriteArr AtRow:(NSInteger)row col:(NSInteger)col value:(ArrowSprite*)spriteNode{
    [[arrowSpriteArr objectAtIndex:row]setObject:spriteNode atIndex:col];
}

-(ArrowSprite*) getArrowSpriteArr:(NSMutableArray *)arrowSpriteArr AtRow:(NSInteger)row col:(NSInteger)col{
    return [[arrowSpriteArr objectAtIndex:row]objectAtIndex:col];
}

-(void)update:(NSTimeInterval)currentTime{
    CFTimeInterval timeSinceLast = currentTime-self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    

    if (self.elapsedTime == 0) {
        if (timeSinceLast < 1) {
            self.elapsedTime += timeSinceLast;
        }
    }else{
        self.elapsedTime += timeSinceLast;
    }

    
//    NSLog(@"elapsed time: %f ",self.elapsedTime);
    
    if (timeSinceLast > 1) {
        timeSinceLast = 1/60;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSincelastUpdate:timeSinceLast];
    
    float percentSpriteWidth = self.elapsedTime/self.maxTime;
    [self updateTimerSpriteWithPercent:percentSpriteWidth];
    
    

    
    
    
}

-(void)updateWithTimeSincelastUpdate:(CFTimeInterval)timeSinceLast{
 
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        
        NSLog(@"elapsed time: %f", self.elapsedTime);
        //check lose
        if (self.elapsedTime > self.maxTime) {
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            GameOverScene *gameOverScene = [[GameOverScene alloc]initWithSize:self.size score:self.score];
            [self.view presentScene:gameOverScene transition:reveal];
            
        }
    }
    
}

-(void)updateTimerSpriteWithPercent:(float)percent{
    SKSpriteNode *timerSprite = self.timerSprite;
    
    float size = percent*self.size.width;

    timerSprite.size = CGSizeMake(size*2, timerSprite.size.height);
}

-(void)flipAnswerY:(BOOL)yAxis{
    // temporary array
    NSMutableArray *tempArray = [NSMutableArray arrayOfWidth:2 andHeight:2];
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            
            NSNumber* value = [self getArrowArr:self.arrowAnswerArr AtRow:i col:j];
            int intValue = (int)[value integerValue];
            
            if (yAxis) {
                [self setArrowArr:tempArray AtRow:1-i col:j value:intValue];
            }
            
            
        }
    }
    
    
    // copy to initial array
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            NSNumber* value = [self getArrowArr:tempArray AtRow:i col:j];
            int intValue = (int)[value integerValue];
            
            if (intValue == 0) {
                [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:intValue];
            }else{
                if (yAxis) {
                    if (intValue == 2) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:4];
                    }else if (intValue == 4) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:2];
                    }else{
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:intValue];
                    }
                }else{
                    if (intValue == 1) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:3];
                    }else if (intValue == 3) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:1];
                    }else{
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:intValue];
                    }
                }
            }
        }
    }
}

-(void)rotateAnswerTimes:(int)times toRight:(BOOL)right{

    for (int k = 0; k < times; k++) {
        
        // temporary array
        NSMutableArray *tempArray = [NSMutableArray arrayOfWidth:2 andHeight:2];
        
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                NSNumber* value = [self getArrowArr:self.arrowAnswerArr AtRow:i col:j];
                int intValue = (int)[value integerValue];
                
                if (right) {
                    [self setArrowArr:tempArray AtRow:j col:1-i value:intValue];
                }else{
                    [self setArrowArr:tempArray AtRow:1-j col:i value:intValue];
                }
                
            }
        }
        
        
        // copy to initial array
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                NSNumber* value = [self getArrowArr:tempArray AtRow:i col:j];
                int intValue = (int)[value integerValue];
                
                if (right) {
                    if (intValue == 0) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:intValue];
                    }else if (intValue == 1) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:2];
                    }else if (intValue == 2) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:3];
                    }else if (intValue == 3) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:4];
                    }else if (intValue == 4) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:1];
                    }
                }else{
                    if (intValue == 0) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:intValue];
                    }else if (intValue == 1) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:4];
                    }else if (intValue == 4) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:3];
                    }else if (intValue == 3) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:2];
                    }else if (intValue == 2) {
                        [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:1];
                    }
                }
               

            }
        }

    }
    
    

}

-(void)setArrowSpriteArrView:(NSMutableArray *) arrowSpriteArr fromArrowArr:(NSMutableArray *) arrowArr{
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            
            // set arrow sprite answer
            ArrowSprite *arrowSpriteAnswer = [self getArrowSpriteArr:arrowSpriteArr AtRow:i col:j];
            [arrowSpriteAnswer showArrow:YES];
            NSNumber* value = [self getArrowArr:arrowArr AtRow:i col:j];
            int intValue = [value intValue];
            if (intValue == 0) {
                [arrowSpriteAnswer showArrow:NO];
            }else{
                [arrowSpriteAnswer showArrow:YES];
                [arrowSpriteAnswer setArrowDirection:intValue];
            }
            
        }
    }
}


-(void)randomQuestion{
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            
            float randomNumber = (arc4random() %100);
            float intRandomNumber = 0;
            if (randomNumber <= 50) {
                intRandomNumber = 0;
            }else{
                intRandomNumber = 1;
            }
            
            
            
            // set arrow sprite question
            ArrowSprite *arrowSprite = [self getArrowSpriteArr:self.arrowSpriteArr AtRow:i col:j];
            if (intRandomNumber == 0) {
                [arrowSprite showArrow:NO];
                [self setArrowArr:self.arrowArr AtRow:i col:j value:0];
            }else{
                [arrowSprite showArrow:YES];
             
                if (randomNumber <= 25) {
                    [arrowSprite setArrowDirection:1];
                    
                    [self setArrowArr:self.arrowArr AtRow:i col:j value:1];
                    
                }else if(randomNumber > 25 && randomNumber<= 50){
                    [arrowSprite setArrowDirection:2];
                    
                    [self setArrowArr:self.arrowArr AtRow:i col:j value:2];
                    
                }else if(randomNumber > 50 && randomNumber<= 75){
                    [arrowSprite setArrowDirection:3];
                    
                    [self setArrowArr:self.arrowArr AtRow:i col:j value:3];
                    
                }else if(randomNumber > 75){
                    [arrowSprite setArrowDirection:4];
                    
                    [self setArrowArr:self.arrowArr AtRow:i col:j value:4];
                    
                }
            }
            
            // set arrow sprite answer
            ArrowSprite *arrowSpriteAnswer = [self getArrowSpriteArr:self.arrowSpriteAnswerArr AtRow:i col:j];
            if (intRandomNumber == 0) {
                [arrowSpriteAnswer showArrow:NO];
                [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:0];
            }else{
                [arrowSpriteAnswer showArrow:YES];
                
                if (randomNumber <= 25) {
                    [arrowSpriteAnswer setArrowDirection:1];
                    
                    [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:1];
                    
                }else if(randomNumber > 25 && randomNumber<= 50){
                    [arrowSpriteAnswer setArrowDirection:2];
                    
                    [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:2];
                    
                }else if(randomNumber > 50 && randomNumber<= 75){
                    [arrowSpriteAnswer setArrowDirection:3];
                    
                    [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:3];
                }else if(randomNumber > 75){
                    [arrowSpriteAnswer setArrowDirection:4];
                    
                    [self setArrowArr:self.arrowAnswerArr AtRow:i col:j value:4];
                    
                }
            }
        }
    }
    
    //reset rotation of answer
    self.answerNodeParent.zRotation = 0;
    self.answerNodeParent.xScale = 1;
    self.answerNodeParent.yScale = 1;
    self.rotatePos = 1;
    
    //random rotate the answer
    float randomNumber = (arc4random() %4);
    [self rotateAnswerTimes:randomNumber toRight:YES];
    
    //random flip the answer
    float randomNumberFlip = (arc4random() %100);
    if (randomNumberFlip >= 50 && randomNumberFlip < 75) {
        NSLog(@"FLIP!");
        [self flipAnswerY:YES];
    }else if (randomNumberFlip >= 75) {
//        [self flipAnswerY:NO];
    }
    
    [self setArrowSpriteArrView:self.arrowSpriteAnswerArr fromArrowArr:self.arrowAnswerArr];
    
}

-(BOOL) checkAnswer{
    
    BOOL answerCorrect = YES;
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            
            NSNumber* value = [self getArrowArr:self.arrowArr AtRow:i col:j];
            int intValue = (int)[value integerValue];
            
            NSNumber* valueAnswer = [self getArrowArr:self.arrowAnswerArr AtRow:i col:j];
            int intValueAnswer = (int)[valueAnswer integerValue];
            
            if (intValue != intValueAnswer) {
                answerCorrect = NO;
            }
            
        }
    }
    
    
    
    return answerCorrect;
}

@end
