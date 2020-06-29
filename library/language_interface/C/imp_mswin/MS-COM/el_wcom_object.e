note
	description: "[https://docs.microsoft.com/en-us/windows/win32/com/the-component-object-model Windows COM object]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-28 9:30:40 GMT (Sunday 28th June 2020)"
	revision: "8"

class
	EL_WCOM_OBJECT

inherit
	EL_EXTERNAL_LIBRARY [EL_WCOM_INITIALIZER]

	EL_OWNED_CPP_OBJECT

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

	call_succeeded (status: INTEGER): BOOLEAN
		do
			Result := status >= 0
		end

	wide_string (str: ZSTRING): SPECIAL [NATURAL_16]
			-- UTF-16 encoded string
		local
			c: EL_UTF_CONVERTER
		do
			Result := c.utf_32_string_to_utf_16_0 (str.to_unicode)
		end

	last_call_result: INTEGER

feature {NONE} -- C++ Externals

	cpp_release (this: POINTER): NATURAL
			-- ULONG Release();
		external
			"C++ [IUnknown <Unknwn.h>](): EIF_NATURAL"
		alias
			"Release"
		end

end
