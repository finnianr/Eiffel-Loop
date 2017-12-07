note
	description: "Reason for purchase or revoking of a purchase"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-07 10:15:50 GMT (Thursday 7th December 2017)"
	revision: "1"

class
	AIA_PURCHASE_REASON

inherit
	EL_STATUS_CODE_VALUE [NATURAL_8]
		rename
			code_definition as Reason_code
		end

	AIA_SHARED_CODES
		undefine
			is_equal
		end

create
	make, make_default

end
