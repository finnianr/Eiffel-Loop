note
	description: "Shared conversion objects conforming to [$source EL_POWER_2_BASE_NUMERIC_STRING_CONVERSION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-01 17:26:04 GMT (Thursday 1st December 2022)"
	revision: "5"

deferred class
	EL_SHARED_BASE_POWER_2_CONVERSIONS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Binary, Base_2: EL_BINARY_STRING_CONVERSION
		once
			create Result
		end

	Hexadecimal, Base_16: EL_HEXADECIMAL_STRING_CONVERSION
		once
			create Result
		end

	Octal, Base_8: EL_OCTAL_STRING_CONVERSION
		once
			create Result
		end
end