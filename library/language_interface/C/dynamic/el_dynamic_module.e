note
	description: "Summary description for {EL_DYNAMICALLY_LOADED_C_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 18:52:44 GMT (Wednesday 16th December 2015)"
	revision: "3"

deferred class
	EL_DYNAMIC_MODULE

inherit
	DYNAMIC_MODULE
		rename
			module_name as internal_module_name,
			make as make_module,
			initialize as assign_pointers
		export
			{NONE} all
		undefine
			assign_pointers
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Initialization

	make
		local
			module_path: EL_FILE_PATH
		do
			module_path := Execution.dynamic_module_name (module_name)
			make_module (module_path.without_extension.to_string.to_latin_1)
		ensure
			is_initialized: is_initialized
		end

feature -- Status query

	is_initialized: BOOLEAN
		do
			Result := module_handle /= default_pointer
		end

feature {NONE} -- Implementation

	function_pointer (name: STRING): POINTER
		local
			l_name: STRING
		do
			l_name := String_buffer
			l_name.wipe_out
			if not name_prefix.is_empty then
				l_name.append (name_prefix)
			end
			l_name.append (name)
			Result := api_pointer (l_name)
		end

	module_name: STRING
		deferred
		end

	name_prefix: STRING
			-- function name prefix
		deferred
		end

feature {NONE} -- Constants

	String_buffer: STRING
		once
			create Result.make_empty
		end

end
