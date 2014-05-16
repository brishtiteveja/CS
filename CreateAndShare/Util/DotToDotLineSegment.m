// Copyright (c) 2012, HTW Berlin / Project HardMut
// (http://www.hardmut-projekt.de)
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
// * Neither the name of the HTW Berlin / INKA Research Group nor the names
//   of its contributors may be used to endorse or promote products derived
//   from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  DotToDotLineSegment.m
//  iDiary2
//
//  Created by Markus Konrad on 30.01.12.
//  Copyright (c) 2012 INKA Forschungsgruppe. All rights reserved.
//

#import "DotToDotLineSegment.h"

@implementation DotToDotLineSegment

@synthesize num;
@synthesize line;
@synthesize point;
@synthesize lineDrawn;

-(id)initLineSegmentWithNum:(int)n lineSpriteFile:(NSString *)f pointSprite:(CCSprite *)p progressDirection:(CCProgressTimerType)dir {
    self = [super init];
    
    if (self) {
        num = n;
        line = [[CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:f]] retain];
        [line setType:dir];
        point = [p retain];
        lineDrawn = NO;
    }
    
    return self;
}

-(void)dealloc {
    [line release];
    [point release];

    [super dealloc];
}

-(void)drawLine {
    NSLog(@"drawing line #%d", num);
    CCProgressTo *progressAction = [CCProgressFromTo actionWithDuration:kDotToDotLineDrawTime - ((line.percentage / 100.0f) * kDotToDotLineDrawTime)
                                                                   from:line.percentage to:100.0f];
    [line runAction:progressAction];
    
    lineDrawn = YES;
}

@end
