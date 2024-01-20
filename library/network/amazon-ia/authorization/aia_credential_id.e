note
	description: "ID for ${AIA_CREDENTIAL}"
	tests: "See: ${AMAZON_INSTANT_ACCESS_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "16"

class
	AIA_CREDENTIAL_ID

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		end

	EL_SETTABLE_FROM_STRING_8
		rename
			new_string as new_empty_string
		end

	EL_MAKEABLE_FROM_STRING [STRING_8]
		undefine
			is_equal
		end

create
	make, make_default, make_from_general

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

	to_string: STRING
		local
			pair: EL_NAME_VALUE_PAIR [STRING]
		do
			create pair.make_pair (key, date )
			Result := pair.joined ('/')
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