note
	description: "Format codes for initializing tables conforming to ${EL_IMMUTABLE_NAME_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 13:29:51 GMT (Tuesday 27th August 2024)"
	revision: "1"

class
	EL_TABLE_FORMAT

feature -- Contract Support

	valid_indented (format: NATURAL_8): BOOLEAN
		do
			inspect format
				when Indented, Indented_code, Indented_eiffel then
					Result := True
			else
			end
		end

feature -- Formats

	Assignment: NATURAL_8 = 1
		-- eiffel-like assignment of value to key but without quotes

	Comma_separated: NATURAL_8 = 2

	Indented: NATURAL_8 = 3
		-- indented with free-format keys, i.e. no restriction

	Indented_code: NATURAL_8 = 4
		-- indented with integer keys

	Indented_eiffel: NATURAL_8 = 5
		-- indented with eiffel identifier keys

end