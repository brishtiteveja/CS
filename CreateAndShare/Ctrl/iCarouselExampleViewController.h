//
//  iCarouselExampleViewController.h
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"



@interface iCarouselExampleViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *categoryCarousel;
@property (nonatomic, strong) IBOutlet iCarousel *pageCarousel;
@property (readonly) BOOL categoryTypeChanged;
@property (readonly) BOOL pageTypeChanged;
@property (nonatomic, strong) IBOutlet UINavigationItem *navItem;
@property (nonatomic, strong) IBOutlet UIBarItem *orientationBarItem;
@property (nonatomic, strong) IBOutlet UIBarItem *wrapBarItem;

- (IBAction)switchPageCarouselType;
- (IBAction)switchCategoryCarouselType;
- (IBAction)toggleOrientation;
- (IBAction)toggleWrap;
- (IBAction)insertWorkbookCategory;
- (IBAction)removeWorkbookCategory;

@end
