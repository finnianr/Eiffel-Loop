note
	description: "Summary description for {PP_PAYMENT_PENDING_REASON}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-21 12:35:09 GMT (Thursday 21st December 2017)"
	revision: "2"

class
	PP_PAYMENT_PENDING_REASON

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Pending_reason_enum
		end

	PP_SHARED_PAYMENT_PENDING_REASON_ENUM
		undefine
			is_equal
		end

create
	make, make_default
end
