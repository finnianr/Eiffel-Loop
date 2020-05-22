note
	description: "Encoded location"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-22 9:41:32 GMT (Friday 22nd May 2020)"
	revision: "1"

class
	ENCODED_LOCATION

inherit
	EL_URI_STRING_8
		redefine
			is_unescaped_extra
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature {NONE} -- Implementation

	is_unescaped_extra (c: CHARACTER_32): BOOLEAN
		do
			Result := Extra_characters.has (c.to_character_8)
		end

feature {NONE} -- Constants

	Extra_characters: STRING = "/!$&*()_+-=':@~,."
end
