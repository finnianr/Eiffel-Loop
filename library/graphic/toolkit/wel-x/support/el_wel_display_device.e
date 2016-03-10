note
	description: "[
		Object that wraps:
		
			typedef struct _DISPLAY_DEVICE {
			  DWORD cb;
			  TCHAR DeviceName[32];
			  TCHAR DeviceString[128];
			  DWORD StateFlags;
			  TCHAR DeviceID[128];
			  TCHAR DeviceKey[128];
			} DISPLAY_DEVICE, *PDISPLAY_DEVICE;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-22 16:45:39 GMT (Friday 22nd March 2013)"
	revision: "2"

class
	EL_WEL_DISPLAY_DEVICE

inherit
	EL_C_OBJECT
		rename
			is_attached as is_pointer_attached
		redefine
			Is_memory_owned
		end

	EL_WEL_CONVERSION

create
	make

feature {NONE} -- Initialization

	make (adapter_name: STRING_32; device_number: INTEGER)
			--
		do
			make_from_pointer (self_ptr.memory_calloc (1, c_size_of_display_device_struct))
			cwin_set_struct_size (self_ptr, c_size_of_display_device_struct)

			is_valid := cwin_enum_display_devices (wel_string_from_string (adapter_name).item, device_number, self_ptr, 0)

			if is_valid then
				device_id := string16_to_string8 (cwin_device_id (self_ptr))
				description := string16_to_string8 (cwin_device_string (self_ptr))
			end
		end

feature -- Access

	device_id: STRING_32

	description: STRING_32

	state_flags: INTEGER
			--
		do
			Result := cwin_state_flags (self_ptr)
		end

feature -- Element change

	set_description (a_description: STRING_32)
		do
			description := a_description
		end

feature -- Status query

	is_valid: BOOLEAN

	is_active: BOOLEAN
		do
			Result := cwin_is_active (status_flags)
		end

	is_attached: BOOLEAN
		do
			Result := cwin_is_attached (status_flags)
		end

feature {NONE} -- Implementation

    Is_memory_owned: BOOLEAN = True

    status_flags: INTEGER
    	do
    		Result := cwin_state_flags (self_ptr)
    	end

feature {NONE} -- C Externals

	cwin_set_struct_size (ptr: POINTER; value: INTEGER)
		external
			"C [struct <Winuser.h>] (DISPLAY_DEVICE, DWORD)"
		alias
			"cb"
		end

	c_size_of_display_device_struct: INTEGER
		external
			"C [macro <Wingdi.h>]"
		alias
			"sizeof (DISPLAY_DEVICE)"
		end

	cwin_enum_display_devices (name: POINTER; device_number: INTEGER; device: POINTER; dw_flags: INTEGER): BOOLEAN
			-- BOOL EnumDisplayDevices(
			-- 		__in   LPCTSTR lpDevice,
			--  	__in   DWORD iDevNum,
			--   	__out  PDISPLAY_DEVICE lpDisplayDevice,
			--   	__in   DWORD dwFlags
			-- );
		external
			"C [macro <Winuser.h>] (LPCTSTR, DWORD, PDISPLAY_DEVICE, DWORD): BOOL"
		alias
			"EnumDisplayDevices"
		end

	cwin_device_id (ptr: POINTER): POINTER
		external
			"C [struct <Winuser.h>] (DISPLAY_DEVICE): LPCTSTR"
		alias
			"DeviceID"
		end

	cwin_device_string (ptr: POINTER): POINTER
		external
			"C [struct <Winuser.h>] (DISPLAY_DEVICE): LPCTSTR"
		alias
			"DeviceString"
		end

	cwin_state_flags (ptr: POINTER): INTEGER
		external
			"C [struct <Winuser.h>] (DISPLAY_DEVICE): DWORD"
		alias
			"StateFlags"
		end

	cwin_is_active (state: INTEGER): BOOLEAN
		external
			"C inline use <Winuser.h>"
		alias
			"( ((DWORD)$state) & DISPLAY_DEVICE_ACTIVE != 0)"
		end

	cwin_is_attached (state: INTEGER): BOOLEAN
		external
			"C inline use <Winuser.h>"
		alias
			"( ((DWORD)$state) & DISPLAY_DEVICE_ATTACHED != 0)"
		end

end
