note
	description: "[
		Decimal point character and other common symboles accessible via {[$source EL_SHARED_SYMBOL]}.Symbol
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-11 16:47:01 GMT (Monday 11th December 2023)"
	revision: "1"

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

feature {NONE} -- Constants

	English_table: STRING = "[
		decimal_point:
			.
	]"
end