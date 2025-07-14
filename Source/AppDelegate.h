//
// AppDelegate.h
// 
// Copyright (c) 2020-2025 Larry M. Taylor
//
// This software is provided 'as-is', without any express or implied
// warranty. In no event will the authors be held liable for any damages
// arising from the use of this software. Permission is granted to anyone to
// use this software for any purpose, including commercial applications, and to
// to alter it and redistribute it freely, subject to 
// the following restrictions:
//
// 1. The origin of this software must not be misrepresented; you must not
//    claim that you wrote the original software. If you use this software
//    in a product, an acknowledgment in the product documentation would be
//    appreciated but is not required.
// 2. Altered source versions must be plainly marked as such, and must not be
//    misrepresented as being the original software.
// 3. This notice may not be removed or altered from any source
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>    // For hotkey
#import <AppKit/AppKit.h>

#import "KSCollectionViewItem.h"
#import "LTVersionCheck.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    BOOL mMoveMode;
    NSString *mShowString;
    NSString *mHotkey;
    UInt32 mHotkeyId;
    UInt32 mHotKeyModifier;
    EventHotKeyRef mHotKeyRef;
    NSString *mCurrentList;
    
    // For application list
    NSMetadataQuery *mQuery;
    NSMutableArray *mAppList;
    
    // For version check
    LTVersionCheck *mVersionCheck;
    
    // For logging
    os_log_t mLog;
    
    IBOutlet NSPopUpButtonCell *mUiHotkey;
}

@property (strong) IBOutlet NSMutableArray *mContents;
@property (assign) IBOutlet NSCollectionView *mCollectionView;
@property (strong) IBOutlet KSCollectionViewItem *mCollectionViewItem;

- (IBAction)scanApplications:(id)sender;
- (IBAction)launchApplication:(id)sender;
- (IBAction)showActive:(id)sender;
- (IBAction)showInactive:(id)sender;
- (IBAction)showFavorites:(id)sender;
- (IBAction)selectMode:(id)sender;
- (IBAction)selectHotkey:(id)sender;

@end
