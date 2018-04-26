note
	description: "Transaction type code with values defined by enumeration [$source PP_TRANSACTION_TYPE_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 9:28:20 GMT (Tuesday 24th April 2018)"
	revision: "2"

class
	PP_TRANSACTION_TYPE

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Transaction_type_enum
		end

	PP_SHARED_TRANSACTION_TYPE_ENUM
		undefine
			is_equal
		end

create
	make, make_default
end
