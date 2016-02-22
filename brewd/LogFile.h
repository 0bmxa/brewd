//
//  LogFile.h
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogFile : NSObject

+(void)log:(NSString*)format, ...;
+(void)logFormat:(NSString*)format andArguments:(va_list)args;

@end
