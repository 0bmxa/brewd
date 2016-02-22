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
//        fprintf(file, "%s <%s>[%d] %s\n",
//                formattedTimeStamp(), executableName, getpid(), message.UTF8String);
        fprintf(file, "%s", logString);
    }
    printf("%s", logString);
    
    fclose(file);
}


//const char* formattedTimeStamp()
NSString* formattedTimeStamp()
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
//    return timeStamp.UTF8String;
    return timeStamp;
}


//void dlog(NSString *message)
//{
//    const char *path = [@"~/Desktop/brewd.log" stringByExpandingTildeInPath].UTF8String;
//    FILE *file = fopen(path, "a+");
//    
//    if (file != NULL)
//    {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
//        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
//        
//        fprintf(file, "%s <brewd>[%d] %s\n", timeStamp.UTF8String, getpid(), message.UTF8String);
//    }
//    
//    fclose(file);
//}


@end
