//
//  ORTexturedBackgroundView.m
//  Melia
//
//  Created by orta therox on 25/08/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ORTexturedBackgroundView.h"

@implementation ORTexturedBackgroundView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TiledBackground"]];
}

@end
