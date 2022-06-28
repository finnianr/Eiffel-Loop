note
	description: "[
		Payment status codes. See
		[https://developer.paypal.com/docs/api-basics/notifications/ipn/IPNandPDTVariables/#payment-information-variables
		Payment information variables] in IPN integration guide.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-25 11:57:43 GMT (Saturday 25th June 2022)"
	revision: "8"

class
	PP_PAYMENT_STATUS_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			foreign_naming as Snake_case_title
		end

create
	make

feature -- Access

	canceled_reversal: NATURAL_8
		-- A reversal has been canceled. For example, you won a dispute with the customer,
		-- and the funds for the transaction that was reversed have been returned to you.

	completed: NATURAL_8
		-- The payment has been completed, and the funds have been added successfully to your account balance.

	created: NATURAL_8
		-- A German ELV payment is made using Express Checkout.

	denied: NATURAL_8
		-- The payment was denied. This happens only if the payment was previously pending because of one
		-- of the reasons listed for the pending_reason variable or the Fraud_Management_Filters_x variable.

	expired: NATURAL_8
		-- This authorization has expired and cannot be captured.

	failed: NATURAL_8
		-- The payment has failed. This happens only if the payment was made from your customer's bank account.

	pending: NATURAL_8
		-- The payment is pending. See pending_reason for more information.

	refunded: NATURAL_8
		-- You refunded the payment.

	reversed: NATURAL_8
		-- A payment was reversed due to a chargeback or other type of reversal. The funds have been removed
		-- from your account balance and returned to the buyer. The reason for the reversal is specified in
		-- the ReasonCode element.

	processed: NATURAL_8
		-- A payment has been accepted.

	voided: NATURAL_8
		-- This authorization has been voided.

feature {NONE} -- Constants

	Snake_case_title: EL_SNAKE_CASE_TRANSLATER
		-- eg. Canceled_Reversal <--> canceled_reversal
		once
			Result := {EL_CASE}.Title
		end
end