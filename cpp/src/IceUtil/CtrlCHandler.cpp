// **********************************************************************
//
// Copyright (c) 2003
// ZeroC, Inc.
// Billerica, MA, USA
//
// All Rights Reserved.
//
// Ice is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License version 2 as published by
// the Free Software Foundation.
//
// **********************************************************************

#include <IceUtil/CtrlCHandler.h>
#include <IceUtil/StaticMutex.h>

#ifndef _WIN32
#   ifdef __sun
#       define _POSIX_PTHREAD_SEMANTICS
#   endif
#   include <signal.h>
#endif

using namespace std;
using namespace IceUtil;

static CtrlCHandlerCallback _callback = 0;
static const CtrlCHandler* _handler = 0;

CtrlCHandlerException::CtrlCHandlerException(const char* file, int line) :
    Exception(file, line)
{
}

static string ctrlCHandlerName = "IceUtil::CtrlCHandlerException";

const string&
CtrlCHandlerException::ice_name() const
{
    return ctrlCHandlerName;
}

Exception*
CtrlCHandlerException::ice_clone() const
{
    return new CtrlCHandlerException(*this);
}

void
CtrlCHandlerException::ice_throw() const
{
    throw *this;
}

void 
CtrlCHandler::setCallback(CtrlCHandlerCallback callback)
{
    StaticMutex::Lock lock(globalMutex);
    _callback = callback;
}

CtrlCHandlerCallback 
CtrlCHandler::getCallback() const
{
    StaticMutex::Lock lock(globalMutex);
    return _callback;
}

#ifdef _WIN32

static BOOL WINAPI handlerRoutine(DWORD dwCtrlType)
{
    CtrlCHandlerCallback callback = _handler->getCallback();
    if(callback != 0)
    {
	try
	{
	    callback(dwCtrlType);
	}
	catch(...)
	{
	    assert(0);
	}
    }
    return TRUE;
}


CtrlCHandler::CtrlCHandler(CtrlCHandlerCallback callback)
{
    StaticMutex::Lock lock(globalMutex);
    if(_handler != 0)
    {
	throw CtrlCHandlerException(__FILE__, __LINE__);
    }
    else
    {
	_callback = callback;
	_handler = this;
	lock.release();
	SetConsoleCtrlHandler(handlerRoutine, TRUE);
    }
}

CtrlCHandler::~CtrlCHandler()
{
    SetConsoleCtrlHandler(handlerRoutine, FALSE);
    {
	StaticMutex::Lock lock(globalMutex);
	_handler = 0;
    }
}

#else

extern "C" 
{

static void* 
sigwaitThread(void*)
{
    sigset_t ctrlCLikeSignals;
    sigemptyset(&ctrlCLikeSignals);
    sigaddset(&ctrlCLikeSignals, SIGHUP);
    sigaddset(&ctrlCLikeSignals, SIGINT);
    sigaddset(&ctrlCLikeSignals, SIGTERM);
    
    // Run until I'm cancelled (in sigwait())
    //
    for(;;)
    {
	int signal = 0;
	int rc = sigwait(&ctrlCLikeSignals, &signal);
	//
	// Some sigwait() implementations incorrectly return EINTR
	// when interrupted by an unblocked caught signal
	//
	if(rc == EINTR)
	{
	    continue;
	}
	assert(rc == 0);
	
	rc = pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, 0);
	assert(rc == 0);
	
	CtrlCHandlerCallback callback = _handler->getCallback();
	
	if(callback != 0)
	{
	    try
	    {
		callback(signal);
	    }
	    catch(...)
	    {
		assert(0);
	    }
	}

	rc = pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, 0);
	assert(rc == 0);
    }
    return 0;
}
}

static pthread_t _tid;

CtrlCHandler::CtrlCHandler(CtrlCHandlerCallback callback)
{
    StaticMutex::Lock lock(globalMutex);
    if(_handler != 0)
    {
	throw CtrlCHandlerException(__FILE__, __LINE__);
    }
    else
    {
	_callback = callback;
	_handler = this;
	lock.release();
	
	// We block these CTRL+C like signals in the main thread,
	// and by default all other threads will inherit this signal
	// disposition.
	
	sigset_t ctrlCLikeSignals;
	sigemptyset(&ctrlCLikeSignals);
	sigaddset(&ctrlCLikeSignals, SIGHUP);
	sigaddset(&ctrlCLikeSignals, SIGINT);
	sigaddset(&ctrlCLikeSignals, SIGTERM);
	int rc = pthread_sigmask(SIG_BLOCK, &ctrlCLikeSignals, 0);
	assert(rc == 0);

	// Joinable thread
	rc = pthread_create(&_tid, 0, sigwaitThread, 0);
	assert(rc == 0);
    }
}

CtrlCHandler::~CtrlCHandler()
{
    int rc = pthread_cancel(_tid);
    assert(rc == 0);
    void* status = 0;
    rc = pthread_join(_tid, &status);
    assert(rc == 0);
    assert(status == PTHREAD_CANCELED);

    {
	StaticMutex::Lock lock(globalMutex);
	_handler = 0;
    }
}

#endif

