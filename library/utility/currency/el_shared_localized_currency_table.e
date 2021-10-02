note
	description: "Shared instance of [$source EL_LOCALIZED_CURRENCY_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-02 15:20:19 GMT (Saturday 2nd October 2021)"
	revision: "1"

deferred class
	EL_SHARED_LOCALIZED_CURRENCY_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Currency_table: EL_LOCALIZED_CURRENCY_TABLE
		once
			create Result.make
		end
end