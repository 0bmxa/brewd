//
//  DaemonManager.m
//  brewd
//
//  Created by Maximilian Heim on 28.01.16.
//  Copyright © 2016 mxa. All rights reserved.
//

#import "DaemonManager.h"
#import "unistd.h"

@implementation DaemonManager

+(pid_t)fork
{
    return fork();
}

@end
