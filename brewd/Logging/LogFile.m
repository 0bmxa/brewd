//
//  LogFile.m
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

#import "LogFile.h"

@implementation LogFile

NSString *path = @"~/Desktop/brewd.log";
const char *executableName = "brewd";

+(void)log:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);
    [LogFile logFormat:format andArguments:args];
    va_end(args);
}

+(void)logFormat:(NSString*)format andArguments:(va_list)args
{
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];

    const char *expandedPath = [path stringByExpandingTildeInPath].UTF8String;
    FILE *file = fopen(expandedPath, "a+");
    
    const char *logString = [NSString stringWithFormat:@"%@ <%s>[%d] %@\n", formattedTimeStamp(), executableName, getpid(), message].UTF8String;
    
    if (file != NULL)
    {
        fprintf(file, "%s", logString);
    }
    printf("%s", logString);
    
    fclose(file);
}


NSString* formattedTimeStamp()
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    return timeStamp;
}


@end
