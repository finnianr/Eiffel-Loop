note
	description: "[https://docs.microsoft.com/en-us/windows/win32/com/the-component-object-model Windows COM object]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-22 15:04:44 GMT (Tuesday 22nd March 2022)"
	revision: "9"

class
	EL_WCOM_OBJECT

inherit
	EL_EXTERNAL_LIBRARY [EL_WCOM_INITIALIZER]

	EL_OWNED_CPP_OBJECT

	EL_MODULE_REUSEABLE

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
				across Reuseable.string_32 as reuse loop
					c.utf_16_0_pointer_into_escaped_string_32 (output.managed_data, reuse.item)
					Result := reuse.item
				end
			else
				create Result.make_empty
			end
		end

	set_string (set_c_string: FUNCTION [POINTER, POINTER, INTEGER]; value: ZSTRING)
		local
			c: EL_UTF_CONVERTER; value_utf_16: SPECIAL [NATURAL_16]
		do
			across Reuseable.string_32 as reuse loop
				value.append_to_string_32 (reuse.item)
				value_utf_16 := c.utf_32_string_to_utf_16_0 (reuse.item)
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