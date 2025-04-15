note
	description: "Zip file listing parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 15:23:52 GMT (Tuesday 15th April 2025)"
	revision: "8"

class
	EL_ZIP_FILE_LISTING_PARSER

inherit
	EL_PARSER_8
		rename
			make_default as make,
			new_pattern as archived_file_listing_pattern
		end

	TP_FACTORY

create
	make

feature -- Access

	listed_file_name: STRING

feature {NONE} -- Implementation

	archived_file_listing_pattern: like all_of
			--
		do
			Result := all_of ( <<
				white_space,
				signed_integer,
				white_space,
				signed_integer,
				character_literal ('-'),
				signed_integer,
				character_literal ('-'),
				signed_integer,
				white_space,
				signed_integer,
				character_literal (':'),
				signed_integer,
				white_space,
				zero_or_more (any_character) |to| agent on_file_name
			>>)
		end

	on_file_name (start_index, end_index: INTEGER)
			--
		do
			listed_file_name := new_source_substring (start_index, end_index)
			listed_file_name.prune_all_leading (' ')
		end

end