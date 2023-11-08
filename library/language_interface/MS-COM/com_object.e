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
	date: "2023-11-08 14:24:38 GMT (Wednesday 8th November 2023)"
	revision: "14"

class
	COM_OBJECT

inherit
	EL_EXTERNAL_LIBRARY [COM_INITIALIZER]

	EL_OWNED_CPP_OBJECT

	EL_SHARED_STRING_32_BUFFER_SCOPES

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

	new_string (get_c_string: FUNCTION [POINTER, POINTER, INTEGER]; max_size: INTEGER): ZSTRING
		local
			output: NATIVE_STRING; c: UTF_CONVERTER
		do
			create output.make_empty (max_size)
			last_status := get_c_string (self_ptr, output.item, max_size)
			if last_status = 0 then
				across String_32_scope as scope loop
					c.utf_16_0_pointer_into_escaped_string_32 (output.managed_data, scope.item)
					Result := scope.item
				end
			else
				create Result.make_empty
			end
		end

	set_string (set_c_string: FUNCTION [POINTER, POINTER, INTEGER]; value: ZSTRING)
		local
			c: EL_UTF_CONVERTER; value_utf_16: SPECIAL [NATURAL_16]
		do
			across String_32_scope as scope loop
				value.append_to_string_32 (scope.item)
				value_utf_16 := c.utf_32_string_to_utf_16_0 (scope.item)
			end
			last_status := set_c_string (self_ptr, value_utf_16.base_address)
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