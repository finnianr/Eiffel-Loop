note
	description: "ID for `AIA_CREDENTIAL'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-07 9:55:21 GMT (Thursday 7th December 2017)"
	revision: "3"

class
	AIA_CREDENTIAL_ID

inherit
	EL_REFLECTIVELY_SETTABLE_STRINGS [STRING]

	EL_MAKEABLE_FROM_STRING_8
		undefine
			is_equal
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (string: STRING)
		do
			make_default
			across string.split ('/') as part loop
				inspect part.cursor_index
					when 1 then
						key := part.item
					when 2 then
						date := part.item
				else
				end
			end
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

end
