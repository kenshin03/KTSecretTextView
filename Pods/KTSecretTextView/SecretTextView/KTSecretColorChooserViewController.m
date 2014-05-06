//
//  KTSecretColorChooserViewController.m
//
//  Created by Kenny Tang on 4/29/14.
//  Copyright (c) 2014 Corgitoergosum. All rights reserved.
//

#import "KTSecretColorChooserViewController.h"

typedef NS_ENUM(NSUInteger, KTSecretDefaultColor)
{
    KTSecretDefaultColorEmeraldSea = 0,
    KTSecretDefaultColorHopscotch,
    KTSecretDefaultColorLavender,
    KTSecretDefaultColorBurst,
    KTSecretDefaultColorCupid,
    KTSecretDefaultColorPeony,
    KTSecretDefaultColorMidnight,
    KTSecretDefaultColorWhite
};

static NSString * const kKTSecretColorChooserViewControllerCellIdentifier = @"kKTSecretColorChooserViewControllerCellIdentifier";
static CGFloat const kKTSecretColorChooserViewControllerDefaultCellHeight = 380.0f;


@interface KTSecretColorChooserViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate
>

/**
 *  Collection view which holds each color as a cell.
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  Normal layout: each cell is wide as the screen bounds' width.
 */
@property (nonatomic, strong) UICollectionViewFlowLayout *defaultLayout;

/**
 *  Compressed layout: this is what makes the "rainbow" view. All cells resized to fit on the screen bounds' width.
 */
@property (nonatomic, strong) UICollectionViewFlowLayout *paletteLayout;

/**
 *  Long Press gesture recognizer toggles between the two layout modes.
 */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

/**
 *  Gesture recognizers for vertical swipes. Mainly for passing through to delegate.
 */
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUpGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDownGestureRecognizer;


/**
 *  The various cell sizes for each layout
 */
@property (nonatomic) CGSize defaultCellSize;
@property (nonatomic) CGSize paletteCellSize;

/**
 *  The currently selected cell size
 */
@property (nonatomic) CGSize currentCellSize;

/**
 *  Tap gesture recognizer decides whether to propagate tap gestures to a delegate.
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

/**
 *  Semi-transparent view that is displayed on a long press to indicate which color is being selected.
 */
@property (nonatomic, strong) UIView *hoverColorView;

/**
 *  NSDictionary of colors made available for selection
 */
@property (nonatomic, strong) NSDictionary *colorsDict;

/**
 *  Array of color names made available for selection
 */
@property (nonatomic, strong) NSDictionary *colorNamesDict;


@end



@implementation KTSecretColorChooserViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSubviewTree];
    [self constrainViews];
    
    [self setUpGestureRecognizers];
    
    self.currentCellSize = self.defaultCellSize;
    [self.collectionView reloadData];
    
}


- (void)loadView
{
    self.view = [self mainView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)setUpGestureRecognizers
{
    UIView *collectionView = self.collectionView;
    [collectionView addGestureRecognizer:self.longPressGestureRecognizer];
    [collectionView addGestureRecognizer:self.tapGestureRecognizer];
    [collectionView addGestureRecognizer:self.swipeUpGestureRecognizer];
    [collectionView addGestureRecognizer:self.swipeDownGestureRecognizer];
    
    [self.swipeUpGestureRecognizer requireGestureRecognizerToFail:self.longPressGestureRecognizer];
    [self.swipeDownGestureRecognizer requireGestureRecognizerToFail:self.longPressGestureRecognizer];
    
}

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    mainView.alpha = 0.9;
    mainView.clipsToBounds = YES;
    return mainView;
}

- (void)addSubviewTree
{
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.hoverColorView];
}

- (void)constrainViews
{
    NSDictionary *viewsDict = @{@"collectionView":self.collectionView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:viewsDict]];
    
}

#pragma mark - Private

#pragma mark - Private properties

- (UISwipeGestureRecognizer*) swipeUpGestureRecognizer
{
    if (!_swipeUpGestureRecognizer) {
        _swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpSwipe:)];
        _swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    }
    return _swipeUpGestureRecognizer;
}

- (UISwipeGestureRecognizer*) swipeDownGestureRecognizer
{
    if (!_swipeDownGestureRecognizer) {
        _swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDownSwipe:)];
        _swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    }
    return _swipeDownGestureRecognizer;
}


