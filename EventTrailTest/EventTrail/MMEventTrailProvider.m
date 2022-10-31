//
//  MMEventTrailProvider.m
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import "MMEventTrailProvider.h"

static MMEventTrailPusher *eventTrailPusher = nil;
static id<MMEventTrailStore> eventTrailStore = nil;
static MMTrailEventCreator *trailEventCreator = nil;
static MMTrailCreator *trailCreator = nil;
static MMTrailEventPersister *trailEventPersister = nil;
static MMStartTrailPersister *trailPersister = nil;
static NSArray<id<MMEventTrailIntegration>> *integrations = nil;

@implementation MMEventTrailProvider


+ (MMEventTrailPusher *)sharedEventTrailPusher {
    if (eventTrailPusher == nil) {
        @synchronized (self) {
            if (eventTrailPusher == nil) {
                eventTrailPusher = [[MMEventTrailPusher alloc] init];
            }
        }
    }
    return eventTrailPusher;
}


+ (id<MMEventTrailStore>)sharedEventTrailStore {
    if (eventTrailStore == nil) {
        @synchronized (self) {
            if (eventTrailStore == nil) {
                eventTrailStore = [[MMSqliteEventTrailStore alloc] init];
            }
        }
    }
    return eventTrailStore;
}

+ (MMTrailEventCreator *)sharedTrailEventCreator {
    if (trailEventCreator == nil) {
        @synchronized (self) {
            if (trailEventCreator == nil) {
                MMTrailsHolder *holder = [[MMTrailsHolder alloc] init];
                trailEventCreator = [[MMTrailEventCreator alloc] initWithTrailsHolder:holder];
            }
        }
    }
    return trailEventCreator;
}

+ (MMTrailCreator *)sharedTrailCreator {
    if (trailCreator == nil) {
        @synchronized (self) {
            if (trailCreator == nil) {
                trailCreator = [[MMTrailCreator alloc] init];
            }
        }
    }
    return trailCreator;
}

+ (MMTrailEventPersister *)sharedTrailEventPersister {
    if (trailEventPersister == nil) {
        @synchronized (self) {
            if (trailEventPersister == nil) {
                trailEventPersister = [[MMTrailEventPersister alloc] initWithStore:[self sharedEventTrailStore]];
            }
        }
    }
    return trailEventPersister;
}

+ (MMStartTrailPersister *)sharedTrailPersister {
    if (trailPersister == nil) {
        @synchronized (self) {
            if (trailPersister == nil) {
                trailPersister = [[MMStartTrailPersister alloc] initWithStore:[self sharedEventTrailStore] trailEventCreator:[self sharedTrailEventCreator] trailEventPersister:[self sharedTrailEventPersister]];
            }
        }
    }
    return trailPersister;
}

+ (NSArray<id<MMEventTrailIntegration>> *)sharedIntegrations {
    if (integrations == nil) {
        @synchronized (self) {
            if (integrations == nil) {
                id<MMEventTrailIntegration> eventPushingScheduler = [[MMEventPushingScheduler alloc] initWithStore:[self sharedEventTrailStore] eventTrailPusher:[self sharedEventTrailPusher]];
                id<MMEventTrailIntegration> fireAndForgetOldEventPusher = [[MMFireAndForgetOldEventPusher alloc] initWithStore:[self sharedEventTrailStore] trailEventCreator:[self sharedTrailEventCreator] eventTrailPusher:[self sharedEventTrailPusher]];
                
                integrations = [NSArray arrayWithObjects:eventPushingScheduler, fireAndForgetOldEventPusher, nil];
            }
        }
    }
    return integrations;
}

@end
