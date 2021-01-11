note
	description: "Zip file listing parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-10 13:30:54 GMT (Sunday 10th January 2021)"
	revision: "5"

class
	EL_ZIP_FILE_LISTING_PARSER

inherit
	EL_PARSER
		rename
			make_default as make,
			new_pattern as archived_file_listing_pattern
		end

	EL_TEXT_PATTERN_FACTORY

create
	make

feature -- Access

	listed_file_name: STRING

feature {NONE} -- Implementation

	archived_file_listing_pattern: like all_of
			--
		do
			Result := all_of (<<
				white_space,
				integer,
				white_space,
				integer,
				character_literal ('-'),
				integer,
				character_literal ('-'),
				integer,
				white_space,
				integer,
				character_literal (':'),
				integer,
				white_space,
				zero_or_more (any_character) |to| agent on_file_name
			>>)
		end

	on_file_name (file_name: EL_STRING_VIEW)
			--
		do
			listed_file_name := file_name.out
			listed_file_name.prune_all_leading (' ')
		end

end