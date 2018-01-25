note
	description: "Payment status code with values defined by `PP_PAYMENT_STATUS_CODE'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-21 12:33:36 GMT (Thursday 21st December 2017)"
	revision: "2"

class
	PP_PAYMENT_STATUS

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Payment_status_enum
		end

	PP_SHARED_PAYMENT_STATUS_ENUM
		undefine
			is_equal
		end

create
	make, make_default
end
