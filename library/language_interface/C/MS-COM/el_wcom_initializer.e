note
	description: "Wcom initializer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_WCOM_INITIALIZER

inherit
	EL_INITIALIZEABLE
		rename
			uninitialize as c_com_uninitialize
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- 
		do
			is_initialized := c_com_initialize (Default_pointer) >= 0
		end
		
feature {NONE} -- C externals

	c_com_initialize (v_reserved: POINTER): INTEGER
			-- WINOLEAPI CoInitialize(IN LPVOID pvReserved);
		external
			"C (IN LPVOID): EIF_INTEGER | <objbase.h>"
		alias
			"CoInitialize"
		end
		
	c_com_uninitialize
			-- void CoUninitialize ();
		external
			"C | <objbase.h>"
		alias
			"CoUninitialize"
		end

end