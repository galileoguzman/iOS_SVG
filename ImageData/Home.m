//
//  ViewController.m
//  ImageData
//
//  Created by Galileo Guzman on 5/2/16.
//  Copyright © 2016 Galileo Guzman. All rights reserved.
//

#import "Home.h"

@interface Home ()

@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // add gesture recognizer
    
    UITapGestureRecognizer *tapRecognizerOnImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnImageConteiner:)];
    [tapRecognizerOnImage setNumberOfTapsRequired:1];
    [tapRecognizerOnImage setDelegate:self];
    self.imgConteiner.userInteractionEnabled = YES;
    [self.imgConteiner addGestureRecognizer:tapRecognizerOnImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint location = [touch locationInView:touch.view];
//    
//    NSLog(@"Location X:%f & Y:%f", location.x, location.y);
//}

-(void)tappedOnImageConteiner:(UITapGestureRecognizer *)tap{
    
    CGPoint location = [tap locationInView:self.imgConteiner];
    
    UIColor *imgColor = [self.imgConteiner.image colorAtPixel:location];
    UIColor *toColor = [UIColor redColor];
    
//    NSLog(@"Image color : %@ & toColor : %@", imgColor, toColor);
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.imgConteiner.image = [self changeColor:self.imgConteiner.image fromColor:imgColor toColor:toColor];
//    });
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imgConteiner.image = [self replaceColor:imgColor inImage:self.imgConteiner.image withTolerance:255];
    });
    
    
    //self.imgConteiner.image = [self.imgConteiner.image imageTintedWithColor:[UIColor redColor]];
    
}


-(UIImage*)changeColor:(UIImage*)myImage fromColor:(UIColor*)fromColor toColor:(UIColor*)toColor{
    NSLog(@"Hola");
    CGImageRef originalImage    = [myImage CGImage];
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext  =
    CGBitmapContextCreate(NULL,CGImageGetWidth(originalImage),CGImageGetHeight(originalImage),
                          8,CGImageGetWidth(originalImage)*4,colorSpace,kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0,
                                                 CGBitmapContextGetWidth(bitmapContext),CGBitmapContextGetHeight(bitmapContext)),
                       originalImage);
    UInt8 *data          = CGBitmapContextGetData(bitmapContext);
    int numComponents    = 4;
    int bytesInContext   = CGBitmapContextGetHeight(bitmapContext) *
    CGBitmapContextGetBytesPerRow(bitmapContext);
    double redIn, greenIn, blueIn,alphaIn;
    CGFloat fromRed = 0.0,fromGreen = 0.0,fromBlue = 0.0,fromAlpha;
    CGFloat toRed = 0.0,toGreen = 0.0,toBlue = 0.0,toAlpha = 0.0;
    
    //Get RGB values of fromColor
    int fromCountComponents = CGColorGetNumberOfComponents([fromColor CGColor]);
    if (fromCountComponents == 4) {
        const CGFloat *_components = CGColorGetComponents([fromColor CGColor]);
        fromRed = _components[0];
        fromGreen = _components[1];
        fromBlue = _components[2];
        fromAlpha = _components[3];
    }
    
    
    //Get RGB values for toColor
    int toCountComponents = CGColorGetNumberOfComponents([toColor CGColor]);
    if (toCountComponents == 4) {
        const CGFloat *_components = CGColorGetComponents([toColor CGColor]);
        toRed   = _components[0]*255;
        toGreen = _components[1]*255;
        toBlue  = _components[2]*255;
        toAlpha = _components[3]*255;
    }
    
    
    //Now iterate through each pixel in the image..
    for (int i = 0; i < bytesInContext; i += numComponents) {
        //rgba value of current pixel..
        redIn    =   (double)data[i];
        greenIn  =   (double)data[i+1];
        blueIn   =   (double)data[i+2];
        alphaIn  =   (double)data[i+3];
        //now you got current pixel rgb values...check it curresponds with your fromColor
        if( redIn == fromRed && greenIn == fromGreen && blueIn == fromBlue && alphaIn != 0 ){
            //image color matches fromColor, then change current pixel color to toColor
            data[i]    =   toRed;
            data[i+1]  =   toGreen;
            data[i+2]  =   toBlue;
            data[i+3]  = toAlpha;
        }
    }
    CGImageRef outImage =   CGBitmapContextCreateImage(bitmapContext);
    myImage             =   [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return myImage;
}







- (UIImage *)replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance;
{
    CGImageRef imageRef = [image CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGColorRef cgColor = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    float r = components[0];
    float g = components[1];
    float b = components[2];
    //float a = components[3]; // not needed
    
    r = r * 255.0;
    g = g * 255.0;
    b = b * 255.0;
    
    const float redRange[2] = {
        MAX(r - (tolerance / 2.0), 0.0),
        MIN(r + (tolerance / 2.0), 255.0)
    };
    
    const float greenRange[2] = {
        MAX(g - (tolerance / 2.0), 0.0),
        MIN(g + (tolerance / 2.0), 255.0)
    };
    
    const float blueRange[2] = {
        MAX(b - (tolerance / 2.0), 0.0),
        MIN(b + (tolerance / 2.0), 255.0)
    };
    
    int byteIndex = 0;
    
    while (byteIndex < bitmapByteCount) {
        unsigned char red   = rawData[byteIndex];
        unsigned char green = rawData[byteIndex + 1];
        unsigned char blue  = rawData[byteIndex + 2];
        
        if (((red >= redRange[0]) && (red <= redRange[1])) &&
            ((green >= greenRange[0]) && (green <= greenRange[1])) &&
            ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {
            // make the pixel transparent
            //
            rawData[byteIndex] = 0;
            rawData[byteIndex + 1] = 0;
            rawData[byteIndex + 2] = 0;
            rawData[byteIndex + 3] = 0;
        }
        
        byteIndex += 4;
    }
    
    UIImage *result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    CGContextRelease(context);
    free(rawData);
    
    return result;
}


@end
