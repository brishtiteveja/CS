//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "iCarouselExampleViewController.h"
#import "CoreHolder.h"
#import "AppDelegate.h"


@interface iCarouselExampleViewController () <UIActionSheetDelegate>

@property (nonatomic, assign) BOOL wrap;
@end


@implementation iCarouselExampleViewController

@synthesize categoryCarousel;
@synthesize pageCarousel;
@synthesize categoryCarouselType;
@synthesize pageCarouselType;
@synthesize categoryTypeChanged;
@synthesize pageTypeChanged;
@synthesize navItem;
@synthesize orientationBarItem;
@synthesize wrapBarItem;
@synthesize wrap;
@synthesize user_id;
@synthesize categoryItems;
@synthesize pageItems;
@synthesize categoryIDs;
@synthesize pageIDs;
@synthesize categoryCount;
@synthesize pageCount;
@synthesize dbm;

- (void)getCategoryItems
{
    categoryItems = [dbm getCategoryNamesWithUserID: user_id];
    if([categoryItems count] != 0)
        categoryCount = [dbm getMaxCategoryNumber];
    else
        categoryCount = 0;
    
    categoryIDs = [dbm getCategoryIDsWithUserID: user_id];
    NSLog(@"Category IDs: %@", categoryIDs);
}

- (void)getPageITems:(NSUInteger)category_id
{
    pageItems = [dbm getPageNamesWithUserID: user_id CategoryID: category_id];
    if([pageItems count] != 0){
        pageCount = [dbm getMaxPageNumberWithCategoryID: category_id];
    }else{
        pageCount = 0;
    }
    pageIDs = [dbm getPageIDsWithUserID: user_id CategoryID: category_id];
    NSLog(@"Page IDs: %@", pageIDs);
}

- (void)setUp
{
    //set up data
    wrap = YES;
    self.categoryItems = [NSMutableArray array];
    self.pageItems = [NSMutableArray array];
    
    //set the user id
    user_id = 1;

    
    //Database manager instance
    dbm = [DBManager getSharedInstance];
    
    [self getCategoryItems];
    
    NSInteger category_id = categoryCarousel.currentItemIndex + 1;//[categoryIDs[0] intValue];

    [self getPageITems:category_id];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    categoryCarousel.delegate = nil;
    categoryCarousel.dataSource = nil;
    pageCarousel.delegate = nil;
    pageCarousel.dataSource = nil;
    [categoryIDs release];
    [categoryItems release];
    [dbm release];
    [super dealloc];
    
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set carousel type
    categoryCarouselType = iCarouselTypeWheel;
    pageCarouselType = iCarouselTypeInvertedTimeMachine;
    
    //configure carousel
    categoryCarousel.type = categoryCarouselType;
    pageCarousel.type = pageCarouselType;
//    navItem.title = @"CoverFlow2";
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.categoryCarousel = nil;
    self.pageCarousel = nil;
    self.navItem = nil;
    self.orientationBarItem = nil;
    self.wrapBarItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)switchCategoryCarouselType
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Carousel Type"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Linear", @"Rotary", @"Inverted Rotary", @"Cylinder", @"Inverted Cylinder", @"Wheel", @"Inverted Wheel", @"CoverFlow", @"CoverFlow2", @"Time Machine", @"Inverted Time Machine", @"Custom", nil];
    categoryTypeChanged = true;
    [sheet showInView:self.view];
}

- (IBAction)switchPageCarouselType
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Page Carousel Type"
                                                      delegate:self
                                             cancelButtonTitle:@"cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Linear", @"Rotary", @"Inverted Rotary", @"Cylinder", @"Inverted Cylinder", @"Wheel", @"Inverted Wheel", @"CoverFlow", @"CoverFlow2", @"Time Machine", @"Inverted Time Machine", @"Custom", nil];
    
    
    pageTypeChanged = true;
    [sheet showInView:self.view];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                       reuseIdentifier:kCellIdentifier] autorelease];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        
