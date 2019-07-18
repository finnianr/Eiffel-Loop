note
	description: "Pending reason code with values defined by enumeration [$source PP_PAYMENT_PENDING_REASON_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:04:10 GMT (Monday 1st July 2019)"
	revision: "4"

class
	PP_PAYMENT_PENDING_REASON

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Pending_reason_enum
		end

	PP_SHARED_PAYMENT_PENDING_REASON_ENUM

create
	make, make_default
end
