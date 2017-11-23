note
	description: "Summary description for {PAYPAL_PAYMENT_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-10 14:28:37 GMT (Friday 10th November 2017)"
	revision: "2"

class
	EL_PAYPAL_TRANSACTION

inherit
	EL_REFLECTIVELY_SETTABLE [ZSTRING]
	 rename
		name_adaptation as standard_eiffel,
	 	make_from_zkey_table as make
	 end

create
	make

feature -- Unicode

	address_city: ZSTRING

	address_country: ZSTRING

	address_name: ZSTRING

	address_street: ZSTRING

	address_state: ZSTRING

	address_zip: ZSTRING

	option_selection1: ZSTRING

	payer_email: ZSTRING

	receiver_email: ZSTRING

feature -- Latin 1

	address_country_code: STRING

	address_status: STRING

	item_number: STRING

	mc_currency: STRING

	pending_reason: STRING

	payment_status: STRING

	payer_id: STRING

	receiver_id: STRING

	txn_id: STRING

feature -- Numeric

	mc_gross: ZSTRING

	mc_fee: ZSTRING

	quantity: INTEGER

end
