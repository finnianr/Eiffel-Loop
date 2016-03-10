#ifndef _NETWORK_ADAPTER_H
#define _NETWORK_ADAPTER_H

#include <eif_cecil.h>

EIF_INTEGER get_adapter_addresses (EIF_POINTER address_buffer, EIF_POINTER buffer_size);
EIF_INTEGER get_adapter_type (EIF_POINTER adapter_ptr);
EIF_INTEGER get_adapter_physical_address_size (EIF_POINTER adapter_ptr);

EIF_POINTER get_adapter_name (EIF_POINTER adapter_ptr);
EIF_POINTER get_adapter_description (EIF_POINTER adapter_ptr);
EIF_POINTER get_adapter_physical_address (EIF_POINTER adapter_ptr);
EIF_POINTER get_next_adapter (EIF_POINTER adapter_ptr);

#endif
