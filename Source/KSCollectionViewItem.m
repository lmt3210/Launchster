//
// KSCollectionViewItem.m
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

#import "KSCollectionViewItem.h"

// This interface section belongs in the header file, but moving it
// causes strange problems with clicking on some icons not triggering
// launchApplication
@interface KSCollectionViewItem ()

@property (strong) IBOutlet NSTextField *mDescriptionTextField;
@property (strong) IBOutlet NSButtonCell *mItemImageView;

@end

@implementation KSCollectionViewItem

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    if (representedObject !=nil)
    {
        [self.mDescriptionTextField setStringValue:
         [representedObject valueForKey:@"itemDescription"]];
        [self.mItemImageView
         setImage:[representedObject valueForKey:@"itemImage"]];
    }
    else
    {
        [self.mDescriptionTextField setStringValue:@"No Value"];
    }
}

@end
