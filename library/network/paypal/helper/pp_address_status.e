note
	description: "[
		address_status: Whether the customer provided a confirmed address. Value is:
		
		**confirmed** - Customer provided a confirmed address.
		
		**unconfirmed** - Customer provided an unconfirmed address.
		
		See:
		[https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNandPDTVariables/?mark=ipn#buyer-information-variables
		Buyer information variables]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-14 8:47:11 GMT (Saturday 14th April 2018)"
	revision: "3"

class
	PP_ADDRESS_STATUS

inherit
	EL_BOOLEAN_REF
		rename
			item as confirmed
		redefine
			false_name
		end

create
	make, make_default, make_from_string

convert
	make ({BOOLEAN}), confirmed: {BOOLEAN}

feature {NONE} -- Constants

	false_name: STRING
		once
			Result := "unconfirmed"
		end

end
