//
//  YGoodeDetailsCell.h
//  shopsN
//
//  Created by imac on 2016/12/14.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface YGoodeDetailsCell : BaseTableViewCell

@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSString *detail;

@property (nonatomic) BOOL isHead;

@end