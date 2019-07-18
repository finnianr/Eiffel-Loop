note
	description: "Shared gbp exchange rate table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:25:52 GMT (Monday 1st July 2019)"
	revision: "5"

deferred class
	EL_SHARED_GB_POUND_RATE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	GB_pound_rate: EL_GBP_DAILY_EXCHANGE_RATES
		once
			create Result.make
		end
end
