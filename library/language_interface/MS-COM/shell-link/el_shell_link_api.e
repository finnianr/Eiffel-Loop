note
	description: "Summary description for {EL_SHELL_LINK_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 15:57:08 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_SHELL_LINK_API
inherit
	EL_MEMORY
	
feature {NONE} -- Implementation

	call_succeeded (status: INTEGER): BOOLEAN
		deferred
		end

feature {NONE} -- C Externals

	c_create_IShellLinkW (p_this: POINTER): INTEGER
			--
		external
			"C inline use <Objbase.h>"
		alias
			"CoCreateInstance (CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER, IID_IShellLinkW, (LPVOID*)$p_this)"
		ensure
			object_was_created: call_succeeded (Result)
		end

feature {NONE} -- IShellLinkW C++ Externals

	cpp_create_IPersistFile (this, p_obj: POINTER): INTEGER
			--
		require
			this_is_attached: is_attached (this)
		external
			"C inline use <ShObjIdl.h>"
		alias
			"((IShellLinkW*)$this)->QueryInterface (IID_IPersistFile, (LPVOID*)$p_obj)"
		ensure
			object_was_created: call_succeeded (Result)
		end

	cpp_set_arguments (this, command_arguments_string_ptr: POINTER): INTEGER
			-- virtual HRESULT STDMETHODCALLTYPE SetArguments(__RPC__in_string LPCWSTR pszArgs) = 0;
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IShellLinkW <ShObjIdl.h>](__RPC__in_string LPCWSTR): EIF_INTEGER"
		alias
			"SetArguments"
		ensure
			call_succeeded: call_succeeded (Result)
		end

	cpp_set_path (this, target_path_ptr: POINTER): INTEGER
	        -- virtual HRESULT STDMETHODCALLTYPE SetPath(__RPC__in_string LPCWSTR pszFile) = 0;
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IShellLinkW <ShObjIdl.h>](__RPC__in_string LPCWSTR): EIF_INTEGER"
		alias
			"SetPath"
		ensure
			call_succeeded: call_succeeded (Result)
		end

	cpp_set_working_directory (this, directory_path_ptr: POINTER): INTEGER
		    -- virtual HRESULT STDMETHODCALLTYPE SetWorkingDirectory( LPCWSTR pszDir) = 0;
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IShellLinkW <ShObjIdl.h>](__RPC__in_string LPCWSTR): EIF_INTEGER"
		alias
			"SetWorkingDirectory"
		ensure
			call_succeeded: call_succeeded (Result)
		end

	cpp_set_icon_location (this, icon_path_ptr: POINTER; zero_index: INTEGER): INTEGER
	        -- virtual HRESULT STDMETHODCALLTYPE SetIconLocation(__RPC__in_string LPCWSTR pszIconPath, int iIcon) = 0;
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IShellLinkW <ShObjIdl.h>](__RPC__in_string LPCWSTR, int): EIF_INTEGER"
		alias
			"SetIconLocation"
		ensure
			call_succeeded: call_succeeded (Result)
		end

	cpp_set_description (this, icon_path_ptr: POINTER): INTEGER
	        -- virtual HRESULT STDMETHODCALLTYPE SetDescription(__RPC__in_string LPCWSTR pszIconPath) = 0;
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IShellLinkW <ShObjIdl.h>](__RPC__in_string LPCWSTR): EIF_INTEGER"
		alias
			"SetDescription"
		ensure
			call_succeeded: call_succeeded (Result)
		end

feature {NONE} -- IPersistFile C++ Externals

	cpp_save (this, wide_string_path: POINTER; fRemember: BOOLEAN): INTEGER
			-- virtual HRESULT STDMETHODCALLTYPE Save(__RPC__in_opt LPCOLESTR pszFileName, BOOL fRemember) = 0;
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IPersistFile <ObjIdl.h>](__RPC__in_opt LPCOLESTR, BOOL): EIF_INTEGER"
		alias
			"Save"
		ensure
			call_succeeded: call_succeeded (Result)
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
			call_succeeded: call_succeeded (Result)
		end

end
