
%hook GEOCountryConfiguration

- (id)defaultForKey:(NSString *)key defaultValue:(id)defaultValue {
    Class GEOResourcesClass = objc_getClass("GEOResources");
    if ([key isEqualToString:@"GEOVoltaireSearchAttributionManifestURL"]) {
        NSString *value = objc_getAssociatedObject(GEOResourcesClass, (void *)(uintptr_t)33);
        if (value) {
            NSRange HTTPSRange = [value rangeOfString:@"https://"];
            if (HTTPSRange.location != NSNotFound) value = [value stringByReplacingCharactersInRange:HTTPSRange withString:@"http://"];
            return value;
        }
    }
    else if ([key isEqualToString:@"GEOLocalizedCategoriesURL"]) {
        NSString *value = objc_getAssociatedObject(GEOResourcesClass, (void *)(uintptr_t)55);
        if (value) {
            NSRange HTTPSRange = [value rangeOfString:@"https://"];
            if (HTTPSRange.location != NSNotFound) value = [value stringByReplacingCharactersInRange:HTTPSRange withString:@"http://"];
            return value;
        }
    }
    return %orig;
}

%end

%hookf(char, _GEOResourcesReadFrom, id self, PBDataReader *reader) {
    unsigned startPos = [reader position];
    Class GEOResourcesClass = objc_getClass("GEOResources");
    while ([reader hasMoreData] && ![reader hasError]) {
        unsigned short tag = 0;
        char type = 0;
        [reader readTag:&tag andType:&type];
        if (tag == 33 || tag == 55) {
            NSString *value = [reader readString];
            if (value) objc_setAssociatedObject(GEOResourcesClass, (void *)(uintptr_t)tag, value, OBJC_ASSOCIATION_RETAIN);
        }
        else {
            [reader skipValueWithTag:tag andType:type];
        }
    }
    [reader setPosition:startPos];
    return %orig(self, reader);
}

%ctor {
    void *sym = MSFindSymbol(NULL, "_GEOResourcesReadFrom");
    %init(_GEOResourcesReadFrom=sym);
}