note
	description: "[
		Reflectively settable Payment transaction information. See
		[https://developer.paypal.com/docs/api-basics/notifications/ipn/IPNandPDTVariables/#transaction-and-notification-related-variables
		Payment information variables] in IPN integration guide.
	]"
	tests: "Class [$source PP_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-17 10:50:18 GMT (Monday 17th May 2021)"
	revision: "27"

class
	PP_TRANSACTION

inherit
	EL_URI_QUERY_TABLE
		rename
			make_url as make
		undefine
			is_equal
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		redefine
			make_default, new_instance_functions, new_representations
		end

	EL_SETTABLE_FROM_ZSTRING

	EL_CURRENCY_PROPERTY
		rename
			currency_code as mc_currency,
			currency_code_name as mc_currency_name,
			set_currency_code as set_mc_currency
		undefine
			new_representations
		end

	PP_SHARED_TRANSACTION_TYPE_ENUM

	PP_SHARED_PAYMENT_STATUS_ENUM

	PP_SHARED_PAYMENT_PENDING_REASON_ENUM

create
	make, make_default

feature {NONE} -- Initialization

	make_count (n: INTEGER)
		do
			make_default
		end

	make_default
		do
			create address.make_default
			create payment_date.make_now
			Precursor
		end

feature -- Payer

	address: PP_ADDRESS

	first_name: ZSTRING

	full_name: ZSTRING
		local
			name: EL_NAME_VALUE_PAIR [ZSTRING]
		do
			create name.make_pair (first_name, last_name)
			Result := name.joined (' ')
		end

	last_name: ZSTRING

	payer_email: ZSTRING

	payer_id: STRING

	residence_country: STRING

feature -- Receiver

	receiver_email: ZSTRING

	receiver_id: STRING

feature -- Product

	item_name: ZSTRING

	item_name1: ZSTRING

	item_number: STRING

	item_number1: STRING

	option_selection1: ZSTRING

	quantity: INTEGER

feature -- Metadata

	notify_version: STRING

	test_ipn: NATURAL_8

	verify_sign: STRING

	charset: EL_ENCODING
		-- IPN character set (set in Paypal merchant business profile)

feature -- Money

	amount_x100: INTEGER
		-- Payment amount
		do
			Result := (mc_gross * 100).rounded
		end

	exchange_rate: REAL
		-- Exchange rate used if a currency conversion occurred.

	fee_x100: INTEGER
		do
			Result := (mc_fee * 100).rounded
		end

	mc_fee: REAL

	mc_gross: REAL

	mc_gross_1: REAL

	shipping: REAL

	tax: REAL

feature -- Transaction detail

	payment_date: PP_DATE_TIME

	payment_status: NATURAL_8

	payment_type: STRING
		-- echeck: This payment was funded with an eCheck.
		-- instant: This payment was funded with PayPal balance, credit card, or Instant Transfer.

	pending_reason: NATURAL_8

	txn_id: STRING

	txn_type: NATURAL_8

feature -- Access

	custom: STRING

	invoice: STRING

feature {NONE} -- Implementation

	new_instance_functions: like Default_initial_values
		do
			create Result.make_from_array (<<
				agent: PP_DATE_TIME do create Result.make_now end
			>>)
		end

	new_representations: like Default_representations
		do
			create Result.make (<<
				["txn_type", Transaction_type_enum],
				["payment_status", Payment_status_enum],
				["pending_reason", Pending_reason_enum],
				["mc_currency", Currency_enum]
			>>)
		end

	set_name_value (key, a_value: ZSTRING)
		do
			if key.starts_with (Address_prefix) then
				key [Address_prefix.count] := '.'
			end
			set_field (key, a_value)
		end

	decoded_string (url: EL_URI_QUERY_STRING_8): ZSTRING
		do
			Result := url.decoded
		end

feature {NONE} -- Constants

	Address_prefix: ZSTRING
		once
			Result := "address_"
		end
end