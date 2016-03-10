/*
	
*/
#include "network-adapter.h"

#include <winsock2.h>
#include <WS2tcpip.h>
#include <iphlpapi.h>
#include <stdio.h>
#include <stdlib.h>

EIF_INTEGER get_adapter_addresses (EIF_POINTER address_buffer, EIF_POINTER buffer_size)
{
	ULONG result;
	result = GetAdaptersAddresses (
		AF_UNSPEC, GAA_FLAG_INCLUDE_PREFIX, NULL, (PIP_ADAPTER_ADDRESSES)address_buffer, (PULONG)buffer_size
	);
	return (EIF_INTEGER)result;
}

EIF_INTEGER get_adapter_type (EIF_POINTER adapter_ptr)
{
	PIP_ADAPTER_ADDRESSES p_adapter = (PIP_ADAPTER_ADDRESSES) adapter_ptr;
	return (EIF_INTEGER)p_adapter->IfType;
}
EIF_INTEGER get_adapter_physical_address_size (EIF_POINTER adapter_ptr)
{
	PIP_ADAPTER_ADDRESSES p_adapter = (PIP_ADAPTER_ADDRESSES) adapter_ptr;
	return (EIF_INTEGER)p_adapter->PhysicalAddressLength;
}


EIF_POINTER get_adapter_name (EIF_POINTER adapter_ptr)
{
	PIP_ADAPTER_ADDRESSES p_adapter = (PIP_ADAPTER_ADDRESSES) adapter_ptr;
	return (EIF_POINTER)p_adapter->FriendlyName;
}

EIF_POINTER get_adapter_description (EIF_POINTER adapter_ptr)
{
	PIP_ADAPTER_ADDRESSES p_adapter = (PIP_ADAPTER_ADDRESSES) adapter_ptr;
	return (EIF_POINTER)p_adapter->Description;
}

EIF_POINTER get_next_adapter (EIF_POINTER adapter_ptr)
{
	PIP_ADAPTER_ADDRESSES p_adapter = (PIP_ADAPTER_ADDRESSES) adapter_ptr;
	return (EIF_POINTER)p_adapter->Next;
}

EIF_POINTER get_adapter_physical_address (EIF_POINTER adapter_ptr)
{
	PIP_ADAPTER_ADDRESSES p_adapter = (PIP_ADAPTER_ADDRESSES) adapter_ptr;
	return (EIF_POINTER)p_adapter->PhysicalAddress;
}


