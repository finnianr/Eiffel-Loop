note
	description: "Test storable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-11 9:42:51 GMT (Sunday 11th December 2022)"
	revision: "16"

class
	TEST_STORABLE

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming,
			read_version as read_default_version
		end

create
	make_default

feature -- Access

	string: ZSTRING

	string_32: STRING_32

	uuid: EL_UUID

feature -- Element change

	set_string_values (str: STRING_32)
		do
			string_32 := str
			string := str
		end

feature {NONE} -- Constants

	Field_hash: NATURAL = 4144711558

end