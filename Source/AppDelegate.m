//
// AppDelegate.m
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

#import "AppDelegate.h"
#import "ApplicationEntry.h"

#define UDKEY_APPLICATION_LIST   @"ApplicationList"
#define UDKEY_OPTIONS_LIST       @"OptionsList"

// This interface section belongs in the header file, but moving it
// causes strange problems with clicking on some icons not triggering
// launchApplication
@interface AppDelegate()

@property (strong) IBOutlet NSWindow *mWindow;
@property (strong) IBOutlet NSTextField *mListLabel;

@end

@implementation AppDelegate

@synthesize mListLabel;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.mContents = [[NSMutableArray alloc] init];
    self.mCollectionViewItem = [[KSCollectionViewItem alloc] init];
    mAppList = [[NSMutableArray alloc] init];
    mShowString = [[NSString alloc] init];
    mMoveMode = false;
    mHotkey = [[NSString alloc] init];
    mHotKeyRef = NULL;
    mCurrentList = [[NSString alloc] init];
    
    NSUserDefaults *userDefaults =
         [[NSUserDefaultsController sharedUserDefaultsController] values];

     if ([userDefaults valueForKey:UDKEY_APPLICATION_LIST] != nil)
     {
        NSArray *pathList = [userDefaults
                             valueForKey:UDKEY_APPLICATION_LIST];
         
        for (NSString *path in pathList)
        {
            NSRange pathRange = {0, [path length] - 2};
            NSString *appPath = [path substringWithRange:pathRange];
            NSRange showRange = {[path length] - 1, 1};
            NSString *show = [path substringWithRange:showRange];
             
            NSURL *url = [NSURL fileURLWithPath:appPath];
            [mAppList addObject:[[ApplicationEntry alloc]
                                  initWithPath:(NSString *)url withShow:show]];
         }
    }
    
    if ([userDefaults valueForKey:UDKEY_OPTIONS_LIST] != nil)
    {
        NSDictionary *options = [userDefaults valueForKey:UDKEY_OPTIONS_LIST];
        mHotkey = [options objectForKey:@"Hotkey"];
        mCurrentList = [options objectForKey:@"Current List"];
        
        if (mHotkey == nil)
        {
            mHotkey = @"None";
        }
        
        if (mCurrentList == nil)
        {
            mCurrentList = @"Active";
        }
    }
    
    [self updateDisplay];
    
    [mUiHotkey selectItemWithTitle:mHotkey];

    if ([mHotkey isEqualToString:@"⌥F1"])
    {
        mHotkeyId = kVK_F1;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F2"])
    {
        mHotkeyId = kVK_F2;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F3"])
    {
        mHotkeyId = kVK_F3;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F4"])
    {
        mHotkeyId = kVK_F4;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F5"])
    {
        mHotkeyId = kVK_F5;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F6"])
    {
        mHotkeyId = kVK_F6;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F7"])
    {
        mHotkeyId = kVK_F7;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F8"])
    {
        mHotkeyId = kVK_F8;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F9"])
    {
        mHotkeyId = kVK_F9;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F10"])
    {
        mHotkeyId = kVK_F10;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F11"])
    {
        mHotkeyId = kVK_F11;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"⌥F12"])
    {
        mHotkeyId = kVK_F12;
        mHotKeyModifier = optionKey;
    }
    else if ([mHotkey isEqualToString:@"F13"])
    {
        mHotkeyId = kVK_F13;
        mHotKeyModifier = 0;
    }
    else if ([mHotkey isEqualToString:@"F14"])
    {
        mHotkeyId = kVK_F14;
        mHotKeyModifier = 0;
    }
    else if ([mHotkey isEqualToString:@"F15"])
    {
        mHotkeyId = kVK_F15;
        mHotKeyModifier = 0;
    }
    else if ([mHotkey isEqualToString:@"F16"])
    {
        mHotkeyId = kVK_F16;
        mHotKeyModifier = 0;
    }
    else if ([mHotkey isEqualToString:@"F17"])
    {
        mHotkeyId = kVK_F17;
        mHotKeyModifier = 0;
    }
    else if ([mHotkey isEqualToString:@"F18"])
    {
        mHotkeyId = kVK_F18;
        mHotKeyModifier = 0;
    }
    else if ([mHotkey isEqualToString:@"F19"])
    {
        mHotkeyId = kVK_F19;
        mHotKeyModifier = 0;
    }
    else
    {
        mHotkeyId = 0;
        mHotKeyModifier = 0;
    }
    
    [self registerHotKey];
    
    // Set up logging
    mLog = os_log_create("com.larrymtaylor.Launchster", "AppDelegate");
    
    // Version check
    NSBundle *appBundle = [NSBundle mainBundle];
    NSDictionary *appInfo = [appBundle infoDictionary];
    NSString *appVersion =
        [appInfo objectForKey:@"CFBundleShortVersionString"];
    mVersionCheck = [[LTVersionCheck alloc] initWithAppName:@"Launchster"
                     withAppVersion:appVersion
                     withLogHandle:mLog withLogFile:@""];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    if (mHotKeyRef)
    {
        UnregisterEventHotKey(mHotKeyRef);
        mHotKeyRef = NULL;
    }
    
    [self updateDefaults];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:
    (NSApplication *)inSender
{
    return YES;
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app
{
    return TRUE;
}

- (void)registerHotKey
{
    if (mHotKeyRef)
    {
        UnregisterEventHotKey(mHotKeyRef);
        mHotKeyRef = NULL;
    }
    
    if (mHotkeyId != 0)
    {
        EventHotKeyID hotKeyID;
        EventTypeSpec eventType;
        eventType.eventClass = kEventClassKeyboard;
        eventType.eventKind = kEventHotKeyPressed;
    
        InstallApplicationEventHandler(&OnHotKeyEvent, 1, &eventType,
                                       (__bridge void *)self, NULL);
    
        hotKeyID.signature = 'htk1';
        hotKeyID.id = 1;
        OSStatus status = RegisterEventHotKey(mHotkeyId, mHotKeyModifier,
                                              hotKeyID,
                                              GetApplicationEventTarget(),
                                              0, &mHotKeyRef);
        
        if (status == eventHotKeyExistsErr)
        {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            NSString *msg =
                [NSString stringWithFormat:@"Hotkey %@ already in use!",
                 mHotkey];
            [alert setMessageText:msg];
            [alert setAlertStyle:NSAlertStyleCritical];
            [alert runModal];
            mHotkey = @"None";
            [mUiHotkey selectItemWithTitle:mHotkey];
        }
    }
}

OSStatus OnHotKeyEvent(EventHandlerCallRef nextHandler,
                       EventRef theEvent, void *userData)
{
    AppDelegate *ourSelf = (__bridge AppDelegate *)userData;
    [ourSelf.mWindow deminiaturize:ourSelf];
    [NSApp activateIgnoringOtherApps:YES];
    
    return noErr;
}

- (IBAction)scanApplications:(id)sender;
{
    [self doAppQuery];
    [self updateDefaults];
}

- (IBAction)launchApplication:(id)sender
{
    NSButton *item = (NSButton *)sender;
    NSImage *icon = item.image;
    
    for (ApplicationEntry *appEntry in mAppList)
    {
        if (appEntry.icon == icon)
        {
            if (mMoveMode == true)
            {
                appEntry.show = mShowString;
                [self updateDisplay];
                [self updateDefaults];
            }
            else
            {
                [[NSWorkspace sharedWorkspace]
                  launchApplication:appEntry.name];
                [self.mWindow miniaturize:self];
            }
            
            break;
        }
    }
}

- (IBAction)showActive:(id)sender
{
    if ([self.mContents count] > 0)
    {
        [self.mContents removeAllObjects];
    }
    
    for (ApplicationEntry *appEntry in mAppList)
    {
        if ([appEntry.show isEqualToString:@"A"])
        {
            NSRange stringRange = {0, MIN([appEntry.name length], 28)};
            NSString *appString =
                [appEntry.name substringWithRange:stringRange];
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:
                @[appString, appEntry.icon]
                forKeys:@[@"itemDescription", @"itemImage"]];
            [self.mContents addObject:dict];
        }
    }
    
    [self.mCollectionView setItemPrototype:self.mCollectionViewItem];
    [self.mCollectionView setContent:self.mContents];
    mCurrentList = @"Active";
    [mListLabel setStringValue:@"Active Applications"];
}

- (IBAction)showInactive:(id)sender
{
    if ([self.mContents count] > 0)
    {
        [self.mContents removeAllObjects];
    }
    
    for (ApplicationEntry *appEntry in mAppList)
    {
        if ([appEntry.show isEqualToString:@"I"])
        {
            NSRange stringRange = {0, MIN([appEntry.name length], 28)};
            NSString *appString =
                [appEntry.name substringWithRange:stringRange];
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:
                @[appString, appEntry.icon]
                forKeys:@[@"itemDescription", @"itemImage"]];
            [self.mContents addObject:dict];
        }
    }
    
    [self.mCollectionView setItemPrototype:self.mCollectionViewItem];
    [self.mCollectionView setContent:self.mContents];
    mCurrentList = @"Inactive";
    [mListLabel setStringValue:@"Inactive Applications"];
}

- (IBAction)showFavorites:(id)sender
{
    if ([self.mContents count] > 0)
    {
        [self.mContents removeAllObjects];
    }
    
    for (ApplicationEntry *appEntry in mAppList)
    {
        if ([appEntry.show isEqualToString:@"F"])
        {
            NSRange stringRange = {0, MIN([appEntry.name length], 28)};
            NSString *appString =
                [appEntry.name substringWithRange:stringRange];
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:
                @[appString, appEntry.icon]
                forKeys:@[@"itemDescription", @"itemImage"]];
            [self.mContents addObject:dict];
        }
    }
    
    [self.mCollectionView setItemPrototype:self.mCollectionViewItem];
    [self.mCollectionView setContent:self.mContents];
    mCurrentList = @"Favorites";
    [mListLabel setStringValue:@"Favorite Applications"];
}

- (IBAction)selectMode:(id)sender
{
    NSPopUpButton *button = (NSPopUpButton *)sender;
    NSInteger selection = [button indexOfSelectedItem];
    
    switch (selection)
    {
        case 1:
            mMoveMode = true;
            mShowString = @"F";
            break;
        case 2:
            mMoveMode = true;
            mShowString = @"A";
            break;
        case 3:
            mMoveMode = true;
            mShowString = @"I";
            break;
        case 0:
        default:
            mMoveMode = false;
            break;
    }
}

- (IBAction)selectHotkey:(id)sender
{
    NSPopUpButton *button = (NSPopUpButton *)sender;
    NSInteger buttonId = [button indexOfSelectedItem];
    
    switch (buttonId)
    {
        case 0:
        default:
            mHotkey = @"None";
            mHotkeyId = 0;
            mHotKeyModifier = 0;
            break;
        case 1:
            mHotkey = @"⌥F1";
            mHotkeyId = kVK_F1;
            mHotKeyModifier = optionKey;
            break;
        case 2:
            mHotkey = @"⌥F2";
            mHotkeyId = kVK_F2;
            mHotKeyModifier = optionKey;
            break;
        case 3:
            mHotkey = @"⌥F3";
            mHotkeyId = kVK_F3;
            mHotKeyModifier = optionKey;
            break;
        case 4:
            mHotkey = @"⌥F4";
            mHotkeyId = kVK_F4;
            mHotKeyModifier = optionKey;
            break;
        case 5:
            mHotkey = @"⌥F5";
            mHotkeyId = kVK_F5;
            mHotKeyModifier = optionKey;
            break;
        case 6:
            mHotkey = @"⌥F6";
            mHotkeyId = kVK_F6;
            mHotKeyModifier = optionKey;
            break;
        case 7:
            mHotkey = @"⌥F7";
            mHotkeyId = kVK_F7;
            mHotKeyModifier = optionKey;
            break;
        case 8:
            mHotkey = @"⌥F8";
            mHotkeyId = kVK_F8;
            mHotKeyModifier = optionKey;
            break;
        case 9:
            mHotkey = @"⌥F9";
            mHotkeyId = kVK_F9;
            mHotKeyModifier = optionKey;
            break;
        case 10:
            mHotkey = @"⌥F10";
            mHotkeyId = kVK_F10;
            mHotKeyModifier = optionKey;
            break;
        case 11:
            mHotkey = @"⌥F11";
            mHotkeyId = kVK_F11;
            mHotKeyModifier = optionKey;
            break;
        case 12:
            mHotkey = @"⌥F12";
            mHotkeyId = kVK_F12;
            mHotKeyModifier = optionKey;
            break;
        case 13:
            mHotkey = @"F13";
            mHotkeyId = kVK_F13;
            mHotKeyModifier = 0;
            break;
        case 14:
            mHotkey = @"F14";
            mHotkeyId = kVK_F14;
            mHotKeyModifier = 0;
            break;
        case 15:
            mHotkey = @"F15";
            mHotkeyId = kVK_F15;
            mHotKeyModifier = 0;
            break;
        case 16:
            mHotkey = @"F16";
            mHotkeyId = kVK_F16;
            mHotKeyModifier = 0;
            break;
        case 17:
            mHotkey = @"F17";
            mHotkeyId = kVK_F17;
            mHotKeyModifier = 0;
            break;
        case 18:
            mHotkey = @"F18";
            mHotkeyId = kVK_F18;
            mHotKeyModifier = 0;
            break;
        case 19:
            mHotkey = @"F19";
            mHotkeyId = kVK_F19;
            mHotKeyModifier = 0;
            break;
    }
    
    [self registerHotKey];
}

- (void)updateDisplay
{
    if ([mCurrentList isEqualToString:@"Inactive"])
    {
        [self showInactive:self];
    }
    else if ([mCurrentList isEqualToString:@"Favorites"])
    {
        [self showFavorites:self];
    }
    else
    {
        [self showActive:self];
    }
}

- (void)updateDefaults
{
    NSUserDefaults *userDefaults =
        [[NSUserDefaultsController sharedUserDefaultsController] values];
    NSMutableArray *pathList = [NSMutableArray array];

    for (ApplicationEntry *entry in mAppList)
    {
        NSString *path = [NSString stringWithFormat:@"%@:%@",
                          entry.path, entry.show];
        [pathList addObject:path];
    }

    [userDefaults setValue:pathList forKey:UDKEY_APPLICATION_LIST];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
        mHotkey, @"Hotkey",
        mCurrentList, @"Current List", nil];
    
    [userDefaults setValue:options forKey:UDKEY_OPTIONS_LIST];
}

-(void)doAppQuery
{
    mQuery = [[NSMetadataQuery alloc] init];
    NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"kMDItemKind == 'Application'"];

    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(queryDidFinishGathering:)
     name:NSMetadataQueryDidFinishGatheringNotification object:nil];
    [mQuery setPredicate:predicate];
    [mQuery startQuery];
}

-(void)queryDidFinishGathering:(NSNotification *)notification
{
    NSMutableArray *installedAppList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < mQuery.resultCount; i++ )
    {
        NSString *app = (NSString *)[[mQuery resultAtIndex:i]
                        valueForAttribute:(NSString *)kMDItemDisplayName];
        NSString *path = (NSString *)[[mQuery resultAtIndex:i]
                        valueForAttribute:(NSString *)kMDItemPath];
        NSArray *pathComponents = [path pathComponents];
        
        if ((([pathComponents[0] isEqualToString:@"/"] == YES) &&
            ([pathComponents[1] isEqualToString:@"Applications"] == YES)) ||
           (([pathComponents[0] isEqualToString:@"/"] == YES) &&
            ([pathComponents[1] isEqualToString:@"System"] == YES) &&
            ([pathComponents[2] isEqualToString:@"Applications"] == YES)) ||
           (([pathComponents[0] isEqualToString:@"/"] == YES) &&
            ([pathComponents[1] isEqualToString:@"Volumes"] == YES) &&
            ([pathComponents[3] isEqualToString:@"Applications"] == YES)))
        {
           ApplicationEntry *appEntry = [[ApplicationEntry alloc] init];
           appEntry.name = [app substringWithRange:
               NSMakeRange(0, app.length - 4)];
           appEntry.path =  path;
           appEntry.show = @"A";
           [installedAppList addObject:appEntry];
       }
    }
    
    NSMutableArray *tmpNameList = [[NSMutableArray alloc] init];
    
    for (ApplicationEntry *tmpAppEntry in installedAppList)
    {
        [tmpNameList addObject:tmpAppEntry.name];
    }
    
    NSArray<NSString *> *sortedNameList =
        [tmpNameList sortedArrayUsingSelector:@selector
         (localizedCaseInsensitiveCompare:)];
 
    NSMutableArray *sortedAppList = [[NSMutableArray alloc] init];
    
    for (NSString *sortedAppName in sortedNameList)
    {
        for (ApplicationEntry *installedAppEntry in installedAppList)
        {
            if ([sortedAppName isEqualToString:installedAppEntry.name])
            {
                for (ApplicationEntry *currentAppEntry in mAppList)
                {
                    if ((currentAppEntry.name != nil) &&
                        ([sortedAppName isEqualToString:currentAppEntry.name]))
                    {
                        installedAppEntry.show = [currentAppEntry.show copy];
                        break;
                    }
                }
    
                [sortedAppList addObject:installedAppEntry];
                break;
            }
        }
    }
   
    [mAppList removeAllObjects];

    for (ApplicationEntry *sortedAppEntry in sortedAppList)
    {
        NSURL *localURL = [NSURL fileURLWithPath:sortedAppEntry.path];
        
        ApplicationEntry *entry =
            [[ApplicationEntry alloc]
             initWithPath:(NSString *)localURL withShow:sortedAppEntry.show];
         [mAppList addObject:entry];
    }
    
    [self updateDisplay];
}

@end
