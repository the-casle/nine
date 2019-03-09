#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_BETWEEN_OR_EQUAL_TO(v, x)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending) && ([[[UIDevice currentDevice] systemVersion] compare:x options:NSNumericSearch] != NSOrderedDescending)

#define SYSTEM_VERSION_11 ([[[UIDevice currentDevice] systemVersion] compare:@"11" options:NSNumericSearch] != NSOrderedAscending) && ([[[UIDevice currentDevice] systemVersion] compare:@"12" options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_12 ([[[UIDevice currentDevice] systemVersion] compare:@"12" options:NSNumericSearch] != NSOrderedAscending) && ([[[UIDevice currentDevice] systemVersion] compare:@"13" options:NSNumericSearch] == NSOrderedAscending)

// Example
/*if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
    // code here
}

if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
    // code here
}
*/
