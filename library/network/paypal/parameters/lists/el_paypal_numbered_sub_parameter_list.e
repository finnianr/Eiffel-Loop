note
	description: "Summary description for {EL_PAYPAL_NUMBERED_SUB_PARAMETER_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_PAYPAL_NUMBERED_SUB_PARAMETER_LIST

inherit
	EL_PAYPAL_SUB_PARAMETER_LIST
		rename
			make as make_sub_parameter_list
		undefine
			new_name
		end

	EL_PAYPAL_NUMBERED_VARIABLE_NAME_SEQUENCE
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