note
	description: "[
		Wrapper for Component Object Model routines from
		[https://docs.microsoft.com/en-us/windows/win32/api/shobjidl/ ShObjIdl.h]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-22 15:11:15 GMT (Tuesday 22nd March 2022)"
	revision: "7"

deferred class
	EL_WINDOWS_SHELL_COM_API

inherit
	EL_C_API_ROUTINES

feature {NONE} -- C Externals

	c_create_IShellLinkW (p_this: POINTER): INTEGER
			--
		external
			"C++ inline use <ShObjIdl.h>"
		alias
			"CoCreateInstance (CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER, IID_IShellLinkW, (LPVOID*)$p_this)"
		ensure
			object_was_created: Result = status_ok
		end

feature {NONE} -- IShellLinkW C++ Routines

	cpp_create_persist_file (this, p_obj: POINTER): INTEGER
			--
		require
			this_is_attached: is_attached (this)
		external
			"C++ inline use <ShObjIdl.h>"
		alias
			"((IShellLinkW*)$this)->QueryInterface (IID_IPersistFile, (LPVOID*)$p_obj)"
		ensure
			object_was_created: Result = status_ok
		end

	cpp_get_arguments (this, string_ptr: POINTER; max_size: INTEGER): INTEGER
		-- HRESULT GetArguments(LPSTR pszName, int cch);
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IShellLinkW <ShObjIdl.h>](LPWSTR, int): EIF_INTEGER"
		alias
			"GetArguments"
		ensure
			call_succeeded: Result = status_ok
		end

	cpp_get_description (this, string_ptr: POINTER; max_size: INTEGER): INTEGER
		-- HRESULT GetDescription(LPSTR pszName, int cch);
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IShellLinkW <ShObjIdl.h>](LPWSTR, int): EIF_INTEGER"
		alias
			"GetDescription"
		ensure
			call_succeeded: Result = status_ok
		end

	cpp_get_icon_location (this, string_ptr: POINTER; max_size: INTEGER; icon_index: POINTER): INTEGER
		-- HRESULT GetIconLocation(LPWSTR pszIconPath, int cch, int *piIcon);
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IShellLinkW <ShObjIdl.h>](LPWSTR, int, int*): EIF_INTEGER"
		alias
			"GetIconLocation"
		ensure
			call_succeeded: Result = status_ok
		end

	cpp_get_path (a_self, string_out: POINTER; max_size: INTEGER): INTEGER
		--	HRESULT GetPath(
		--		[out]     LPWSTR           pszFile,
		--		[in]      int              cch,
		--		[in, out] WIN32_FIND_DATAW *pfd,
		--		[in]      DWORD            fFlags
		--	);
		external
			"C++ inline use <ShObjIdl.h>"
		alias
			"[
			{
				IShellLinkW *self = (IShellLinkW *)$a_self;
				return self->GetPath((LPWSTR)$string_out, (int)$max_size, NULL, SLGP_RAWPATH);
			}
			]"
		end

	cpp_get_working_directory (this, string_ptr: POINTER; max_size: INTEGER): INTEGER
		-- HRESULT GetWorkingDirectory(LPWSTR pszDir, int cch);
		require
			this_is_attached: is_attached (this)
		external
			"C++ [IShellLinkW <ShObjIdl.h>](LPWSTR, int): EIF_INTEGER"
		alias
			"GetWorkingDirectory"
		ensure
			call_succeeded: Result = status_ok
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
			call_succeeded: Result = status_ok
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
			call_succeeded: Result = status_ok
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
			call_succeeded: Result = status_ok
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
			call_succeeded: Result = status_ok
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
			call_succeeded: Result = status_ok
		end

feature {NONE} -- IShellLinkW Constants

	info_tip_size: INTEGER
			-- The file system directory that contains files and folders that appear on the desktop for all users.
			-- A typical path is C:\Documents and Settings\All Users\Desktop.
		external
			"C++ [macro <ShObjIdl.h>]"
		alias
			"INFOTIPSIZE"
		end

	max_path: INTEGER
		-- Maximum number of characters in path
		external
			"C++ [macro <ShObjIdl.h>]"
		alias
			"MAX_PATH"
		end

	status_ok: INTEGER
		external
			"C++ [macro <ShObjIdl.h>]"
		alias
			"S_OK"
		end

end