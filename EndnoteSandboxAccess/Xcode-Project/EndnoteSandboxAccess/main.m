//
//  main.m
//  EndnoteSandboxAccess
//
//  Created by hackerj on 08/02/16.
//  Copyright © 2016 ETH Zurich. All rights reserved.
//

// based on infos from:
// http://objcolumnist.com/2012/05/21/security-scoped-file-url-bookmarks/

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSError *error = nil;
        NSData *bookmarkData = nil;
        NSString *path = @"~/Library/Preferences/com.ThomsonResearchSoft.EndNote.plist";
        NSString *standardizedPath = [path stringByStandardizingPath];
        NSURL *prefsURL = [NSURL fileURLWithPath:standardizedPath];
        
        NSString *outfile = @"~/Library/Containers/com.microsoft.Word/Data/Library/Preferences/com.ThomsonResearchSoft.EndNote.securebookmarks.plist";
        NSString *fullOutFile = [outfile stringByStandardizingPath];
        
        // File must exist to be bookmarkable...
        // This won't work if the word container doesn't exist yet.
        [[NSFileManager defaultManager] createFileAtPath:fullOutFile
                                                contents:nil
                                              attributes:nil];
        
        bookmarkData = [prefsURL
                        bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope
                        includingResourceValuesForKeys:nil
                        relativeToURL:nil
                        error:&error];
        
        NSString *bookmarkDataString = [bookmarkData base64EncodedStringWithOptions:0];
        
        NSDictionary *bookmarkDict = @{ standardizedPath : bookmarkDataString };
        
        
        [bookmarkDict writeToFile:fullOutFile atomically:YES];
        
    }
    return 0;
}