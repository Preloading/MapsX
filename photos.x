
%hook GEOVoltaireSearchProvider

-(void)requesterDidFinish:(id)result {
    NSLog(@"result class -> %@", NSStringFromClass([result class]));
    
    NSLog(@"search request -> %@", [result responseForRequest:[[GEORequester requests] objectAtIndex:0]]);
    return %orig;
}

%end