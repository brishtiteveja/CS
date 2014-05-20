//
//  iCarouselExampleViewController.h
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "iCarousel.h"
#import "DBManager.h"



@interface iCarouselExampleViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
{
    NSMutableArray* items;
    NSMutableArray* categories;
    DBManager* dbm;
    
}

@property (nonatomic, strong) IBOutlet iCarousel *categoryCarousel;
@property (nonatomic, strong) IBOutlet iCarousel *pageCarousel;
@property (readonly) BOOL categoryTypeChanged;
@property (readonly) BOOL pageTypeChanged;
@property (nonatomic, strong) IBOutlet UINavigationItem *navItem;
@property (nonatomic, strong) IBOutlet UIBarItem *orientationBarItem;
@property (nonatomic, strong) IBOutlet UIBarItem *wrapBarItem;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray * categories;
@property (nonatomic, retain) DBManager* dbm;
@property (nonatomic, assign) NSUInteger user_id;

- (IBAction)switchPageCarouselType;
- (IBAction)switchCategoryCarouselType;
- (IBAction)toggleOrientation;
- (IBAction)toggleWrap;
- (IBAction)insertWorkbookCategory;
- (IBAction)removeWorkbookCategory;

@end
