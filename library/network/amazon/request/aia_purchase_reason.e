note
	description: "Reason for purchase or revoking of a purchase"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 6:21:46 GMT (Monday 18th December 2017)"
	revision: "2"

class
	AIA_PURCHASE_REASON

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Reason_enum
		end

	AIA_SHARED_ENUMERATIONS
		undefine
			is_equal
		end

create
	make, make_default

end
