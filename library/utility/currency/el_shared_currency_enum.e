note
	description: "Shared instance of ${EL_CURRENCY_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "8"

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