note
	description: "Summary description for {PP_PARAMETER_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-23 14:45:58 GMT (Thursday 23rd November 2017)"
	revision: "3"

deferred class
	PP_PARAMETER_LIST

inherit
	EL_HTTP_PARAMETER_LIST [EL_HTTP_NAME_VALUE_PARAMETER]
		rename
			make as make_list,
			extend as extend_list
		end

	PP_NUMBERED_VARIABLE_NAME_SEQUENCE
		undefine
			copy, is_equal
		redefine
			make
		end

feature -- Element change

	extend (value: ZSTRING)
		do
			extend_list (create {like item}.make (new_name, value))
		end

feature {NONE} -- Initialization

	make (a_number: like number)
		do
			Precursor (a_number)
			make_list (5)
		end
end
