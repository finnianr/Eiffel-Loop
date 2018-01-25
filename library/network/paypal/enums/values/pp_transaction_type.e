note
	description: "Summary description for {PP_TRANSACTION_TYPE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-21 12:34:29 GMT (Thursday 21st December 2017)"
	revision: "1"

class
	PP_TRANSACTION_TYPE

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Transaction_type_enum
		end

	PP_SHARED_TRANSACTION_TYPE
		undefine
			is_equal
		end

create
	make, make_default
end
