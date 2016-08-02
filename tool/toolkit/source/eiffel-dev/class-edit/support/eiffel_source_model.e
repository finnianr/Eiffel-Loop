note
	description: "Splits Eiffel source lines into feature groups and individual feature lines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-18 15:05:41 GMT (Monday 18th July 2016)"
	revision: "1"

class
	EIFFEL_SOURCE_MODEL

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		redefine
			call
		end

	EL_MODULE_LOG

	FEATURE_CONSTANTS

	EIFFEL_CONSTANTS

feature {NONE} -- Initialization

	make (a_source_path: like source_path)
		local
			input_lines: EL_FILE_LINE_SOURCE
		do
			make_machine
			source_path := a_source_path
			create class_notes.make (10)
			create class_header.make (20)
			create class_footer.make (1)
			create feature_groups.make (8)
			create code_line.make_empty
			found_group := Default_group

			create input_lines.make_latin (1, source_path)
			do_once_with_file_lines (agent find_class_declaration, input_lines)
			encoding := input_lines.encoding_name
		end

feature -- Access

	found_group: CLASS_FEATURE_GROUP

feature -- Basic operations

	start
		do
			feature_groups.start
		end

	search (name: ZSTRING)
		do
			feature_groups.find_next (name, agent {CLASS_FEATURE_GROUP}.name)
			if feature_groups.exhausted then
				found_group := Default_group
			else
				found_group := feature_groups.item
			end
		end

feature -- Status query

	group_found: BOOLEAN
		do
			Result := found_group /= Default_group
		end

feature {NONE} -- Factory

	new_feature_group (export_list, name: ZSTRING): CLASS_FEATURE_GROUP
		local
			first_line: ZSTRING
		do
			if export_list.is_empty then
				first_line := "feature -- "
			else
				first_line := Feature_header_export #$ [export_list]
			end
			first_line.append (name)
			create Result.make (first_line)
			Result.header.extend ("-- AUTO EDITION: new feature group")
			Result.header.extend ("")
		end

feature {NONE} -- State handlers

	fill_class_footer (line: ZSTRING)
		do
			class_footer.extend (line)
		end

	find_class_declaration (line: ZSTRING)
		do
			if Class_declaration_keywords.there_exists (agent code_line_starts_with) then
				state := agent find_first_feature_block
				find_first_feature_block (line)
			else
				class_notes.extend (line)
			end
		end

	find_first_feature (line: ZSTRING)
			-- find first feature in feature group
		do
			if code_line_is_feature_declaration then
				last_feature_extend (line, True)
				state := agent find_next_feature
			else
				feature_groups.last.header.extend (line)
			end
			if code_line_is_verbatim_string_start then
				state := agent find_verbatim_string_end
			end
		end

	find_first_feature_block (line: ZSTRING)
		do
			if code_line_starts_with (Keyword_feature) then
				feature_groups.extend (create {CLASS_FEATURE_GROUP}.make (line))
				state := agent find_first_feature
			else
				class_header.extend (line)
			end
		end

	find_next_feature (line: ZSTRING)
			-- find next feature in feature group
		do
			if tab_count = 0 and then Footer_start_keywords.has (code_line) then
				fill_class_footer (line)
				state := agent fill_class_footer

			elseif code_line_starts_with (Keyword_feature) then
				feature_groups.extend (create {CLASS_FEATURE_GROUP}.make (line))
				state := agent find_first_feature

			elseif code_line_is_feature_declaration then
				last_feature_extend (line, True)
				state := agent find_next_feature
			else
				last_feature_extend (line, False)
			end
			if code_line_is_verbatim_string_start then
				state := agent find_verbatim_string_end
			end
		end

	find_verbatim_string_end (line: ZSTRING)
		do
			last_feature_extend (line, False)
			if code_line_is_verbatim_string_end then
				state := agent find_next_feature
			end
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		local
			trim_line: ZSTRING
		do
			trim_line := line.twin
			trim_line.prune_all_leading ('%T')
			tab_count := line.count - trim_line.count
			if trim_line.count > 0 then
				trim_line.right_adjust
			end
			code_line := trim_line
			Precursor (line)
		end

	code_line_is_feature_declaration: BOOLEAN
			-- True if code line begins declaration of attribute or routine
		local
			first_character: CHARACTER_32
		do
			if not code_line.is_empty then
				first_character := code_line [1]
				Result := tab_count = 1 and then (first_character.is_alpha or else first_character = '@')
			end
		end

	code_line_is_verbatim_string_end: BOOLEAN
		do
			Result := across Close_verbatim_string_markers as marker some code_line.ends_with (marker.item) end
		end

	code_line_is_verbatim_string_start: BOOLEAN
		do
			Result := across Open_verbatim_string_markers as marker some code_line.ends_with (marker.item) end
		end

	code_line_starts_with (keyword: ZSTRING): BOOLEAN
		local
			l_line: like code_line
		do
			if tab_count = 0 then
				l_line := code_line
				Result := l_line.starts_with (keyword)
								and then (l_line.count > keyword.count implies l_line.unicode_item (keyword.count + 1).is_space)
			end
		end

	last_feature_extend (line: ZSTRING; is_new: BOOLEAN)
		do
			if is_new then
				feature_groups.last.features.extend (create {CLASS_FEATURE}.make (line))
			else
				feature_groups.last.features.last.lines.extend (line)
			end
		end

feature {NONE} -- Implementation attributes

	class_footer: EIFFEL_SOURCE_LINES

	class_header: EIFFEL_SOURCE_LINES

	class_notes: EIFFEL_SOURCE_LINES

	code_line: ZSTRING

	encoding: STRING

	feature_groups: EL_ARRAYED_LIST [CLASS_FEATURE_GROUP]

	source_path: EL_FILE_PATH

	tab_count: INTEGER

feature {NONE} -- Constants

	Close_verbatim_string_markers: ARRAY [ZSTRING]
		once
			Result := << "]%"", "}%"" >>
		end

	Default_group: CLASS_FEATURE_GROUP
		once
			create Result.make ("")
		end

	Footer_start_keywords: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<< Keyword_invariant, Keyword_end, Keyword_note >>)
		end

	Feature_header_export: EL_ZSTRING
		once
			Result := "feature {%S} -- "
		end

	Open_verbatim_string_markers: ARRAY [ZSTRING]
		once
			Result := << "%"[", "%"{" >>
		end

end