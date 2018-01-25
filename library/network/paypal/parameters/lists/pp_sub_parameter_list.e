note
	description: "Summary description for {PP_NVP_VARIABLE_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-21 11:19:50 GMT (Thursday 21st December 2017)"
	revision: "5"

deferred class
	PP_SUB_PARAMETER_LIST

inherit
	EL_HTTP_NAME_VALUE_PARAMETER_LIST
		rename
			make as make_list,
			extend as extend_list
		end

	PP_VARIABLE_NAME_SEQUENCE
		undefine
			copy, is_equal
		end

feature {NONE} -- Initialization

	make
		do
			make_list (5)
		end

feature -- Element change

	extend (name, value: ZSTRING)
		local
			nvp: EL_NAME_VALUE_PAIR [ZSTRING]
		do
			create nvp.make_pair (name, value)
			extend_list (create {like item}.make (new_name, nvp.as_assignment))
		end

end