- (UICollectionViewFlowLayout*) defaultLayout
{
    if (!_defaultLayout){
        _defaultLayout = [UICollectionViewFlowLayout new];
        _defaultLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _defaultLayout.itemSize = self.defaultCellSize;
        _defaultLayout.minimumInteritemSpacing = 0.0f;
        _defaultLayout.minimumLineSpacing = 0.0f;
    }
    return _defaultLayout;
}

- (UICollectionViewFlowLayout*) paletteLayout
{
    if (!_paletteLayout){
        _paletteLayout = [UICollectionViewFlowLayout new];
        _paletteLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _paletteLayout.itemSize = self.paletteCellSize;
        _paletteLayout.minimumInteritemSpacing = 0.0f;
        _paletteLayout.minimumLineSpacing = 0.0f;
    }
    return _paletteLayout;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.defaultLayout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.clipsToBounds = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kKTSecretColorChooserViewControllerCellIdentifier];
    }
    return _collectionView;
}

- (NSDictionary*) colorsDict
{
    if (!_colorsDict){
        _colorsDict = @{
                        @(KTSecretDefaultColorWhite)        :   [UIColor whiteColor],
                        @(KTSecretDefaultColorEmeraldSea)   :   [UIColor colorWithRed:18.0f/255.0f green:133.0f/255.0f blue:116.0/255.0f alpha:1.0],
                        @(KTSecretDefaultColorHopscotch)    :   [UIColor colorWithRed:157.0f/255.0f green:105.0f/255.0f blue:183.0/255.0f alpha:1.0],
                        @(KTSecretDefaultColorLavender)     :   [UIColor colorWithRed:100.0f/255.0f green:57.0f/255.0f blue:144.0/255.0f alpha:1.0],
                        @(KTSecretDefaultColorBurst)        :   [UIColor colorWithRed:213.0f/255.0f green:100.0f/255.0f blue:12.0f/255.0f alpha:1.0],
                        @(KTSecretDefaultColorCupid)        :   [UIColor colorWithRed:157.0f/255.0f green:30.0f/255.0f blue:38.0f/255.0f alpha:1.0],
                        @(KTSecretDefaultColorPeony)        :   [UIColor colorWithRed:220.0f/255.0f green:72.0f/255.0f blue:99.0f/255.0f alpha:1.0],
                        @(KTSecretDefaultColorMidnight)     :  [UIColor colorWithRed:39.0f/255.0f green:36.0f/255.0f blue:32.0f/255.0f alpha:1.0]
                        };
    }
    return _colorsDict;
}

- (NSDictionary*) colorNamesDict
{
    if (!_colorNamesDict){
        _colorNamesDict = @{
                            @(KTSecretDefaultColorEmeraldSea)   :   NSLocalizedString(@"Emerald Sea", nil),
                            @(KTSecretDefaultColorHopscotch)    :   NSLocalizedString(@"Hopscotch", nil),
                            @(KTSecretDefaultColorLavender)     :   NSLocalizedString(@"Lavender", nil),
                            @(KTSecretDefaultColorBurst)        :   NSLocalizedString(@"Burst", nil),
                            @(KTSecretDefaultColorCupid)        :   NSLocalizedString(@"Cupid", nil),
                            @(KTSecretDefaultColorPeony)        :   NSLocalizedString(@"Peony", nil),
                            @(KTSecretDefaultColorMidnight)     :   NSLocalizedString(@"Midnight", nil),
                            @(KTSecretDefaultColorWhite)        :   NSLocalizedString(@"Default", nil)
                            };
    }
    return _colorNamesDict;
}

- (UILongPressGestureRecognizer*) longPressGestureRecognizer
{
    if (!_longPressGestureRecognizer) {
        _longPressGestureRecognizer = [UILongPressGestureRecognizer new];
        [_longPressGestureRecognizer addTarget:self action:@selector(handleLongPressGesture:)];
    }
    return _longPressGestureRecognizer;
}

- (UITapGestureRecognizer*) tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [UITapGestureRecognizer new];
        [_tapGestureRecognizer addTarget:self action:@selector(handleTapGesture:)];
    }
    return _tapGestureRecognizer;
}

- (CGSize) defaultCellSize
{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, kKTSecretColorChooserViewControllerDefaultCellHeight);
}

