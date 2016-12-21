//
//  WikipediaAPI.m
//  Wikable
//
//  Created by John Shaff on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "WikipediaAPI.h"


@interface WikipediaAPI ()

//@property(strong, nonatomic) NSString *articleBody;

@end


@implementation WikipediaAPI

NSString *baseURL = @"https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&titles=";
NSString *wikiText = @"";



+(void) searchWikipediaWith:(NSString *)searchTerm callback:(createArticleCompletion)createArticle {
    
    NSString *passThrough = searchTerm;
    NSString *fixedTerm = [passThrough stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *fixedTermWithBaseURL = [baseURL stringByAppendingString:fixedTerm];
    NSURL *fullURL = [NSURL URLWithString:fixedTermWithBaseURL];

    NSLog(@"%@", fullURL);

    NSURLSessionDataTask *fetchWiki = [[NSURLSession sharedSession] dataTaskWithURL:fullURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error!=nil) {
            NSLog(@"web service error:%@",error);
        } else {
            if(data !=nil) {
                NSDictionary *json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:NSJSONReadingMutableContainers
                                      error:&error];
                
                NSLog(@"------JASON DATA BEGINS--->%@", json);
                
                NSDictionary *queryDictionary = [json objectForKey:@"query"];
                NSLog(@"----QUERY DICTIONARY----->%@", queryDictionary);
                
                NSDictionary *pagesDictionary = [queryDictionary objectForKey:@"pages"];
                NSLog(@"----PAGES DICTIONARY----->%@", pagesDictionary);
                
                NSArray *uniqueKeyArray;
                uniqueKeyArray = pagesDictionary.allKeys;
                NSLog(@"----UNIQUE ARRAY----->%@", uniqueKeyArray);
                
                NSString *uniqueKey = uniqueKeyArray.firstObject;
                NSLog(@"-----WOOOW SO HACKY------>%@", uniqueKey);

                NSDictionary *articleDictionary = [pagesDictionary objectForKey:uniqueKey];
                NSLog(@"-----ARTICLE DICTIONARY------>%@", articleDictionary);
                
                wikiText = [articleDictionary objectForKey:@"extract"];
                NSLog(@"----ARTICLE BODY----->%@", wikiText);

                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    createArticleCompletion(wikiText);
                }];
                
                if(error!=nil) {
                    NSLog(@"json error:%@", error);
                }
            }
        }

    }];
    
    [fetchWiki resume];
}



@end
