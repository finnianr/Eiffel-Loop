note
	description: "Id3 field types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_ID3_FIELD_TYPES

feature -- Types

	Type_encoding: INTEGER = 1

	Type_description: INTEGER = 2

	Type_language: INTEGER = 3

	Type_string_data: INTEGER = 4

	Type_binary_data: INTEGER = 5

	Type_integer: INTEGER = 6

feature {NONE} -- Constants

	Valid_types: ARRAY [INTEGER]
		do
			Result := << Type_encoding, Type_description, Type_language, Type_string_data, Type_binary_data, Type_integer >>
		end

	Type_names: EL_HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (<<
				[Type_encoding, 	 "Enc"],
				[Type_description, "Desc"],
				[Type_language, 	 "Lang"],
				[Type_string_data, "String"],
				[Type_binary_data, "Binary"],
				[Type_integer, 	 "Integer"]
			>>)
		end

end