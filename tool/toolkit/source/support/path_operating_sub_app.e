note
	description: "Summary description for {PATH_OPERATING_SUB_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-25 12:12:44 GMT (Thursday 25th May 2017)"
	revision: "3"

deferred class
	PATH_OPERATING_SUB_APP [P -> EL_PATH create make_from_general end]

inherit
	REGRESSION_TESTING_SUB_APPLICATION

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			if Is_test_mode then
				Console.show ({EL_REGRESSION_TESTING_ROUTINES})
			else
				set_defaults
			end
			set_attribute_from_command_opt (input_path, input_path_option_name, input_path_option_description)
		end

feature {NONE} -- Implementation

	set_defaults
		do
			create input_path.make_from_general (default_path)
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