//        if ([indexPath section] == 0) {
//            UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
//            playerTextField.adjustsFontSizeToFitWidth = YES;
//            playerTextField.textColor = [UIColor blackColor];
//            if ([indexPath row] == 0) {
//                playerTextField.placeholder = @"example@gmail.com";
//                playerTextField.keyboardType = UIKeyboardTypeEmailAddress;
//                playerTextField.returnKeyType = UIReturnKeyNext;
//            }
//            else {
//                playerTextField.placeholder = @"Required";
//                playerTextField.keyboardType = UIKeyboardTypeDefault;
//                playerTextField.returnKeyType = UIReturnKeyDone;
//                playerTextField.secureTextEntry = YES;
//            }
//            playerTextField.backgroundColor = [UIColor whiteColor];
//            playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
//            playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
//            playerTextField.textAlignment = UITextAlignmentLeft;
//            playerTextField.tag = 0;
//            //playerTextField.delegate = self;
//            
//            playerTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
//            [playerTextField setEnabled: YES];
//            
//            [cell.contentView addSubview:playerTextField];
//            
//            [playerTextField release];
//        }
//    }
//    if ([indexPath section] == 0) { // Email & Password Section
//        if ([indexPath row] == 0) { // Email
//            cell.textLabel.text = @"Email";
//        }
//        else {
//            cell.textLabel.text = @"Password";
//        }
//    }
//    else { // Login button section
//        cell.textLabel.text = @"Log in";
//    }
//    return cell;
//}


- (IBAction)toggleOrientation
{
    //carousel orientation can be animated
    [UIView beginAnimations:nil context:nil];
    categoryCarousel.vertical = !categoryCarousel.vertical;
    pageCarousel.vertical = !pageCarousel.vertical;
    [UIView commitAnimations];
    
    //update button
    orientationBarItem.title = categoryCarousel.vertical? @"Vertical": @"Horizontal";
}

- (IBAction)toggleWrap
{
    wrap = !wrap;
    wrapBarItem.title = wrap? @"Wrap: ON": @"Wrap: OFF";
    [categoryCarousel reloadData];
}

- (IBAction)insertPageIntoCategory
{
    NSInteger index = MAX(0, pageCarousel.currentItemIndex);
    NSInteger category_id = [[categoryIDs objectAtIndex:categoryCarousel.currentItemIndex] intValue];
    //NSLog(@"%d",category_id);
    
    NSInteger page_id = [dbm getMaxPageNumberWithCategoryID:category_id] + 1;
    [pageCarousel insertItemAtIndex:index animated:YES];
    [dbm insertPageIntoCategoryWithUserID:user_id CategoryID:category_id PageID:page_id PageName:@"page" PageImageURL:@""];
    [pageIDs insertObject:@(page_id) atIndex:index];
}
- (IBAction)removePageFromCategory
{
    
}


- (IBAction)insertWorkbookCategory
{
    NSInteger index = MAX(0, categoryCarousel.currentItemIndex);
    
    categoryCount = [dbm getMaxCategoryNumber] + 1;
    
    [categoryItems insertObject:categoryItems[index] atIndex:index];
    [categoryCarousel insertItemAtIndex:index animated:YES];
    [dbm insertCategoryWithUserID:user_id CategoryID:categoryCount CategoryName:categoryItems[index]];
    [categoryIDs insertObject:@(categoryCount) atIndex:index];
}

- (IBAction)removeWorkbookCategory
{
    if (categoryCarousel.numberOfItems > 1)
    {
        NSInteger index = categoryCarousel.currentItemIndex;
        NSInteger idx = [categoryIDs[index] intValue];
        NSLog(@"%d",idx);
        [dbm removeCategoryWithUserID:user_id CategoryID:idx];
        [categoryItems removeObjectAtIndex:index];
        [categoryIDs removeObjectAtIndex:index];
        [categoryCarousel removeItemAtIndex:index animated:YES];
    }
}

