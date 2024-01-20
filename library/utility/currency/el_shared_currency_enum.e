note
	description: "Shared instance of ${EL_CURRENCY_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "9"

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