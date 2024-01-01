note
	description: "[
		Base class for Windows
		[https://docs.microsoft.com/en-us/windows/win32/com/the-component-object-model Component Object Model]
		object
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 17:34:31 GMT (Monday 1st January 2024)"
	revision: "15"

class
	COM_OBJECT

inherit
	EL_EXTERNAL_LIBRARY [COM_INITIALIZER]

	EL_OWNED_CPP_OBJECT

	EL_SHARED_NATIVE_STRING

feature {NONE}  -- Initialization

	make
		-- Creation
		do
			initialize_library
		end

feature {NONE} -- Implementation

	cpp_delete (this: POINTER)
				--
		local
			ref_count: NATURAL
		do
			ref_count := cpp_release (this)
		end

	new_native_string (c_item: POINTER): EL_NATIVE_STRING_8
		require
			attached_item: is_attached (c_item)
		do
			create Result.make_from_c (c_item)
		end

	new_string (get_c_string: FUNCTION [POINTER, POINTER, INTEGER]; max_size: INTEGER): ZSTRING
		do
			if attached Native_string as str then
				str.set_empty_capacity (max_size)
				last_status := get_c_string (self_ptr, str.item, max_size)
				if last_status = 0 then
					Result := str.to_string
				else
					create Result.make_empty
				end
			end
		end

feature {NONE} -- Internal attributes

	last_status: INTEGER
		-- last C call status

feature {NONE} -- C++ Externals

	cpp_release (this: POINTER): NATURAL
			-- ULONG Release();
		external
			"C++ [IUnknown <Unknwn.h>](): EIF_NATURAL"
		alias
			"Release"
		end

end