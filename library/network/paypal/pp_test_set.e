note
	description: "Summary description for {PP_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PP_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test

	test_pp_transaction
		note
			testing: "covers/{EL_SETTABLE_FROM_STRING}.set_inner_table_field",
				"covers/{EL_SETTABLE_FROM_STRING}.set_table_field"
		local
			transaction: PP_TRANSACTION
		do
			create transaction.make (ipn_url_query)
			assert ("mc_gross=4.85", transaction.amount_x100 = 485)
			assert ("address_country=Ireland", transaction.address.country ~ "Ireland")
		end

feature {NONE} -- Implementation

	ipn_url_query: STRING
		local
			param_list: EL_SPLIT_STRING_LIST [STRING]
		do
			create param_list.make (IPN_message, "%N")
			Result := param_list.joined ('&')
		end

feature {NONE} -- Constants

	IPN_message: STRING = "[
		mc_gross=4.85
		settle_amount=2.43
		protection_eligibility=Eligible
		address_status=confirmed
		payer_id=4TGKH2TNNXLPQ
		address_street=Home+sweet+home
		payment_date=03%3A22%3A41+Apr+10%2C+2018+PDT
		payment_status=Completed
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
