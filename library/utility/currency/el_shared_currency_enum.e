note
	description: "Shared instance of [$source EL_CURRENCY_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-29 16:12:46 GMT (Sunday 29th November 2020)"
	revision: "7"

deferred class
	EL_SHARED_CURRENCY_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Currency_enum: EL_CURRENCY_ENUM
		once
			create Result.make
		end

end