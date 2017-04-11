//
//  AppDelegate.m
//  Maatchee
//
//  Created by Giri Prahasta Putra on 7/24/14.
//  Copyright (c) 2014 Giri Putra. All rights reserved.
//

#import "AppDelegate.h"
#import "MyScene.h"
#import "MenuScene.h"

@import AVFoundation;

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    SKScene *scene = [MenuScene sceneWithSize:CGSizeMake(1024, 768)];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

//    self.skView.showsFPS = YES;
//    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