#pragma mark -
#pragma mark UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0)
    {
        //map button index to carousel type
        iCarouselType type = buttonIndex;
        
        //carousel can smoothly animate between types
        [UIView beginAnimations:nil context:nil];
        if(categoryTypeChanged){
            categoryCarousel.type = type;
            categoryTypeChanged = false;
        }
        else if(pageTypeChanged){
            pageCarousel.type = type;
            pageTypeChanged = false;
        }else{
        
        }
        [UIView commitAnimations];
        
        //update title
//        navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if(carousel.type == categoryCarouselType)
        return [categoryItems count];
    else
        return [pageItems count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
 
    if(carousel.type == categoryCarouselType){
        //create new view if no view is available for recycling
        if (view == nil)
        {
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
            ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
            view.contentMode = UIViewContentModeCenter;
            label = [[UILabel alloc] initWithFrame:view.bounds];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            label.font = [label.font fontWithSize:50];
            label.tag = 1;
            [view addSubview:label];
        }
        else
        {
            //get a reference to the label in the recycled view
            label = (UILabel *)[view viewWithTag:1];
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = categoryItems[index];
        
        [label setFont:[UIFont fontWithName:@"Helvetica" size:25]];
    }else{
        //create new view if no view is available for recycling
        if (view == nil)
        {
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
            ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
            view.contentMode = UIViewContentModeCenter;
            label = [[UILabel alloc] initWithFrame:view.bounds];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            label.font = [label.font fontWithSize:50];
            label.tag = 1;
            [view addSubview:label];
        }
        else
        {
            //get a reference to the label in the recycled view
            label = (UILabel *)[view viewWithTag:1];
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = pageItems[index];
        
        [label setFont:[UIFont fontWithName:@"Helvetica" size:25]];
    }
    

    
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 100;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    if (carousel.type == categoryCarouselType) {
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
            ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
            view.contentMode = UIViewContentModeCenter;
            
            label = [[UILabel alloc] initWithFrame:view.bounds];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            label.font = [label.font fontWithSize:50.0f];
            label.tag = 1;
            [view addSubview:label];
        }
        else
        {
            //get a reference to the label in the recycled view
            label = (UILabel *)[view viewWithTag:1];
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = (index == 0)? @"[": @"]";
    }else{
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
            ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
            view.contentMode = UIViewContentModeCenter;
            
            label = [[UILabel alloc] initWithFrame:view.bounds];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            label.font = [label.font fontWithSize:50.0f];
            label.tag = 1;
            [view addSubview:label];
        }
        else
        {
            //get a reference to the label in the recycled view
            label = (UILabel *)[view viewWithTag:1];
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = (index == 0)? @"[": @"]";
    }
    
    
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * categoryCarousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (categoryCarousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            if(pageCarousel.type == iCarouselTypeCustom)
            {
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSNumber *item = (self.categoryItems)[index];
    NSLog(@"Tapped view number: %@", item);
    
    if(carousel.type == pageCarouselType){
//        CCDirector* director = [CCDirector sharedDirector];
//        
//        // Init the View Controller
//        
//        UINavigationController*  navController = [[UINavigationController alloc] initWithRootViewController:director];
//        navController.navigationBarHidden = YES;
//        
//        AppDelegate* app = (AppDelegate* )[[UIApplication sharedApplication] delegate];
//        [app.window addSubview:navController.view];
//        [app.window makeKeyAndVisible];
//        [app.window setRootViewController: navController];
//        
//        // startup
//        CoreHolder *core = [CoreHolder sharedCoreHolder];
//        [core firstStart];
    }else{
        //pageCarousel.dataSource = nil;
        NSInteger category_id = [categoryIDs[categoryCarousel.currentItemIndex] intValue];
        NSLog(@"category id:%d has been selected.", category_id);
        [self getPageITems:category_id];
        [pageCarousel reloadData];
    }
}

@end
