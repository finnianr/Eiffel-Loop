note
	description: "IPN transaction types for `{PP_TRANSACTION}.txn_type'"
	notes: "[
		Typically, your back-end or administrative processes will perform specific actions based on the kind
		of IPN message received. You can use the txn_type variable in the message to trigger the kind of processing
		you want to perform.
		See:
		[https://developer.paypal.com/docs/api-basics/notifications/ipn/IPNandPDTVariables/#ipn-transaction-types
		IPN transaction types]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-28 6:37:44 GMT (Wednesday 28th August 2024)"
	revision: "8"

class
	PP_TRANSACTION_TYPE_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			description_table as No_descriptions,
			foreign_naming as eiffel_naming
		end

create
	make

feature -- Access

	adjustment: NATURAL_8
		-- A dispute has been resolved and closed

	cart: NATURAL_8
		-- Payment received for multiple items; source is Express Checkout or the PayPal Shopping Cart.

	express_checkout: NATURAL_8
		-- Payment received for a single item; source is Express Checkout

	masspay: NATURAL_8
		-- Payment sent using Mass Pay

	merch_pmt: NATURAL_8
		-- Monthly subscription paid for Website Payments Pro, Reference transactions, or Billing Agreements

	mp_cancel: NATURAL_8
		-- Billing agreement cancelled

	new_case: NATURAL_8
		-- A new dispute was filed

	payout: NATURAL_8
		-- A payout related to a global shipping transaction was completed.

	pro_hosted: NATURAL_8
		-- Payment received; source is Website Payments Pro Hosted Solution.

	recurring_payment: NATURAL_8
		-- Recurring payment received

	recurring_payment_expired: NATURAL_8
		-- Recurring payment expired

	recurring_payment_failed: NATURAL_8
		-- Recurring payment failed. This transaction type is sent if:

		-- * The attempt to collect a recurring payment fails

		-- * The "max failed payments" setting in the customer's recurring payment profile is 0
		--   In this case, PayPal tries to collect the recurring payment an unlimited number of times without
		--   ever suspending the customer's recurring payments profile.

	recurring_payment_profile_cancel: NATURAL_8
		-- Recurring payment profile canceled

	recurring_payment_profile_created: NATURAL_8
		-- Recurring payment profile created

	recurring_payment_skipped: NATURAL_8
		-- Recurring payment skipped; it will be retried up to 3 times, 5 days apart

	recurring_payment_suspended: NATURAL_8
		-- Recurring payment suspended
		-- This transaction type is sent if PayPal tried to collect a recurring payment, but the related
		-- recurring payments profile has been suspended.

	recurring_payment_suspended_due_to_max_failed_payment: NATURAL_8
		-- Recurring payment failed and the related recurring payment profile has been suspended
		-- This transaction type is sent if:

		-- * PayPal's attempt to collect a recurring payment failed

		-- * The "max failed payments" setting in the customer's recurring payment profile is 1 or greater

		-- * The number of attempts to collect payment has exceeded the value specified for "max failed payments"
		--   In this case, PayPal suspends the customer's recurring payment profile.

	send_money: NATURAL_8
		-- Payment received; source is the Send Money tab on the PayPal website

	subscr_cancel: NATURAL_8
		-- Subscription canceled

	subscr_eot: NATURAL_8
		-- Subscription expired

	subscr_failed: NATURAL_8
		-- Subscription payment failed

	subscr_modify: NATURAL_8
		-- Subscription modified

	subscr_payment: NATURAL_8
		-- Subscription payment received

	subscr_signup: NATURAL_8
		-- Subscription started

	virtual_terminal: NATURAL_8
		-- Payment received; source is Virtual Terminal

	web_accept: NATURAL_8
		-- Payment received; source is any of the following:

		-- * A Direct Credit Card (Pro) transaction

		-- * A Buy Now, Donation or Smart Logo for eBay auctions button

end