note
	description: "Tag::String::Type `toolkit/tstring.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-28 7:48:14 GMT (Saturday 28th September 2024)"
	revision: "7"

class
	TL_STRING_ENCODING_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			description_table as No_descriptions,
			foreign_naming as English
		export
			{NONE} all
			{ANY} valid_value, name, as_list
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