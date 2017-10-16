note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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