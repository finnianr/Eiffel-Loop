note
	description: "Summary description for {EL_CURRENCY_CODE_NAME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 5:58:35 GMT (Monday 18th December 2017)"
	revision: "2"

class
	EL_CURRENCY_CODE

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Currency
		end

	EL_SHARED_CURRENCY_CODES
		undefine
			is_equal
		end

create
	make, make_default
end
