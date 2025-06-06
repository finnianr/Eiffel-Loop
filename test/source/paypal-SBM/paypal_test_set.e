note
	description: "Paypal test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 17:28:12 GMT (Monday 5th May 2025)"
	revision: "27"

class
	PAYPAL_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DIRECTORY

	PP_SHARED_PAYMENT_STATUS_ENUM; PP_SHARED_PAYMENT_PENDING_REASON_ENUM; PP_SHARED_TRANSACTION_TYPE_ENUM

	EL_SHARED_CURRENCY_ENUM

	EL_FILE_OPEN_ROUTINES

	EL_REFLECTION_HANDLER

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["address_status_enum_checksum",	  agent test_address_status_enum_checksum],
				["pp_button_query_error_response", agent test_pp_button_query_error_response],
				["pp_date_format",					  agent test_pp_date_format],
				["pp_transaction",					  agent test_pp_transaction],
				["uri_query_table_conversion",	  agent test_uri_query_table_conversion]
			>>)
		end

feature -- Test

	test_address_status_enum_checksum
		-- PAYPAL_TEST_SET.test_address_status_enum_checksum
		note
			testing: "[
				covers/{EL_ENUMERATION}.write_crc
			]"
		do
			if attached crc_generator as crc then
				Address_status_enum.write_crc (crc)
				assert ("enum checksum is 2590709759", crc.checksum = 2590709759)
			end
		end

	test_pp_button_query_error_response
		-- PAYPAL_TEST_SET.test_pp_button_query_error_response
		local
			results: PP_BUTTON_QUERY_RESULTS; code: INTEGER; line: STRING
		do
			across << Button_result_error, Internal_error >> as uri_query loop
				if attached uri_query.item.split ('%N') as list then
					line := list [list.count - 1]
				end
				code := super_8 (line).substring_to_reversed ('=').to_integer
				create results.make (new_query (uri_query.item))
				if results.has_errors then
					results.print_errors
				end
				if results.error_list.count = 1 then
					assert_same_string (Void, "Error", results.error_list.first.severity)
					assert ("Error is " + code.out, results.error_list.first.code = code)
				else
					failed ("has error")
				end
			end
		end

	test_pp_date_format
		local
			date_time: EL_DATE_TIME; pp_date: PP_DATE_TIME; date_string: STRING
		do
			create date_time.make (2018, 4, 10, 10, 22, 41)
			date_string := "Tue Apr 10 2018 09:22:41 GMT-0100 (GMT)"
			create pp_date.make (date_string)
			assert ("same date", pp_date.to_unix = date_time.to_unix)

			date_string.remove_head (4)
			create pp_date.make (date_string)
			assert ("same date", pp_date.to_unix = date_time.to_unix)

			create pp_date.make (pp_date.out)
			assert ("same date", pp_date.to_unix = date_time.to_unix)
		end

	test_pp_transaction
		note
			testing: "[
				covers/{EL_URI_QUERY_TABLE}.make_url,
				covers/{EL_SETTABLE_FROM_STRING}.set_inner_table_field,
				covers/{EL_SETTABLE_FROM_STRING}.set_table_field
			]"
		local
			transaction: PP_TRANSACTION; date_time: EL_DATE_TIME
		do
			create transaction.make (new_query (IPN_message))
			assert_same_string ("address_country=Ireland", transaction.address.country, "Ireland")
			assert_same_string ("address_city=D�n B�inne", transaction.address.city, "D�n B�inne")
			assert ("address_country_code=IE", transaction.address.country_code ~ "IE")

			assert ("charset=UTF-8", transaction.charset.name ~ "UTF-8")

			assert ("mc_gross=4.85", transaction.amount_x100 = 485)

