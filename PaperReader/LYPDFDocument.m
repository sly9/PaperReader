//
//  LYPDFDocument.m
//  PaperReader
//
//  Created by Sun Liuyi on 11-8-31.
//  Copyright 2011年 Netease.com Inc. All rights reserved.
//

#import "LYPDFDocument.h"

@implementation LYPDFDocument
@synthesize data,doc;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"LYPDFDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    NSLog(@"windowControllerDidLoadNib %@",[[[aController window] contentView] subviews]);    
    
    self.doc = [[PDFDocument alloc] initWithData:self.data];
    
    PDFView *_pdfView = [[[[aController window] contentView] subviews] objectAtIndex:0];
    [_pdfView setDocument: self.doc];

    
    //set selection delegate
    selectionDelegate = [[[PDFSelectionDelegate alloc] initWithPDFView:_pdfView onWindow:[aController window]] retain];
    [[NSNotificationCenter defaultCenter] addObserver: selectionDelegate selector: @selector(selectionUpdated:) 
                                                 name: PDFViewSelectionChangedNotification object: _pdfView];
//    NSWindow *window = [self windowForSheet];
//    NSLog([[[window contentView] subviews] description]);

    
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    /*
     Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    */
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return nil;
}

- (BOOL)readFromData:(NSData *)somedata ofType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"readFromData (%lu) bytes ofType %@",[somedata length],typeName);
    self.data = somedata;
    
    
    /*
    Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    */
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return YES;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

@end
