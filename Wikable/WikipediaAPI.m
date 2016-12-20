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
NSString *articleBody = @"";
// GRAB THE SEARCH BAR TEXT!!!


+(void) searchWikipediaWith:(NSString *)searchTerm beginTaskWithCallbackBlock:(NSString* (^)(void))callbackBlock {
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
                
                articleBody = [articleDictionary objectForKey:@"extract"];
                NSLog(@"----ARTICLE BODY----->%@", articleBody);

                
                
                if(error!=nil) {
                    NSLog(@"json error:%@", error);
                }
            }
        }

    }];
    
    [fetchWiki resume];
    return articleBody;
}



@end