- (CGSize) paletteCellSize
{
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width)/[self.colorsDict count], kKTSecretColorChooserViewControllerDefaultCellHeight);
}

- (UIView*)hoverColorView
{
    if (!_hoverColorView) {
        _hoverColorView = [UIView new];
        
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        float hoverViewWidth = screenWidth/[self.colorsDict count];
        
        _hoverColorView.frame = CGRectMake(0, 0, hoverViewWidth, self.view.frame.size.height);
        _hoverColorView.backgroundColor = [UIColor lightTextColor];
        _hoverColorView.alpha = 0.4;
        _hoverColorView.hidden = YES;
    }
    return _hoverColorView;
}


#pragma mark - Initialization helpers

#pragma mark - Event handlers

- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self handleLongPressEnded:sender];
        
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        [self handleLongPressMoved:sender];
        
    }else {
        [self handleLongPressStarted:sender];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer*)sender
{
//    [self.delegate sec
}

#pragma mark - Long Press Activated handlers

- (void)handleLongPressEnded:(UILongPressGestureRecognizer*)sender
{
    self.currentCellSize = self.defaultCellSize;
    
    // find the selected color
    CGPoint locationInView = [sender locationInView:self.collectionView];
    NSIndexPath *selectedCellIndexPath = [self.collectionView indexPathForItemAtPoint:locationInView];
    UIColor *selectedColor = self.colorsDict[@(selectedCellIndexPath.item)];
    
    // change to default layout
    CGFloat selectedCellRectX = self.currentCellSize.width*selectedCellIndexPath.item+1;
    self.hoverColorView.hidden = YES;
    [self.collectionView setCollectionViewLayout:self.defaultLayout animated:YES];
    [self.collectionView scrollRectToVisible:CGRectMake(selectedCellRectX, 0, [[UIScreen mainScreen] bounds].size.width, 20.0f) animated:NO];
    
    // update delegate on selected color
    NSString *colorName = self.colorNamesDict[@(selectedCellIndexPath.item)];
    [self updateDelegateSelectedColor:selectedColor name:colorName];
}

- (void)handleLongPressStarted:(UILongPressGestureRecognizer*)sender
{
    // change to palette layout
    [self.collectionView setCollectionViewLayout:self.paletteLayout animated:YES];
}

- (void)handleLongPressMoved:(UILongPressGestureRecognizer*)sender
{
    // find the cell at touch point
    CGPoint locationInView = [sender locationInView:self.collectionView];
    NSIndexPath *hoverCellIndexPath = [self.collectionView indexPathForItemAtPoint:locationInView];
    UICollectionViewCell *colorCell = [self.collectionView cellForItemAtIndexPath:hoverCellIndexPath];
    
    // move hover view over cell at touch point
    self.hoverColorView.frame = colorCell.frame;
    self.hoverColorView.hidden = NO;
    
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // find the cell at touch point
    UICollectionViewCell *cell = [[self.collectionView visibleCells] firstObject];
    NSIndexPath *cellIndexPath = [self.collectionView indexPathForCell:cell];
    
    // use index to find color
    UIColor *selectedColor = self.colorsDict[@(cellIndexPath.item)];
    
    // update delegate on selected color
    NSString *colorName = self.colorNamesDict[@(cellIndexPath.item)];
    [self updateDelegateSelectedColor:selectedColor name:colorName];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.colorsDict count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kKTSecretColorChooserViewControllerCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.colorsDict[@(indexPath.item)];
    
    
    return cell;
}

#pragma mark - Long Press Ended helper

- (void)updateDelegateSelectedColor:(UIColor*)color name:(NSString*)name
{
    if ([self.delegate respondsToSelector:@selector(secretColorChooserViewController:didSelectColor:name:)]) {
        
        [self.delegate secretColorChooserViewController:self didSelectColor:color name:name];
    }
}


#pragma mark - UISwipeGestureRecognizer delegate methods

- (void)handleUpSwipe:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(secretColorChooserViewController:didSwipeUp:)]) {
        [self.delegate secretColorChooserViewController:self didSwipeUp:YES];
    }
}

- (void)handleDownSwipe:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(secretColorChooserViewController:didSwipeDown:)]) {
        [self.delegate secretColorChooserViewController:self didSwipeDown:YES];
    }
}


@end
