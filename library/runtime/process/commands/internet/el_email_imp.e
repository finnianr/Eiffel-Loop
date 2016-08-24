note
	description: "Summary description for {EL_EMAIL_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-24 9:09:34 GMT (Wednesday 24th August 2016)"
	revision: "1"

class
	EL_EMAIL_IMP

inherit
	EL_EMAIL
		redefine
			make_default
		end

	EL_STRING_CONSTANTS

create
	make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			from_address := Empty_string
			to_address := Empty_string
			template := Empty_string_8
		end

feature -- Access

	from_address: ZSTRING

	to_address: ZSTRING

feature {NONE} -- Implementation

	template: STRING
end
