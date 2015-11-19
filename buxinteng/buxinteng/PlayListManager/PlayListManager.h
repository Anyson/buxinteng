//
//  PlayListManager.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/19.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayListItem.h"

@interface PlayListManager : NSObject

+ (PlayListManager *)sharedInstance;

- (void)loadData;
- (PlayListItem *)getRandomItem;
- (NSString *)getLrcText:(PlayListItem *)item;

- (BOOL)isPlayListEmpty;
- (void)like:(PlayListItem *)item;
- (void)dislike:(PlayListItem *)item;
- (void)hate:(PlayListItem *) item;

@end
