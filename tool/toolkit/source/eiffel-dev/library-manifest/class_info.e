note
	description: "Summary description for {CLASS_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 10:56:30 GMT (Sunday 28th July 2013)"
	revision: "5"

class
	CLASS_INFO

inherit
	EVOLICITY_EIFFEL_CONTEXT

	EL_FILE_PARSER
		rename
			new_pattern as indexing_description_pattern,
			make as make_parser
		end

	EL_EIFFEL_PATTERN_FACTORY

	PART_COMPARABLE

	EL_MODULE_XML

create
	make

feature {NONE} -- Initialization

	make (a_file_path: like file_path)
			--
		do
--			log.enter_with_args ("make", << a_file_path >>)
			make_eiffel_context
			make_parser
			file_path := a_file_path
			name := file_path.without_extension.base.as_upper
			set_description_from_class_file_description
--			log.exit
		end

feature -- Access

	description: EL_ASTRING

	name: STRING

	file_path: EL_FILE_PATH

feature -- Status report

	has_description: BOOLEAN

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if has_description = other.has_description then
				Result := name < other.name

			else
				Result := has_description
			end
		end

feature {NONE} -- Pattern definitions

	indexing_description_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				one_of (<< string_literal ("note"), string_literal ("indexing") >>),
				white_space,
				string_literal ("description"), maybe_white_space, character_literal (':'),
				maybe_white_space,
				one_of (<<
					unescaped_eiffel_string (agent on_description),
					quoted_eiffel_string (agent on_description)
				>>)
			>>)
		end

feature {NONE} -- Match actions

	on_description (text: EL_STRING_VIEW)
			--
		do
			description := text
			if description.is_empty
				or else description.starts_with ("Summary description for")
				or else description.starts_with ("Objects that ...")
			then
				create description.make_empty
				has_description := false
			else
 				description := Manifest_string_line_split_matcher.deleted (description)
				description := Tab_remover.normalized_text (description, 1)
				description.right_adjust
				has_description := true
			end
		end

feature {NONE} -- Implementation

	set_description_from_class_file_description
			--
		do
			set_source_text_from_file (file_path)
			find_all
			consume_events
		end

feature {NONE} -- Constants

	Manifest_string_line_split_matcher: EL_TEXT_MATCHER
		once
			create Result.make
			Result.set_pattern (
				all_of (<< string_literal ("%%%N"), non_breaking_white_space, character_literal ('%%')>>)
			)
		end

	Tab_remover: EL_TAB_REMOVER
		once
			create Result.make
			Result.ignore_leading_blank_lines
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["escaped_description", agent: EL_ASTRING do Result := XML.basic_escaped (description) end],
				["has_description", 		agent: BOOLEAN_REF do Result := has_description.to_reference end],
				["name", 					agent: STRING do Result := name.string end]
			>>)
		end

end
