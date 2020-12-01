note
	description: "[
		{[$source PP_ADDRESS]}.address_status: `confirmed' or `unconfirmed' 
		See [https://developer.paypal.com/docs/api-basics/notifications/ipn/IPNandPDTVariables/#buyer-information-variables
		Buyer information variables]
	]"
	tests: "Class [$source PAYPAL_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-30 11:58:20 GMT (Monday 30th November 2020)"
	revision: "1"

class
	PP_ADDRESS_STATUS_ENUM

inherit
	EL_BOOLEAN_ENUMERATION
		rename
			export_name as export_default,
			import_name as import_default,
			is_true as confirmed,
			is_false as unconfirmed
		end

create
	make
end