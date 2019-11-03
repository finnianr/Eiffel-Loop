note
	description: "Id3 frame field type enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 11:33:51 GMT (Thursday 10th October 2019)"
	revision: "1"

class
	ID3_FRAME_FIELD_TYPE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			default as default_any,
			export_name as to_english,
			import_name as import_default
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

end
