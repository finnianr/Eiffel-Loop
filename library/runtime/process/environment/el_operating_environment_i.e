note
	description: "Summary description for {EL_OPERATING_ENVIRONMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-21 11:03:39 GMT (Tuesday 21st June 2016)"
	revision: "6"

deferred class
	EL_OPERATING_ENVIRONMENT_I

inherit
	OPERATING_ENVIRONMENT

	EL_MODULE_DIRECTORY

	EL_MODULE_COMMAND

feature -- Access

	clear_screen_command: STRING
		deferred
		end

	C_library_prefix: STRING
		deferred
		end

	command_option_prefix: CHARACTER
			-- Character used to prefix option in command line
		deferred
		end

	dynamic_module_extension: STRING
		deferred
		end

	search_path_separator: CHARACTER
			-- Character used to separate paths in a directorysearch path on this platform.
		deferred
		end

	temp_directory_name: ZSTRING
		deferred
		end

feature -- Constants

	CPU_model_name: STRING
			--
		once
			Result := new_cpu_model_name
			Result.replace_substring_all ("(R)", "")
		end

	Temp_directory_path: EL_DIR_PATH
			--
		once
			create Result.make_from_unicode (temp_directory_name)
		end

	user_list: EL_ZSTRING_LIST
		do
			Result := Command.new_user_list.list
		end

feature -- Measurement

	is_root_path (path: STRING): BOOLEAN
			--
		deferred
		end

feature {NONE} -- Factory

	new_cpu_model_name: STRING
		deferred
		end
end
