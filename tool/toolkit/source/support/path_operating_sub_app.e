note
	description: "Summary description for {PATH_OPERATING_SUB_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 20:04:24 GMT (Friday 8th July 2016)"
	revision: "5"

deferred class
	PATH_OPERATING_SUB_APP [P -> EL_PATH create make_from_latin_1 end]

inherit
	EL_SUB_APPLICATION
		undefine
			new_lio, new_log_manager
		end

	EL_REGRESSION_TESTING_APPLICATION

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			if not Is_test_mode then
				set_defaults
			end
			set_attribute_from_command_opt (input_path, input_path_option_name, input_path_option_description)
		end

feature {NONE} -- Implementation

	set_defaults
		do
			create input_path.make_from_latin_1 (default_path)
		end

	input_path: P

	input_path_option_description: STRING
		deferred
		end

	default_path: STRING
			--
		do
			create Result.make_empty
		end

end