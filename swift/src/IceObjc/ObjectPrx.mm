//
// Copyright (c) ZeroC, Inc. All rights reserved.
//

#import "ObjectPrx.h"

#import "Communicator.h"
#import "Connection.h"
#import "InputStream.h"
#import "OutputStream.h"
#import "Util.h"

@implementation ICEObjectPrx

-(ICEObjectPrx*) initWithObjectPrx:(ICEObjectPrx*)prx
{
    assert(prx);
    self = [super init];
    _prx = std::shared_ptr<Ice::ObjectPrx>([prx prx]);
    return self;
}

-(ICEObjectPrx*) initWithCppObjectPrx:(std::shared_ptr<Ice::ObjectPrx>)prx
{
    if(!prx)
    {
        return nil;
    }

    self = [super init];
    if(!self)
    {
        return nil;
    }

    self->_prx = prx;

    return self;
}

-(nonnull NSString*) ice_toString
{
    return toNSString(_prx->ice_toString());
}

-(ICECommunicator*) ice_getCommunicator
{
    auto comm = _prx->ice_getCommunicator().get();
    return [ICECommunicator fromLocalObject:comm];
}

-(void) ice_getIdentity:(NSString* __strong _Nonnull * _Nonnull)name
               category:(NSString* __strong _Nonnull * _Nonnull)category
{
    // TODO: verify that __strong does not leak back in Swift
    auto identity = _prx->ice_getIdentity();
    *name = toNSString(identity.name);
    *category = toNSString(identity.category);
}

