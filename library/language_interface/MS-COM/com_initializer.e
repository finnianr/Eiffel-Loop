note
	description: "[
		Initializes the Component Object Model library on the current thread and identifies the concurrency model as
		single-thread apartment (STA).
		See: [https://docs.microsoft.com/en-us/windows/win32/api/objbase/nf-objbase-coinitialize CoInitialize function]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	COM_INITIALIZER

inherit
	EL_INITIALIZEABLE

	DISPOSABLE
		rename
			dispose as c_com_uninitialize
		end

create
	make

feature {NONE} -- Initialization

	make

		do
			if c_com_initialize (Default_pointer) >= 0 then
				is_initialized := True
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

end