note
	description: "Id3 frame field type enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 21:46:19 GMT (Thursday 17th August 2023)"
	revision: "6"

class
	ID3_FRAME_FIELD_TYPE_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			default as default_any,
			description as field_description
		redefine
			foreign_naming
		end

create
	make

feature -- Types

	encoding: NATURAL_8

	date: NATURAL_8

	description: NATURAL_8

	default: NATURAL_8

	language: NATURAL_8

	latin_1_string: NATURAL_8
		-- latin-1

	string: NATURAL_8
		-- ZSTRING

	string_list: NATURAL_8
		-- ZSTRING list

	binary_data: NATURAL_8

	integer: NATURAL_8

	frame_id: NATURAL_8

feature {NONE} -- Constants

	Foreign_naming: EL_ENGLISH_NAME_TRANSLATER
		once
			create Result.make
		end
end