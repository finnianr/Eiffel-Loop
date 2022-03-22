note
	description: "[
		Wrapper for Component Object Model routines from
		[https://docs.microsoft.com/en-us/windows/win32/api/objidl/ objidl.h]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-22 15:01:31 GMT (Tuesday 22nd March 2022)"
	revision: "1"

class
	EL_COM_OBJECT_BASE_API

inherit
	EL_C_API_ROUTINES

feature {NONE} -- IPersistFile C++ Externals

	cpp_save (this, wide_string_path: POINTER; flag_remember: BOOLEAN): INTEGER
			-- virtual HRESULT STDMETHODCALLTYPE Save(__RPC__in_opt LPCOLESTR pszFileName, BOOL fRemember) = 0;
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IPersistFile <ObjIdl.h>](__RPC__in_opt LPCOLESTR, BOOL): EIF_INTEGER"
		alias
			"Save"
		ensure
			call_succeeded: Result = status_ok
		end

	cpp_load (this, wide_string_path: POINTER; dwMode: INTEGER): INTEGER
			-- virtual HRESULT STDMETHODCALLTYPE Load(__RPC__in LPCOLESTR pszFileName, DWORD dwMode) = 0;		
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IPersistFile <ObjIdl.h>](__RPC__in LPCOLESTR, DWORD): EIF_INTEGER"
		alias
			"Load"
		ensure
			call_succeeded: Result = status_ok
		end

	status_ok: INTEGER
		external
			"C++ [macro <ObjIdl.h>]"
		alias
			"S_OK"
		end
end