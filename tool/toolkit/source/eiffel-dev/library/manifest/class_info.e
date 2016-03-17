note
	description: "Summary description for {CLASS_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-04 19:11:17 GMT (Friday 4th March 2016)"
	revision: "9"

class
	CLASS_INFO

inherit
	EL_FILE_PARSER
		rename
			new_pattern as indexing_description_pattern
		redefine
			make_default
		end

	EVOLICITY_EIFFEL_CONTEXT
		redefine
			make_default
		end

	EL_EIFFEL_TEXT_PATTERN_FACTORY

	PART_COMPARABLE

	EL_MODULE_XML

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_FILE_PARSER}
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
		end

	make (a_file_path: like file_path)
			--
		do
--			log.enter_with_args ("make", << a_file_path >>)
			make_default
			file_path := a_file_path
			name := file_path.without_extension.base.as_upper
			set_description_from_class_file_description
--			log.exit
		end

feature -- Access

	description: ZSTRING

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

	indexing_description_pattern: like all_of
			--
		do
			Result := all_of (<<
				one_of (<< string_literal ("note"), string_literal ("indexing") >>),
				white_space,
				string_literal ("description"), maybe_white_space, character_literal (':'),
				maybe_white_space,
				one_of (<<
					unescaped_manifest_string (agent on_description),
					quoted_manifest_string (agent on_description)
				>>)
			>>)
		end

feature {NONE} -- Match actions

	on_description (text: EL_STRING_VIEW)
			--
		do
			description := text
			if description.is_empty
				or else description.starts_with_general ("Summary description for")
				or else description.starts_with_general ("Objects that ...")
			then
				create description.make_empty
				has_description := false
			else
 				description := normalized_indent (Manifest_string_line_split_matcher.deleted (description))
				has_description := true
			end
		end

feature {NONE} -- Implementation

	normalized_indent (str: ZSTRING): ZSTRING
		local
			lines: EL_ZSTRING_LIST; tab_count: INTEGER
		do
 			create lines.make_with_lines (str)
			-- Ensure all lines have at least as many leading tabs as first line
			lines.start
			if not lines.off then
				tab_count := lines.item_indent
				lines.forth
				from until lines.after loop
					if lines.item_indent < tab_count then
						lines.indent_item (tab_count - lines.item_indent)
					end
					lines.forth
				end
 			end
 			-- Unindent as much as we can
 			from until not lines.is_indented loop
 				lines.unindent
 			end
 			lines.expand_tabs (Tab_spaces)
 			Result := lines.joined_lines
		end

	set_description_from_class_file_description
			--
		do
			set_source_text_from_file (file_path)
			find_all
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["escaped_description", agent: ZSTRING do Result := XML.escaped (description) end],
				["has_description", 		agent: BOOLEAN_REF do Result := has_description.to_reference end],
				["name", 					agent: STRING do Result := name.string end]
			>>)
		end

feature {NONE} -- Constants

	Manifest_string_line_split_matcher: EL_TEXT_MATCHER
		once
			create Result.make
			Result.set_pattern (
				all_of (<< string_literal ("%%%N"), non_breaking_white_space, character_literal ('%%')>>)
			)
		end

	Tab_spaces: INTEGER = 3

end
