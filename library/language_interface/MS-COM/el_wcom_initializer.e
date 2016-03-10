note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

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
