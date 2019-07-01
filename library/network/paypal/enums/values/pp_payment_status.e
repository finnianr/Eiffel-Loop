note
	description: "Payment status code with values defined by enumeration [$source PP_PAYMENT_STATUS_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 9:23:09 GMT (Tuesday 24th April 2018)"
	revision: "3"

class
	PP_PAYMENT_STATUS

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Payment_status_enum
		end

	PP_SHARED_PAYMENT_STATUS_ENUM

create
	make, make_default
end
