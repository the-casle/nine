#include "NINERootListController.h"
#include <spawn.h>
#include <signal.h>


@implementation NINERootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
    UIBarButtonItem *respringButton = [[UIBarButtonItem alloc]  initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
    respringButton.tintColor=[UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{[self.navigationItem setRightBarButtonItem:respringButton];}
                     completion:nil];
    [(UINavigationItem *)self.navigationItem setRightBarButtonItem:respringButton];
	return _specifiers;
}

-(void) respring{
    
    pid_t respringID;
    char *argv[] = {"/usr/bin/killall", "backboardd", NULL};
    posix_spawn(&respringID, argv[0], NULL, NULL, argv, NULL);
    waitpid(respringID, NULL, WEXITED);
    
    /*
    pid_t pid;
    int status;
    const char *argv[] = {"killall", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv, NULL);
    waitpid(pid, &status, WEXITED);
     */
}

@end


@interface NinePrefsCustomsController : HBRootListController
@end

@implementation NinePrefsCustomsController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Nine-Customs" target:self] retain];
    }
    [(UINavigationItem *)self.navigationItem setTitle:@"Customization"];
    return _specifiers;
}
@end
