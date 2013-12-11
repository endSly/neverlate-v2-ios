//
//  GSNanoStoreServiceCache.h
//  Neverlate
//
//  Created by Endika Gutiérrez Salas on 14/11/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import <NanoStore.h>
#import <TenzingCore/TenzingCore.h>
#import <TenzingCore/TenzingCore-RESTService.h>

@interface GSNanoStoreServiceCache : NSObject <TZRESTServiceCacheStore>

@property (nonatomic, strong) NSFNanoStore *nanoStore;

@end
