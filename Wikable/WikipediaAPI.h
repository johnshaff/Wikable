//
//  WikipediaAPI.h
//  Wikable
//
//  Created by John Shaff on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^createArticleCompletion)(NSString * wikiText);

@interface WikipediaAPI : NSObject

+(NSString *) searchWikipediaWith:(NSString *)searchTerm;

+(void) searchWikipediaWith:(NSString *)searchTerm callback:(createArticleCompletion)createArticle;



@end
