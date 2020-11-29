note
	description: "[
		Reasons for pending payment. See
		[https://developer.paypal.com/docs/api-basics/notifications/ipn/IPNandPDTVariables/#payment-information-variables
		payment information variables] in IPN integration guide.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-29 11:02:55 GMT (Sunday 29th November 2020)"
	revision: "6"

class
	PP_PAYMENT_PENDING_REASON_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as export_default,
			import_name as import_default
		end

create
	make

feature -- Access

	address: NATURAL_8
		-- The payment is pending because your customer did not include a confirmed shipping address and your
		-- Payment Receiving Preferences is set to allow you to manually accept or deny each of these payments.
		-- To change your preference, go to the Preferences section of your Profile.

	authorization: NATURAL_8
		--You set the payment action to Authorization and have not yet captured funds.

	delayed_disbursement: NATURAL_8
		-- The transaction has been approved and is currently awaiting funding from the bank.
		-- This typically takes less than 48 hrs.

	echeck: NATURAL_8
		-- The payment is pending because it was made by an eCheck that has not yet cleared.

	intl: NATURAL_8
		-- The payment is pending because you hold a non-U.S. account and do not have a withdrawal mechanism.
		-- You must manually accept or deny this payment from your Account Overview.

	multi_currency: NATURAL_8
		-- You do not have a balance in the currency sent, and you do not have your profiles's
		-- Payment Receiving Preferences option set to automatically convert and accept this payment.
		-- As a result, you must manually accept or deny this payment.

	order: NATURAL_8
		-- You set the payment action to Order and have not yet captured funds.

	paymentreview: NATURAL_8
		-- The payment is pending while it is reviewed by PayPal for risk.

	regulatory_review: NATURAL_8
		-- The payment is pending because PayPal is reviewing it for compliance with government regulations.
		-- PayPal will complete this review within 72 hours. When the review is complete, you will receive
		-- a second IPN message whose payment_status/reason code variables indicate the result.

	unilateral: NATURAL_8
		-- The payment is pending because it was made to an email address that is not yet registered or confirmed.

	upgrade: NATURAL_8
		-- The payment is pending because it was made via credit card and you must upgrade your account to
		-- Business or Premier status before you can receive the funds. upgrade can also mean that you have
		-- reached the monthly limit for transactions on your account.

	verify: NATURAL_8
		-- The payment is pending because you are not yet verified. You must verify your account before you
		-- can accept this payment.

	other: NATURAL_8
		-- The payment is pending for a reason other than those listed above. For more information,
		-- contact PayPal Customer Service.

end