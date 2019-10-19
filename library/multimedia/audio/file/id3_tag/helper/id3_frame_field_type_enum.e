note
	description: "Summary description for {ID3_FRAME_FIELD_TYPE_ENUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
