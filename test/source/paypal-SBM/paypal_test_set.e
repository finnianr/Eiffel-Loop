note
	description: "Paypal test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 8:51:02 GMT (Tuesday 4th October 2022)"
	revision: "14"

class
	PAYPAL_TEST_SET

inherit
	EL_EQA_TEST_SET

	PP_SHARED_PAYMENT_STATUS_ENUM

	PP_SHARED_PAYMENT_PENDING_REASON_ENUM

	PP_SHARED_TRANSACTION_TYPE_ENUM

	EL_SHARED_CURRENCY_ENUM

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("pp_transaction", agent test_pp_transaction)
			eval.call ("pp_date_format", agent test_pp_date_format)
		end

feature -- Test

	test_pp_date_format
		local
			date_time: EL_DATE_TIME; pp_date: PP_DATE_TIME
			date_string: STRING
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
			testing: "covers/{EL_SETTABLE_FROM_STRING}.set_inner_table_field",
				"covers/{EL_SETTABLE_FROM_STRING}.set_table_field"
		local
			transaction: PP_TRANSACTION; date_time: EL_DATE_TIME
		do
			create transaction.make (ipn_url_query)
			assert ("address_country=Ireland", transaction.address.country.same_string ("Ireland"))
			assert ("address_city=Dún Búinne", transaction.address.city.same_string ("Dún Búinne"))
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

feature {NONE} -- Implementation

	ipn_url_query: STRING
		local
			param_list: EL_SPLIT_STRING_LIST [STRING]
		do
			create param_list.make_by_string (IPN_message, "%N")
			Result := param_list.joined ('&')
		end

feature {NONE} -- Constants

	Address_status_enum: PP_ADDRESS_STATUS_ENUM
		once
			create Result.make
		end

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

end