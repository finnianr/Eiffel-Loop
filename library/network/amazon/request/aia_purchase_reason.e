note
	description: "Reason for purchase or revoking of a purchase"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:00:03 GMT (Monday 1st July 2019)"
	revision: "3"

class
	AIA_PURCHASE_REASON

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Reason_enum
		end

	AIA_SHARED_ENUMERATIONS

create
	make, make_default

end
