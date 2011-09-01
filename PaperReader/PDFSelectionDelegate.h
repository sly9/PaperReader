//
//  PDFSelectionDelegate.h
//  PaperReader
//
//  Created by Sun Liuyi on 11-8-31.
//  Copyright 2011年 Netease.com Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PDFKit/PDFView.h>
#import "MAAttachedWindow.h"
@interface PDFSelectionDelegate : NSObject{
    PDFView *pdfView;
    NSString *selection;
    NSWindow *window;
    MAAttachedWindow *attachedWindow;
    NSPoint mouseLocation;
}

@property (nonatomic,retain) NSString *selection;
@property (nonatomic,retain) MAAttachedWindow *attachedWindow;

- (id)initWithPDFView:(PDFView *)aPDFView onWindow:(NSWindow *)aWindow;
-(void)selectionUpdated: (NSNotification *) notification;
- (void)fetchExplanation:(NSString *)keyword;
- (void) setupView:(NSView *)view forString:(NSString *)string;
@end
