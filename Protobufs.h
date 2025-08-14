#import <Foundation/Foundation.h>

@interface PBDataWriter : NSObject
-(void)writeDouble:(double)value forTag:(unsigned short)tag ;
-(void)writeUint64:(unsigned long long)value forTag:(unsigned short)tag ;
-(void)writeSfixed32:(int)value forTag:(unsigned short)tag ;
-(void)writeInt64:(long long)value forTag:(unsigned short)tag ;
-(void)writeBigEndianFixed16:(unsigned short)value ;
-(void)writeUint8:(unsigned char)value ;
-(void)writeBigEndianFixed32:(unsigned)value ;
-(void)writeBigEndianShortThenString:(id)value ;
-(void)writeProtoBuffer:(id)value ;
-(void)writeInt8:(char)value ;
-(void)writeSint64:(long long)value forTag:(unsigned short)tag ;
-(void)writeFixed64:(unsigned long long)value forTag:(unsigned short)tag ;
-(void)writeSfixed64:(long long)value forTag:(unsigned short)tag ;
-(void)writeData:(id)value forTag:(unsigned short)tag ;
-(void)writeUint32:(unsigned)value forTag:(unsigned short)tag ;
-(void)writeTag:(unsigned short)value andType:(unsigned char)tag ;
-(void)writeBareVarint:(unsigned long long)value ;
-(void)writeString:(id)value forTag:(unsigned short)tag ;
-(void)writeBOOL:(char)value forTag:(unsigned short)tag ;
-(void)writeFixed32:(unsigned)value forTag:(unsigned short)tag ;
-(void)writeFloat:(float)value forTag:(unsigned short)tag ;
-(void)writeInt32:(int)value forTag:(unsigned short)tag ;
-(void)writeSint32:(int)value forTag:(unsigned short)tag ;
-(char)writeData:(id)value ;
-(id)data;
@end

@interface PBCodable : NSObject
{
}

- (id)dictionaryRepresentation;
- (void)writeTo:(id)arg1;
- (BOOL)readFrom:(id)arg1;
@property(readonly, nonatomic) NSData *data; // @dynamic data;
- (id)initWithData:(id)arg1;
- (id)init;

@end
@interface PBRequest : PBCodable
{
}

- (Class)responseClass;
- (unsigned int)requestTypeCode;

@end