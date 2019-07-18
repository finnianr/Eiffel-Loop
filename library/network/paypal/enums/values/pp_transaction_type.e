note
	description: "Transaction type code with values defined by enumeration [$source PP_TRANSACTION_TYPE_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:59:56 GMT (Monday 1st July 2019)"
	revision: "3"

class
	PP_TRANSACTION_TYPE

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Transaction_type_enum
		end

	PP_SHARED_TRANSACTION_TYPE_ENUM

create
	make, make_default
end
