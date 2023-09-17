note
	description: "Test implementation of [$source EIFFEL_SOURCE_READER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-17 14:23:17 GMT (Sunday 17th September 2023)"
	revision: "3"

class
	TEST_SOURCE_READER

inherit
	EIFFEL_SOURCE_READER
		redefine
			initialize
		end

create
	make_from_file

feature {NONE} -- Initialization

	initialize
		do
			create keyword_list.make (0)
			create manifest_string_list.make (0)
			create numeric_constant_list.make (0)
			create operator_list.make (0)
			create quoted_character_list.make (0)
			create quoted_string_list.make (0)
			create identifier_list.make (0)
			create comment_list.make (0)
			across <<
				keyword_list,
				manifest_string_list,
				numeric_constant_list,
				operator_list,
				quoted_character_list,
				quoted_string_list,
				identifier_list,
				comment_list

			>> as list loop
				list.item.compare_objects
			end
		end

feature -- Access

	comment_list: ARRAYED_LIST [IMMUTABLE_STRING_8]

	identifier_list: ARRAYED_LIST [IMMUTABLE_STRING_8]

	keyword_list: ARRAYED_LIST [IMMUTABLE_STRING_8]

	manifest_string_list: ARRAYED_LIST [IMMUTABLE_STRING_8]

	numeric_constant_list: ARRAYED_LIST [IMMUTABLE_STRING_8]

	operator_list: ARRAYED_LIST [IMMUTABLE_STRING_8]

	quoted_character_list: ARRAYED_LIST [IMMUTABLE_STRING_8]

	quoted_string_list: ARRAYED_LIST [IMMUTABLE_STRING_8]

feature {NONE} -- Events

	on_comment (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
			comment_list.extend (Immutable_8.new_substring (area, i, count))
		end

	on_identifier (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
			identifier_list.extend (Immutable_8.new_substring (area, i, count))
		end

	on_keyword (area: SPECIAL [CHARACTER]; i, count: INTEGER; type: INTEGER_64)
		do
			keyword_list.extend (Immutable_8.new_substring (area, i, count))
			if type = Type_operator then
				operator_list.extend (keyword_list.last)
			end
		end

	on_manifest_string (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
			manifest_string_list.extend (Immutable_8.new_substring (area, i, count))
		end

	on_numeric_constant (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
			numeric_constant_list.extend (Immutable_8.new_substring (area, i, count))
		end

	on_quoted_character (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
			quoted_character_list.extend (Immutable_8.new_substring (area, i + 1, count - 2))
		end

	on_quoted_string (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
			quoted_string_list.extend (Immutable_8.new_substring (area, i + 1, count - 2))
		end

end