note
	description: "ID for `AIA_CREDENTIAL_KEY_PAIR'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-10 15:25:16 GMT (Friday 10th November 2017)"
	revision: "1"

class
	AIA_CREDENTIAL_ID

inherit
	EL_MAKEABLE_FROM_STRING_8
		redefine
			is_equal
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (string: STRING)
		local
			parts: LIST [STRING]
		do
			parts := string.split ('/')
			if parts.count = 2 then
				key := parts.first; date := parts.last
			else
				make_default
			end
		end

	make_default
		do
			key := Empty_string_8
			date := Empty_string_8
		end

feature -- Access

	date: STRING

	key: STRING

feature -- Element change

	set_date (a_date: like date)
		do
			date := a_date
		end

	set_key (a_key: like key)
		do
			key := a_key
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := date ~ other.date and key ~ other.key
		end

end
