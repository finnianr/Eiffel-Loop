note
	description: "Splits Eiffel source lines into feature groups and individual feature lines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-01 9:36:35 GMT (Tuesday 1st August 2017)"
	revision: "3"

class
	SOURCE_MODEL

inherit
	EL_EIFFEL_SOURCE_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_LOG

	FEATURE_CONSTANTS

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
			if code_line_is_class_declaration then
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
			if code_line_starts_with (0, Keyword_feature) then
				feature_groups.extend (create {CLASS_FEATURE_GROUP}.make (line))
				state := agent find_first_feature
			else
				class_header.extend (line)
			end
		end

	find_next_feature (line: ZSTRING)
			-- find next feature in feature group
		do
			if code_line_starts_with_one_of (0, Footer_start_keywords) then
				fill_class_footer (line)
				state := agent fill_class_footer

			elseif code_line_starts_with (0, Keyword_feature) then
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

	last_feature_extend (line: ZSTRING; is_new: BOOLEAN)
		do
			if is_new then
				feature_groups.last.features.extend (create {CLASS_FEATURE}.make (line))
			else
				feature_groups.last.features.last.lines.extend (line)
			end
		end

feature {NONE} -- Implementation attributes

	class_footer: SOURCE_LINES

	class_header: SOURCE_LINES

	class_notes: SOURCE_LINES

	encoding: STRING

	feature_groups: EL_ARRAYED_LIST [CLASS_FEATURE_GROUP]

	source_path: EL_FILE_PATH

feature {NONE} -- Constants

	Default_group: CLASS_FEATURE_GROUP
		once
			create Result.make ("")
		end

	Feature_header_export: EL_ZSTRING
		once
			Result := "feature {%S} -- "
		end

end
