//
//  ForkForwarder.h
//  brewd
//
//  Created by Maximilian Heim on 28.01.16.
//  Copyright © 2016 mxa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forker : NSObject

+(pid_t)fork;

@end
