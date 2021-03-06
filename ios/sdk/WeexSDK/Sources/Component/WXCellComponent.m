/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "WXSDKInstance.h"
#import "WXLog.h"
#import "WXCellComponent.h"
#import "WXListComponent.h"
#import "WXComponent_internal.h"

@implementation WXCellComponent
{
    NSIndexPath *_indexPathBeforeMove;
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    
    if (self) {
        _async = YES;
        _lazyCreateView = YES;
        _isNeedJoinLayoutSystem = NO;
    }
    
    return self;
}

- (void)dealloc
{
    
}

- (void)layoutDidFinish
{
    [self.list cellDidLayout:self];
}

- (WXDisplayCompeletionBlock)displayCompeletionBlock
{
    return ^(CALayer *layer, BOOL finished) {
        if ([super displayCompeletionBlock]) {
            [super displayCompeletionBlock](layer, finished);
        }
        
        [self.list cellDidRendered:self];
    };
}

- (void)moveToSuperview:(WXComponent *)newSupercomponent atIndex:(NSUInteger)index
{
    if (newSupercomponent == self.list) {
        [self.list cell:self didMoveToIndex:index];
    } else {
        [super moveToSuperview:newSupercomponent atIndex:index];
    }
}

- (void)removeFromSuperview
{
    [self.list cellDidRemove:self];
}

- (void)_calculateFrameWithSuperAbsolutePosition:(CGPoint)superAbsolutePosition gatherDirtyComponents:(NSMutableSet<WXComponent *> *)dirtyComponents
{
    if (isUndefined(self.cssNode->style.dimensions[CSS_WIDTH]) && self.list) {
        self.cssNode->style.dimensions[CSS_WIDTH] = self.list.scrollerCSSNode->style.dimensions[CSS_WIDTH];
    }
    
    if ([self needsLayout]) {
        layoutNode(self.cssNode, CSS_UNDEFINED, CSS_UNDEFINED, CSS_DIRECTION_INHERIT);
//        print_css_node(self.cssNode, CSS_PRINT_LAYOUT | CSS_PRINT_STYLE | CSS_PRINT_CHILDREN);
    }
    
    [super _calculateFrameWithSuperAbsolutePosition:superAbsolutePosition gatherDirtyComponents:dirtyComponents];
}
@end

