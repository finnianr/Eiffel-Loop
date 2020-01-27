note
	description: "Wcom initializer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-27 16:25:40 GMT (Monday 27th January 2020)"
	revision: "5"

class
	EL_WCOM_INITIALIZER

inherit
	EL_INITIALIZEABLE
		redefine
			make
		end

	DISPOSABLE
		rename
			dispose as c_com_uninitialize
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			if c_com_initialize (Default_pointer) >= 0 then
				set_initialized
			end
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

feature {NONE} -- Constants

	Initialization_mask_table: HASH_TABLE [NATURAL, INTEGER]
		once
			create Result.make (3)
		end

end
