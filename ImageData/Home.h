//
//  ViewController.h
//  ImageData
//
//  Created by Galileo Guzman on 5/2/16.
//  Copyright © 2016 Galileo Guzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ColorAtPixel.h"

@interface Home : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgConteiner;

@end