-(instancetype) ice_identity:(NSString*)name
                    category:(NSString*)category
                       error:(NSError**)error
{
    try
    {
        auto prx = _prx->ice_identity(Ice::Identity{fromNSString(name), fromNSString(category)});
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(NSDictionary<NSString*, NSString*>*) ice_getContext
{
    return toNSDictionary(_prx->ice_getContext());
}

-(instancetype) ice_context:(NSDictionary<NSString*, NSString*>*)context
{
    Ice::Context ctx;
    fromNSDictionary(context, ctx);

    auto prx = _prx->ice_context(ctx);
    return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
}

-(NSString*) ice_getFacet
{
    return toNSString(_prx->ice_getFacet());
}

-(instancetype) ice_facet:(NSString*)facet
{
    auto prx = _prx->ice_facet(fromNSString(facet));
    return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
}

-(NSString*) ice_getAdapterId
{
    return toNSString(_prx->ice_getAdapterId());
}

-(instancetype) ice_adapterId:(NSString*)id error:(NSError**)error
{
    try
    {
        auto prx = _prx->ice_adapterId(fromNSString(id));
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(NSArray<ICEEndpoint*>*) ice_getEndpoints
{
    return toNSArray(_prx->ice_getEndpoints());
}

-(instancetype) ice_endpoints:(NSArray<ICEEndpoint*>*)endpoints error:(NSError**)error
{
    try
    {
        Ice::EndpointSeq endpts;
        fromNSArray(endpoints, endpts);

        auto prx = _prx->ice_endpoints(endpts);
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(int32_t) ice_getLocatorCacheTimeout
{
    return _prx->ice_getLocatorCacheTimeout();
}

-(instancetype) ice_locatorCacheTimeout:(int32_t)timeout error:(NSError**)error
{
    try
    {
        auto prx = _prx->ice_locatorCacheTimeout(timeout);
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(int32_t) ice_getInvocationTimeout
{
    return _prx->ice_getInvocationTimeout();
}

-(instancetype) ice_invocationTimeout:(int32_t)timeout error:(NSError**)error
{
    try
    {
        auto prx = _prx->ice_invocationTimeout(timeout);
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(NSString*) ice_getConnectionId
{
    return toNSString(_prx->ice_getConnectionId());
}

-(instancetype) ice_connectionId:(NSString*)connectionId error:(NSError**)error
{
    try
    {
        auto prx = _prx->ice_connectionId(fromNSString(connectionId));
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(bool) ice_isConnectionCached
{
    return _prx->ice_isConnectionCached();
}

-(instancetype) ice_connectionCached:(bool)cached error:(NSError**)error
{
    try
    {
        auto prx = _prx->ice_connectionCached(cached);
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(uint8_t) ice_getEndpointSelection
{
    return static_cast<uint8_t>(_prx->ice_getEndpointSelection());
}

-(instancetype) ice_endpointSelection:(uint8_t)type error:(NSError**)error
{
    try
    {
        auto prx = _prx->ice_endpointSelection(Ice::EndpointSelectionType(type));
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(instancetype) ice_encodingVersion:(uint8_t)major minor:(uint8_t)minor
{
    Ice::EncodingVersion encoding{major, minor};

    auto prx = _prx->ice_encodingVersion(encoding);
    return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
}

-(void) ice_getEncodingVersion:(uint8_t*)major minor:(uint8_t*)minor
{
    Ice::EncodingVersion v = _prx->ice_getEncodingVersion();
    *major = v.major;
    *minor = v.minor;
}

-(ICEObjectPrx*) ice_getRouter
{
    return [[ICEObjectPrx alloc] initWithCppObjectPrx:_prx->ice_getRouter()];
}

-(instancetype) ice_router:(ICEObjectPrx*)router error:(NSError**)error
{
    try
    {
        auto r = router ? [router prx] : nullptr;
        auto prx = _prx->ice_router(Ice::uncheckedCast<Ice::RouterPrx>(r));
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(ICEObjectPrx*) ice_getLocator
{
    return [[ICEObjectPrx alloc] initWithCppObjectPrx:_prx->ice_getLocator()];
}

-(instancetype) ice_locator:(ICEObjectPrx*)locator error:(NSError**)error
{
    try
    {
        auto l = locator ? [locator prx] : nullptr;
        auto prx = _prx->ice_locator(Ice::uncheckedCast<Ice::LocatorPrx>(l));
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(bool) ice_isSecure
{
    return _prx->ice_isSecure();
}

-(instancetype) ice_secure:(bool)b
{
    auto prx = _prx->ice_secure(b);
    return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
}

-(bool) ice_isPreferSecure
{
    return _prx->ice_isPreferSecure();
}

-(instancetype) ice_preferSecure:(bool)b error:(NSError**)error
{
    try
    {
        auto prx = _prx->ice_preferSecure(b);
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(bool) ice_isTwoway
{
    return _prx->ice_isTwoway();
}

-(nonnull instancetype) ice_twoway
{
    auto prx = _prx->ice_twoway();
    return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
}

-(bool) ice_isOneway
{
    return _prx->ice_isOneway();
}

-(nonnull instancetype) ice_oneway
{
    auto prx = _prx->ice_oneway();
    return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
}

-(bool) ice_isBatchOneway
{
    return _prx->ice_isBatchOneway();
}

-(instancetype) ice_batchOneway
{
    auto prx = _prx->ice_batchOneway();
    return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
}

-(bool) ice_isDatagram
{
    return _prx->ice_isDatagram();
}

-(instancetype) ice_datagram
{
    auto prx = _prx->ice_datagram();
    return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
}

-(bool) ice_isBatchDatagram
{
    return _prx->ice_isBatchDatagram();
}

-(instancetype) ice_batchDatagram
{
    auto prx = _prx->ice_batchDatagram();
    return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
}

-(nullable id) ice_getCompress
{
    auto compress = _prx->ice_getCompress();
    if(!compress.has_value())
    {
        return nil;
    }
    return [NSNumber numberWithBool: compress.value() ? YES : NO];
}

-(instancetype) ice_compress:(bool)compress
{
    auto prx = _prx->ice_compress(compress);
    return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
}

-(id) ice_getTimeout
{
    auto timeout = _prx->ice_getTimeout();
    if(!timeout.has_value())
    {
        return nil;
    }
    return [NSNumber numberWithInt:timeout.value()];
}

-(instancetype) ice_timeout:(int32_t)timeout error:(NSError**)error
{
    try
    {
        auto prx = _prx->ice_timeout(timeout);
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(instancetype) ice_fixed:(ICEConnection*)connection error:(NSError**)error
{
    try
    {
        auto prx = _prx->ice_fixed([connection connection]);
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(bool) ice_isFixed
{
    return _prx->ice_isFixed();
}

-(id)ice_getConnection:(NSError**)error
{
    try
    {
        auto cppConnection = _prx->ice_getConnection();

        ICEConnection* connection = createLocalObject(cppConnection, [&cppConnection]() -> id
        {
            return [[ICEConnection alloc] initWithCppConnection:cppConnection];
        });

        return connection ? connection : [NSNull null];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(ICEConnection*) ice_getCachedConnection
{
    auto cppConnection = _prx->ice_getCachedConnection();

    return createLocalObject(cppConnection, [&cppConnection]() -> id
    {
        return [[ICEConnection alloc] initWithCppConnection:cppConnection];
    });
}

-(BOOL) ice_flushBatchRequests:(NSError**)error
{
    try
    {
        _prx->ice_flushBatchRequests();
        return YES;
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return NO;
    }
}

-(BOOL) ice_flushBatchRequestsAsync:(void (^)(NSError*))exception
                               sent:(void (^_Nullable)(bool))sent
                              error:(NSError**)error
{
    try
    {
        _prx->ice_flushBatchRequestsAsync([exception](std::exception_ptr e)
                                           {
                                               exception(convertException(e));
                                           },
                                           [sent](bool sentSynchronously)
                                           {
                                               if(sent)
                                               {
                                                   sent(sentSynchronously);
                                               }
                                           });
        return YES;
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return NO;
    }
}

-(bool) ice_isCollocationOptimized
{
    return _prx->ice_isCollocationOptimized();
}

-(instancetype) ice_collocationOptimized:(bool)collocated
                                            error:(NSError* _Nullable * _Nullable)error
{
    try
    {
        auto prx = _prx->ice_collocationOptimized(collocated);
        return _prx == prx ? self : [[ICEObjectPrx alloc] initWithCppObjectPrx:prx];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

+(id) iceRead:(void*)start
         size:(NSInteger)size
 communicator:(ICECommunicator*)communicator
encodingMajor:(uint8_t)major
encodingMinor:(uint8_t)minor
    bytesRead:(NSInteger*)bytesRead
        error:(NSError**)error
{

    std::pair<const Ice::Byte*, const Ice::Byte*> p;
    p.first = reinterpret_cast<Ice::Byte*>(start);
    p.second = p.first + size;

    auto comm = [communicator communicator];

    try
    {
        Ice::InputStream ins(comm, Ice::EncodingVersion{major, minor}, p);

        std::shared_ptr<Ice::ObjectPrx> proxy;
        ins.read(proxy);

        *bytesRead = ins.pos();
        if(proxy)
        {
            return [[ICEObjectPrx alloc] initWithCppObjectPrx:proxy];
        }
        else
        {
            return [NSNull null];
        }
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(void) iceWrite:(id<ICEOutputStreamHelper>)os
   encodingMajor:(uint8_t)encodingMajor
   encodingMinor:(uint8_t)encodingMinor
{
    //
    // Marshal a proxy into a stream and return the encoded bytes.
    //
    auto communicator = _prx->ice_getCommunicator();
    Ice::EncodingVersion encoding { encodingMajor, encodingMinor };
    Ice::OutputStream out(communicator, encoding);
    out.write(_prx);
    std::pair<const Ice::Byte*, const Ice::Byte*> p = out.finished();
    int count = static_cast<int>(p.second - p.first);
    [os copy:p.first count:[NSNumber numberWithInt:count]];
}

-(ICEInputStream*) iceInvoke:(NSString*)op
                         mode:(uint8_t)mode
                     inParams:(const void* _Null_unspecified)inParams
                       inSize:(size_t)inSize
                      context:(NSDictionary*)context
                  returnValue:(bool*)returnValue
                        error:(NSError**)error
{
    std::pair<const Ice::Byte*, const Ice::Byte*> params(0, 0);
    params.first = reinterpret_cast<const Ice::Byte*>(inParams);
    params.second = params.first + inSize;

    try
    {
        Ice::Context ctx;
        if(context)
        {
            fromNSDictionary(context, ctx);
        }

        std::vector<Ice::Byte> v;
        *returnValue = _prx->ice_invoke(fromNSString(op), static_cast<Ice::OperationMode>(mode), params, v,
                                        context ? ctx : Ice::noExplicitContext);
        return [[ICEInputStream alloc] initWithBytes:std::move(v)];
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return nil;
    }
}

-(BOOL) iceInvokeAsync:(NSString* _Nonnull)op
                  mode:(NSInteger)mode
              inParams:(const void* _Null_unspecified)inParams
                inSize:(NSInteger)inSize
               context:(NSDictionary* _Nullable)context
              response:(void (^)(bool, ICEInputStream*))response
             exception:(void (^)(NSError*))exception
                  sent:(void (^_Nullable)(bool))sent
                 error:(NSError* _Nullable * _Nullable)error
{
    std::pair<const Ice::Byte*, const Ice::Byte*> params(0, 0);
    params.first = reinterpret_cast<const Ice::Byte*>(inParams);
    params.second = params.first + inSize;

    try
    {
        Ice::Context ctx;
        if(context)
        {
            fromNSDictionary(context, ctx);
        }

        //
        // It is possible to throw a CommunicatorDestroyedException
        //
        _prx->ice_invokeAsync(fromNSString(op), static_cast<Ice::OperationMode>(mode), params,
                                            [response](bool ok, std::pair<const Ice::Byte*, const Ice::Byte*> outParams)
                                            {
                                                // Makes a copy
                                                std::vector<Ice::Byte> r(outParams.first, outParams.second);
                                                response(ok, [[ICEInputStream alloc] initWithBytes:std::move(r)]);
                                            },
                                            [exception](std::exception_ptr e)
                                            {
                                                exception(convertException(e));
                                            },
                                            [sent](bool sentSynchronously)
                                            {
                                                if(sent)
                                                {
                                                    sent(sentSynchronously);
                                                }
                                            },
                              context ? ctx : Ice::noExplicitContext);

        return YES;
    }
    catch(const std::exception& ex)
    {
        *error = convertException(ex);
        return NO;
    }
}

-(bool) isEqual:(ICEObjectPrx*)other
{
    return Ice::targetEqualTo(_prx, other.prx);
}

-(bool) proxyIdentityLess:(ICEObjectPrx*)other
{
    return Ice::proxyIdentityLess(_prx, other.prx);
}

-(bool) proxyIdentityEqual:(ICEObjectPrx*)other
{
    return Ice::proxyIdentityEqual(_prx, other.prx);
}

-(bool) proxyIdentityAndFacetLess:(ICEObjectPrx*)other
{
    return Ice::proxyIdentityAndFacetLess(_prx, other.prx);
}

-(bool) proxyIdentityAndFacetEqual:(ICEObjectPrx*)other
{
    return Ice::proxyIdentityAndFacetEqual(_prx, other.prx);
}
@end
