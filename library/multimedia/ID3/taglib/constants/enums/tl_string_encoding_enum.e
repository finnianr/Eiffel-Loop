note
	description: "Tag::String::Type `toolkit/tstring.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 11:45:02 GMT (Sunday 16th July 2023)"
	revision: "5"

class
	TL_STRING_ENCODING_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			foreign_naming as English
		export
			{NONE} all
			{ANY} is_valid_value, name
		redefine
			initialize_fields
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			latin_1 := 0
			utf_16  := 1
			utf_16_big_endian := 2
			utf_8 := 3
			utf_16_little_endian := 0x11
		end

feature -- Access

	latin_1: NATURAL_8

	utf_16 : NATURAL_8

	utf_16_big_endian: NATURAL_8

	utf_8: NATURAL_8

	utf_16_little_endian: NATURAL_8

feature {NONE} -- Constants

	English: EL_ENGLISH_NAME_TRANSLATER
		once
			create Result.make
			Result.set_uppercase_exception_set ("utf")
		end

end