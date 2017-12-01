note
	description: "Summary description for {PP_NUMBERED_SUB_PARAMETER_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-23 14:46:07 GMT (Thursday 23rd November 2017)"
	revision: "3"

deferred class
	PP_NUMBERED_SUB_PARAMETER_LIST

inherit
	PP_SUB_PARAMETER_LIST
		rename
			make as make_sub_parameter_list
		undefine
			new_name
		end

	PP_NUMBERED_VARIABLE_NAME_SEQUENCE
		undefine
			is_equal, copy
		redefine
			make
		end

feature {NONE} -- Initialization

	make (a_number: like number)
		do
			Precursor (a_number)
			make_sub_parameter_list
		end
end
