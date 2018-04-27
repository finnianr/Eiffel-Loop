note
	description: "[
		Reflectively settable Payment transaction information. See
		[https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNandPDTVariables/#id091EB04C0HS
		Payment information variables] in IPN integration guide.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-23 12:09:54 GMT (Monday 23rd April 2018)"
	revision: "12"

class
	PP_TRANSACTION

inherit
	EL_URL_QUERY_TABLE
		undefine
			is_equal
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		redefine
			make_default, default_values
		end

	EL_SETTABLE_FROM_ZSTRING

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

	mc_currency: EL_CURRENCY_CODE

	mc_fee: REAL

	mc_gross: REAL

	mc_gross_1: REAL

	shipping: REAL

	tax: REAL

feature -- Transaction detail

	payment_date: PP_DATE_TIME

	payment_status: PP_PAYMENT_STATUS

	payment_type: STRING
		-- echeck: This payment was funded with an eCheck.
		-- instant: This payment was funded with PayPal balance, credit card, or Instant Transfer.

	pending_reason: PP_PAYMENT_PENDING_REASON

	txn_id: STRING

	txn_type: PP_PAYMENT_STATUS

feature -- Access

	custom: STRING

	invoice: STRING

feature {NONE} -- Implementation

	default_values: ARRAY [ANY]
		do
			Result := << create {PP_DATE_TIME}.make_now >>
		end

	set_name_value (key, a_value: ZSTRING)
		do
			if key.starts_with (Address_prefix) then
				key [Address_prefix.count] := '.'
			end
			set_field (key, a_value)
		end

feature {NONE} -- Constants

	Address_prefix: ZSTRING
		once
			Result := "address_"
		end
end
