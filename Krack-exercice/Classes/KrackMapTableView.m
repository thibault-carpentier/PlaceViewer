//
//  KrackMapTableView.m
//  ParseStarterProject
//
//  Created by Thibault Carpentier on 5/13/14.
//
//

#import "KrackMapTableView.h"

@implementation KrackMapTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Subclass to enable userInteraction with the map
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (point.y < 0) {
        return nil;
    }
    return hitView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