--			Enumeration types
			assert ("expected address_status", transaction.address.status = Address_status_enum.confirmed)
			assert ("expected mc_currency", transaction.mc_currency = Currency_enum.sgd)
			assert ("expected payment_status", transaction.payment_status = Payment_status_enum.canceled_reversal)
			assert ("expected pending_reason", transaction.pending_reason = Pending_reason_enum.delayed_disbursement)
			assert ("expected txn_type", transaction.txn_type = Transaction_type_enum.web_accept)

			create date_time.make (2018, 4, 10, 10, 22, 41)
			assert ("payment_date=2018/4/10 10:22:41", transaction.payment_date.to_unix = date_time.to_unix)
		end

	test_uri_query_table_conversion
		-- PAYPAL_TEST_SET.test_uri_query_table_conversion
		note
			testing: "covers/{EL_URI_QUERY_TABLE}.make_url",
				"covers/{EL_SETTABLE_FROM_STRING}.set_table_field"
		local
			transaction: PP_TRANSACTION; count, real_count, date_count: INTEGER
			value_table: EL_URI_QUERY_ZSTRING_HASH_TABLE; date_time: EL_DATE_TIME
			name: STRING
		do
			create transaction.make (new_query (IPN_message))

			create value_table.make_url (new_query (IPN_message))
			if attached transaction.field_table as field_table then
				across value_table as table loop
					name := table.key
					if field_table.has_key (name) then
						count := count + 1
						if attached {EL_REFLECTED_DATE_TIME} field_table.found_item as real then
							date_count := date_count + 1

						elseif attached {EL_REFLECTED_REAL_32} field_table.found_item as real then
							assert ("same value", table.item.to_real = real.value (transaction))
							real_count := real_count + 1
						else
							assert_same_string ("same value", table.item, field_table.found_item.to_string (transaction))
						end
					end
				end
			end
			assert ("26 fields", count = 26)
			assert ("3 REAL fields", real_count = 3)
			assert ("1 date field", date_count = 1)
		end

feature {NONE} -- Implementation

	new_query (line_query: STRING): STRING
		local
			param_list: EL_SPLIT_STRING_LIST [STRING]
		do
			create param_list.make (line_query, '%N')
			Result := param_list.joined ('&')
		end

feature {NONE} -- Constants

	Address_status_enum: PP_ADDRESS_STATUS_ENUM
		once
			create Result.make
		end

	Button_result_error: STRING = "[
		TIMESTAMP=2023%2d12%2d04T14%3a31%3a50Z
		CORRELATIONID=b100381cb0e05
		ACK=Failure
		VERSION=95%2e0
		BUILD=56068150
		L_ERRORCODE0=11933
		L_SEVERITYCODE0=Error
	]"

	IPN_message: STRING = "[
		mc_gross=4.85
		settle_amount=2.43
		protection_eligibility=Eligible
		address_status=confirmed
		payer_id=4TGKH2TNNXLPQ
		address_street=Home+sweet+home
		payment_date=03%3A22%3A41+Apr+10%2C+2018+PDT
		payment_status=Canceled_Reversal
		charset=UTF-8
		address_zip=NA
		first_name=test
		option_selection1=1+year
		mc_fee=0.64
		address_country_code=IE
		exchange_rate=0.578066
		address_name=test+buyer
		notify_version=3.9
		settle_currency=EUR
		custom=
		payer_status=verified
		pending_reason=delayed_disbursement
		business=finnian-facilitator%40eiffel-loop.com
		address_country=Ireland
		address_city=D%C3%BAn+B%C3%BAinne
		quantity=1
		verify_sign=AuJnGmaDDz7MSjS4Dq.Q2Vki3vo2AhI36V45NO9E2oQ5xIo-up7zqktB
		payer_email=finnian-buyer%40eiffel-loop.com
		option_name1=Duration
		txn_id=3WG690710A577410B
		payment_type=instant
		last_name=buyer
		address_state=Mh%C3%AD
		receiver_email=finnian-facilitator%40eiffel-loop.com
		payment_fee=
		receiver_id=WJA4MQCSCZHXJ
		txn_type=web_accept
		item_name=My+Ching+subscription+X+1
		mc_currency=SGD
		item_number=1.en.SGD
		residence_country=US
		test_ipn=1
		transaction_subject=
		payment_gross=
		ipn_track_id=30fe7b14ef9cb
	]"

	Internal_error: STRING = "[
		TIMESTAMP=2023-12-05T05:56:21.668
		CORRELATIONID=62288a65904c1
		ACK=Failure
		VERSION=95.0
		BUILD=1234
		L_ERRORCODE0=10001
		L_SEVERITYCODE0=Error
	]"

end