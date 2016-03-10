note
	description: "Summary description for {PATH_OPERATING_SUB_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:33 GMT (Tuesday 2nd September 2014)"
	revision: "3"

deferred class
	PATH_OPERATING_SUB_APP [P -> EL_PATH create make_from_latin1 end]

inherit
	EL_SUB_APPLICATION

	EL_TESTABLE_APPLICATION

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
			create input_path.make_from_latin1 (default_path)
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
