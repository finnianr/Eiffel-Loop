note
	description: "[
		Decimal point character and other common symbols accessible via `${EL_SHARED_SYMBOL}.Symbol'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-25 7:18:54 GMT (Thursday 25th July 2024)"
	revision: "5"

class
	EL_SYMBOL_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		redefine
			make_default
		end

	EL_LOCALE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
		ensure then
			has_decimal_point_key: field_table.has_general (Decimal_point_key.unquoted)
		end

feature -- Access

	decimal_point: CHARACTER

feature {NONE} -- Implementation

	english_table: STRING
		do
			Result := "[
				decimal_point:
					.
			]"
		end

end