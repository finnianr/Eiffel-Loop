note
	description: "Tag::String::Type `toolkit/tstring.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-17 17:26:08 GMT (Tuesday 17th March 2020)"
	revision: "1"

class
	TL_STRING_ENCODING_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			import_name as import_default,
			export_name as to_english
		export
			{NONE} all
			{ANY} value, is_valid_value, name
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

end
