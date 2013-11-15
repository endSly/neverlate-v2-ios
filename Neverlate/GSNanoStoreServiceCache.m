//
//  GSNanoStoreServiceCache.m
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 14/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "GSNanoStoreServiceCache.h"

@implementation GSNanoStoreServiceCache

- (id)init
{
    self = [super init];
    if (self) {
        NSError *error;
        NSString *base = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *path = [NSString stringWithFormat:@"%@/service-cache.db", base];
        self.nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFPersistentStoreType path:path error:&error];
        [self.nanoStore openWithError:&error];

    }
    return self;
}

- (NSFNanoObject *)searchForURL:(NSURL *)url
{
    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:self.nanoStore];
    
    search.attribute = @"url";
    search.match = NSFEqualTo;
    search.value = url.absoluteString;
    
    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
    return searchResults.allValues.firstObject;
}

- (NSData *)RESTService:(TZRESTService *)service cachedResultForRequest:(NSURLRequest *)request
{
    NSFNanoObject *object = [self searchForURL:request.URL];
    return [object objectForKey:@"data"];
}

- (void)RESTService:(TZRESTService *)service
    saveResultCache:(NSData *)data
            request:(NSURLRequest *)request
           response:(NSURLResponse *)response
         expiration:(NSTimeInterval)expiration
{
    NSFNanoObject *object = [self searchForURL:request.URL] ?: [NSFNanoObject nanoObject];
    
    [object setObject:[NSDate dateWithTimeIntervalSinceNow:expiration] forKey:@"expiration"];
    [object setObject:request.URL.absoluteString forKey:@"url"];
    [object setObject:data forKey:@"data"];

    [self.nanoStore addObject:object error:nil];

}

@end
