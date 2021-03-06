//
//  YServiceFirstHeadView.h
//  shopsN
//
//  Created by imac on 2017/1/4.
//  Copyright © 2017年 联系QQ:1084356436. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWarnModel.h"

@protocol YServiceFirstHeadViewDelegate <NSObject>

-(void)getMore;

-(void)chooseWarnIndex:(NSInteger)index;

@end

@interface YServiceFirstHeadView : UICollectionReusableView

@property (strong,nonatomic) NSArray<YWarnModel*> *titleArr;

@property (weak,nonatomic) id<YServiceFirstHeadViewDelegate>delegate;

@end
