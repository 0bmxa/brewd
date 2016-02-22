//
//  DaemonManager.m
//  brewd
//
//  Created by Maximilian Heim on 28.01.16.
//  Copyright © 2016 mxa. All rights reserved.
//

#import "DaemonManager.h"
#import "LogFile.h"
#import "unistd.h"
#import "sys/stat.h"
#import "brewd-Swift.h"

@interface DaemonManager ()

@property (nonatomic, strong) BrewManager *brewManager;

@end

@implementation DaemonManager

+(instancetype)sharedManager
{
    static DaemonManager *daemonManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        daemonManager = [[DaemonManager alloc] init];
    });
    return daemonManager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.brewManager = [[BrewManager alloc] init];
    }
    return self;
}


- (void)startDaemon
{
    startDaemon(self.brewManager);
}

Boolean daemonShouldStop = false;
- (void)stopDaemon
{
    daemonShouldStop = true;
}

void startDaemon(BrewManager *brewManager)
{
    pid_t processID = fork();
    pid_t sessionID;
    
    // -1 = child creating failed
    if (processID < 0)
    {
        [LogFile log:@"Could not fork off parent."];
        exit(EXIT_FAILURE);
    }
    // >0 = child successfully forked, we can exit safely
    else if (processID > 0)
    {
        [LogFile log:@"Starting daemon."];
        exit(EXIT_SUCCESS);
    }
    
    // Remove all file permissions
//    umask(0777);
    umask(0);
    
    // TODO: Create a log file ?
    
    sessionID = setsid();
    if(sessionID < 0)
    {
        [LogFile log:@"ERROR: chdir failed: %d", sessionID];
        exit(EXIT_FAILURE);
    }
    
    const char * path = "/";
    int chdirResult = chdir(path);
    if (chdirResult < 0)
    {
        [LogFile log:@"ERROR: chdir failed: %d", chdirResult];
        exit(EXIT_FAILURE);
    }
    
    
    // Close standard file descriptors
    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);
    
    
    while (true)
    {
        if(daemonShouldStop)
        {
            [LogFile log:@"Daemon stopped."];
            break;
        }
        
        [brewManager update];
        [LogFile log:@"Brew updated."];
        
        // Wait 1 hour
//        sleep(3600);
        sleep(60);
    }
    
    
    // Finito
    [LogFile log:@"Exit gracefully."];
    exit(EXIT_SUCCESS);
}

@end