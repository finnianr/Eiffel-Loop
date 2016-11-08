note
	description: "Interface to cURL easy API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-04 7:49:40 GMT (Tuesday 4th October 2016)"
	revision: "3"

class
	EL_CURL_API

inherit
	EL_DYNAMIC_MODULE [EL_CURL_API_POINTERS]
		rename
			clean_up as global_clean_up
		redefine
			make, global_clean_up
		end

	EL_CURL_C_API
		export
			{ANY} is_valid_option_constant
		end

	EL_CURL_INFO_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			if {PLATFORM}.is_unix or {PLATFORM}.is_mac then
				make_with_version (module_name, "4")
				if not is_interface_usable then
					unload
					make_with_version (module_name, "3")
				end
			else
				check is_window: {PLATFORM}.is_windows end
				make_module (module_name)
			end
			call ("curl_global_init", agent c_global_init (?, {CURL_GLOBAL_CONSTANTS}.curl_global_all))
			curl_global_cleanup_ptr := api_pointer ("curl_global_cleanup")
		ensure then
			curl_global_cleanup_ptr_attached: is_attached (curl_global_cleanup_ptr)
		end

feature -- Access

	get_info (a_curl_handle: POINTER; a_info: INTEGER; a_data: CELL [detachable ANY]): INTEGER
			-- `curl_getinfo'
			-- Request internal information from the curl session with this function.  The
 			-- third argument MUST be a pointer to a long, a pointer to a char * or a
 			-- pointer to a double (as the documentation describes elsewhere).  The data
 			-- pointed to will be filled in accordingly and can be relied upon only if the
 			-- function returns CURLE_OK.  This function is intended to get used *AFTER* a
 			-- performed transfer, all results from this function are undefined until the
 			-- transfer is completed.
		require
			valid_handle: is_attached (a_curl_handle)
		local
			mp: detachable MANAGED_POINTER
			l: INTEGER; cs: C_STRING; d: REAL_64
		do
			a_data.replace (Void)
			if a_info & {CURL_INFO_CONSTANTS}.curlinfo_long /= 0 then
				create mp.make ({PLATFORM}.integer_32_bytes)
			elseif a_info & {CURL_INFO_CONSTANTS}.curlinfo_string /= 0 then
				create mp.make ({PLATFORM}.pointer_bytes)
			elseif a_info & {CURL_INFO_CONSTANTS}.curlinfo_double /= 0 then
				create mp.make ({PLATFORM}.real_64_bytes)
			end
			if mp /= Void then
				Result := c_getinfo (api.getinfo, a_curl_handle, a_info, mp.item)
				if Result = {CURL_CODES}.curle_ok then
					if a_info & {CURL_INFO_CONSTANTS}.curlinfo_long /= 0 then
						l := mp.read_integer_32 (0)
						a_data.put (l)
					elseif a_info & {CURL_INFO_CONSTANTS}.curlinfo_string /= 0 then
						create cs.make_shared_from_pointer (mp.read_pointer (0))
						a_data.put (cs.string)
					elseif a_info & {CURL_INFO_CONSTANTS}.curlinfo_double /= 0 then
						d := mp.read_real_64 (0)
						a_data.put (d)
					end
				end
			end
		end

	new_pointer: POINTER
		do
			Result := c_init (api.init)
		end

feature -- Basic operations

	perform (a_curl_handle: POINTER): INTEGER
			-- Declared as curl_easy_perform().
		require
			valid_handle: is_attached (a_curl_handle)
		do
			Result := c_perform (api.perform, a_curl_handle)
		end

	clean_up (a_curl_handle: POINTER)
			-- Declared as curl_easy_cleanup().
		require
			valid_handle: is_attached (a_curl_handle)
		do
			c_cleanup (api.cleanup, a_curl_handle)
		end

feature -- Element change

	setopt_form (a_curl_handle: POINTER; a_opt: INTEGER; a_form: CURL_FORM)
			-- Declared as curl_easy_setopt().
		require
			valid_handle: is_attached (a_curl_handle) and then a_form.is_exists
			valid_option: is_valid_option_constant (a_opt)
		do
			setopt_void_star (a_curl_handle, a_opt, a_form.item)
		end

	setopt_integer (a_curl_handle: POINTER; a_opt: INTEGER; a_integer: INTEGER)
			-- Declared as curl_easy_setopt().
		require
			valid_handle: is_attached (a_curl_handle)
			valid_option: is_valid_option_constant (a_opt)
		do
			c_setopt_int (api.setopt, a_curl_handle, a_opt, a_integer)
		end

	setopt_string (a_curl_handle: POINTER; a_opt: INTEGER; a_string: STRING)
		do
			setopt_void_star (a_curl_handle, a_opt, a_string.area.base_address)
		end

	setopt_void_star (a_curl_handle: POINTER; a_opt: INTEGER; a_data: POINTER)
			-- Declared as curl_easy_setopt().
		require
			valid_handle: is_attached (a_curl_handle)
			valid_option: is_valid_option_constant (a_opt)
		do
			c_setopt (api.setopt, a_curl_handle, a_opt, a_data)
		end

feature {NONE} -- Implementation

	global_clean_up
		do
			c_global_cleanup (curl_global_cleanup_ptr)
		end

feature {NONE} -- Internal attributes

	curl_global_cleanup_ptr: POINTER

feature {NONE} -- Constants

	Module_name: STRING = "libcurl"

	Name_prefix: STRING = "curl_easy_"

end
