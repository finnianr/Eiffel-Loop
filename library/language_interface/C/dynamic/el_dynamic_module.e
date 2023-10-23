note
	description: "[
		Defines interface to dynamically load C API.
	]"
	instructions: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-04 9:00:49 GMT (Wednesday 4th October 2023)"
	revision: "14"

deferred class
	EL_DYNAMIC_MODULE [G -> EL_DYNAMIC_MODULE_POINTERS create make end]

inherit
	DYNAMIC_MODULE
		rename
			module_name as internal_module_name,
			make as make_module
		export
			{NONE} all
		redefine
			initialize
		end

	EL_MODULE_BUFFER

	EL_MODULE_EXECUTABLE

feature {NONE} -- Initialization

	initialize
		do
			create api.make (Current)
		end

	make
		local
			module_path: FILE_PATH
		do
			module_path := Executable.dynamic_module_name (module_name)
			make_module (module_path.without_extension.to_string.to_latin_1)
		ensure
			is_initialized: is_initialized
		end

feature -- Status query

	is_initialized: BOOLEAN
		do
			Result := module_handle /= default_pointer
		end

feature {EL_DYNAMIC_MODULE_POINTERS} -- Access

	function_pointer (name: STRING): POINTER
		-- API function pointer for `name_prefix + name'
		local
			l_name: STRING
		do
			l_name := Name_buffer; l_name.wipe_out
			if not name_prefix.is_empty then
				l_name.append (name_prefix)
			end
			l_name.append (name)
			Result := api_pointer (l_name)
		end

	name_prefix: STRING
			-- function name prefix
		deferred
		end

feature {NONE} -- Implementation

	call (function_name: STRING; c_function: PROCEDURE [POINTER])
			-- call API function specified by fully qualified name `function_name' (including
			-- any common name prefix)
		local
			function: POINTER
		do
			function := api_pointer (function_name)
			if function /= default_pointer then
				c_function (function)
			end
		end

	module_name: STRING
		deferred
		end

feature {NONE} -- Internal attributes

	api: G

feature {NONE} -- Constants

	Name_buffer: STRING
		once
			create Result.make_empty
		end

note
	instructions: "[
		If all the API names have a common prefix, then set `name_prefix' to be this prefix.
		For each API name define an attribute of type `POINTER' and named as `pointer_<api_name>'
		where `api_name' is a C identifier with the common prefix ommitted. Using the library 'libcurl'
		as an example,	the following API names would be set up as shown below.
		
		**C function names**
			curl_easy_init
			curl_easy_setopt
			curl_easy_perform
			curl_easy_cleanup

		**CURL_API class**
			class
				CURL_API
			inherit
				EL_DYNAMIC_MODULE
			create
				make
				
			feature {NONE} -- API pointers

				pointer_cleanup: POINTER

				pointer_init: POINTER

				pointer_perform: POINTER

				pointer_setopt: POINTER

			feature -- Constants

				Module_name: STRING = "libcurl"

				Name_prefix: STRING = "curl_easy_"
			end

		If the pointer names correspond exactly to the C identifer names, the pointers will be
		initialized automatically in the creation procedure.

		**Upper case names**

		If any of the API names contains an uppercase character, then these names must be listed by
		overriding the function `function_names_with_upper'. Make sure the common prefix defined by
		`name_prefix' is ommitted.
	]"

end