//
//  PDFSelectionDelegate.m
//  PaperReader
//
//  Created by Sun Liuyi on 11-8-31.
//  Copyright 2011年 Netease.com Inc. All rights reserved.
//

#import "PDFSelectionDelegate.h"
#import "ASIHTTPRequest.h"
#import "WebKit/WebView.h"
#import "PDFKit/PDFSelection.h"

@implementation PDFSelectionDelegate
@synthesize selection,attachedWindow;
- (id)initWithPDFView:(PDFView *)aPDFView onWindow:(NSWindow *)aWindow
{
    self = [super init];
    if (self) {
        pdfView = [aPDFView retain];
        window = [aWindow retain];
        // Initialization code here.
        
        [NSEvent addLocalMonitorForEventsMatchingMask:NSLeftMouseUp|NSRightMouseUp handler:^(NSEvent *incomingEvent) {
            NSEvent *result = incomingEvent;
            mouseLocation =  [NSEvent mouseLocation];
            NSLog([result description]);
            return result;
        }];
    }
    
    return self;
}

-(void)selectionUpdated: (NSNotification *) notification
{
    NSString *newSelection = [[[pdfView currentSelection] string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
    
    if(newSelection!=nil && [newSelection compare:self.selection options:NSCaseInsensitiveSearch]!=NSOrderedSame){
        self.selection = newSelection;
        NSLog(@"notification: %@, selection: %@",notification,[[pdfView currentSelection] string]);
        [self fetchExplanation:self.selection];
    }
    
}

- (void)fetchExplanation:(NSString *)keyword
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dict.youdao.com/search?q=%@&doctype=xml",keyword]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"requestFinished :%@",responseString);
    NSView *view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    
    [self setupView:view forString:responseString];
    
    if(attachedWindow){
        NSLog(@"remove old attachedWindow");
        [window removeChildWindow:attachedWindow];
        [attachedWindow orderOut:self];
        [attachedWindow release];
        attachedWindow = nil;
        
    }
    
    
    CGRect frame = [window frame];
    CGPoint origin = frame.origin;
    
    attachedWindow = [[MAAttachedWindow alloc] initWithView:view 
                                            attachedToPoint:CGPointMake(200,300)
                                                   inWindow:window 
                                                     onSide:1 
                                                 atDistance:0];
    
    [attachedWindow setAlphaValue:0.7];
    
    [attachedWindow setBorderColor:[NSColor whiteColor]];
    //[textField setTextColor:[NSColor whiteColor]];
    [attachedWindow setBackgroundColor:[NSColor blackColor]];
    [attachedWindow setViewMargin:2];
    [attachedWindow setBorderWidth:2];
    [attachedWindow setCornerRadius:8];
    [attachedWindow setHasArrow:YES];
    [attachedWindow setDrawsRoundCornerBesideArrow:YES];
    
    [attachedWindow setArrowBaseWidth:20];
    [attachedWindow setArrowHeight:16];
    [window addChildWindow:attachedWindow ordered:NSWindowAbove];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"requestFailed %@, error: %@",request,error);
}

- (void) setupView:(NSView *)view forString:(NSString *)string
{
    NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithXMLString:string options:NSXMLDocumentTidyXML error:nil];
    NSXMLElement *root = [xmlDocument rootElement];
    /* extract query */
    NSArray *originalQueryNodes = [root elementsForName:@"original-query"];
    NSArray *returnPhraseNodes = [root elementsForName:@"return-phrase"];
    NSString *queryString = [returnPhraseNodes count] > 0 ? [[returnPhraseNodes objectAtIndex:0] stringValue] : [[originalQueryNodes objectAtIndex:0] stringValue];
    
    /* extract phonetic */
    NSArray *phoneticNodes = [root elementsForName:@"phonetic-symbol"];
    NSString *phonetic = [phoneticNodes count] > 0 ? [[phoneticNodes objectAtIndex:0] stringValue] : @"";
    
    /* extract translation */
    NSArray *translationNodes = [root elementsForName:@"custom-translation"];
    NSString *translation = [translationNodes count] > 0 ? [[translationNodes objectAtIndex:0] stringValue] : @"";
    
    NSString *htmlContent = [NSString stringWithFormat:@"<body style='background:black;color:white;font-family:helvetica'><h4>%@<span style='padding-left:20px;color:#ddd;font-size:12px'>[%@]</span></h4><p>%@</p></body>",queryString,phonetic,translation];
    
    WebView *webview = [[WebView alloc] initWithFrame:CGRectMake(16, 16, 288, 208) frameName:@"webview" groupName:@"attachedWindow"];
    [view addSubview:webview];
    [[webview mainFrame] loadHTMLString:htmlContent baseURL:nil];
    
}

@end
