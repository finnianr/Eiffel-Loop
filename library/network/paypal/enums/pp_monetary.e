note
	description: "Paypal class with reflective `currency_code' field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-30 15:04:59 GMT (Friday 30th April 2021)"
	revision: "1"

deferred class
	PP_MONETARY

inherit
	EL_SHARED_CURRENCY_ENUM

feature -- Access

	currency_code: NATURAL_8

feature -- Element change

	set_currency_code (a_currency_code: NATURAL_8)
		do
			currency_code := a_currency_code
		end

feature {NONE} -- Implementation

	new_enumerations: EL_HASH_TABLE [EL_CURRENCY_ENUM, STRING]
		do
			create Result.make (<<
				["currency_code", Currency_enum]
			>>)
		end
end