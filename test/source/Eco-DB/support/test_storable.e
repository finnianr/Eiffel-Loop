note
	description: "Test storable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-25 14:10:24 GMT (Saturday 25th June 2022)"
	revision: "13"

class
	TEST_STORABLE

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming,
			read_version as read_default_version
		redefine
			make_default
		end

create
	make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create uuid.make (1, 2, 3, 4, 5)
		end

feature -- Access

	string: ZSTRING

	string_32: STRING_32

	string_utf_8: STRING

	uuid: EL_UUID

feature -- Element change

	set_string_values (str: STRING_32)
		do
			string_32 := str
			string := str
			string_utf_8 := string.to_utf_8 (True)
		end

feature {NONE} -- Constants

	Field_hash: NATURAL = 3304235613

end