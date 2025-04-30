note
	description: "[
		${PP_ADDRESS}.address_status: `confirmed' or `unconfirmed' 
		See [https://developer.paypal.com/docs/api-basics/notifications/ipn/IPNandPDTVariables/#buyer-information-variables
		Buyer information variables]
	]"
	tests: "Class ${PAYPAL_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 8:09:52 GMT (Wednesday 30th April 2025)"
	revision: "7"

class
	PP_ADDRESS_STATUS_ENUM

inherit
	EL_BOOLEAN_ENUMERATION
		rename
			is_true as confirmed,
			is_false as unconfirmed
		end

create
	make
end