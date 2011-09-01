//
//  LYPDFDocument.h
//  PaperReader
//
//  Created by Sun Liuyi on 11-8-31.
//  Copyright 2011年 Netease.com Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PDFKit/PDFDocument.h>
#import <PDFKit/PDFView.h>
#import "PDFSelectionDelegate.h"

@interface LYPDFDocument : NSDocument {
    NSData *data;
    PDFDocument *doc;
    PDFSelectionDelegate *selectionDelegate;
}

@property (nonatomic,retain) NSData *data;
@property (nonatomic,retain) PDFDocument *doc;

@end
