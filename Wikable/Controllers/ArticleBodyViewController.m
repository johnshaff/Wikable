//
//  ArticleBodyViewController.m
//  Wikable
//
//  Created by John D Hearn on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "ArticleBodyViewController.h"
#import "WikipediaAPI.h"
#import "LoremIpsum.h"

@interface ArticleBodyViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITextView *bodyText;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) NSString *articleBody;

@end

@implementation ArticleBodyViewController



-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

//    self.bodyText.text = kLoremIpsum;
    self.bodyText.editable = NO;
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureView];
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self configureView];
}



- (void)configureView
{
    NSLog(@"%@", [[UIApplication sharedApplication] preferredContentSizeCategory] );
    UIFont *myFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    self.bodyText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = searchBar.text;
    NSLog(@"-----SEARCH TERM----->%@", searchTerm);
    
//    [WikipediaAPI searchWikipediaWith:searchTerm withCompletion:^(NSString *articleBody) {
    
//        self.bodyText.text = articleBody;
//    }];
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
