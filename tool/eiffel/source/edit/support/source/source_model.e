note
	description: "Splits Eiffel source lines into feature groups and individual feature lines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-06 13:29:08 GMT (Friday 6th March 2020)"
	revision: "7"

class
	SOURCE_MODEL

inherit
	EL_EIFFEL_SOURCE_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_LIO

	FEATURE_CONSTANTS

feature {NONE} -- Initialization

	make (a_source_path: like source_path)
		local
			input_lines: EL_PLAIN_TEXT_LINE_SOURCE
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
			create encoding.make_from_other (input_lines)
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
			feature_groups.find_next_equal (name, agent {CLASS_FEATURE_GROUP}.name)
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
				add_feature (line)
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
				add_feature (line)
				state := agent find_next_feature
			else
				feature_groups.last.append (line)
			end
			if code_line_is_verbatim_string_start then
				state := agent find_verbatim_string_end
			end
		end

	find_verbatim_string_end (line: ZSTRING)
		do
			feature_groups.last.append (line)
			if code_line_is_verbatim_string_end then
				state := agent find_next_feature
			end
		end

feature {NONE} -- Implementation

	add_feature (line: ZSTRING)
		local
			l_feature: CLASS_FEATURE; pos_equals: INTEGER
		do
			pos_equals := line.index_of ('=', 1)
			if pos_equals > 1 and then line [pos_equals - 1] /= '#' then
				create {CONSTANT_FEATURE} l_feature.make (line)

			elseif line.starts_with (Setter_shorthand) then
				create {SETTER_SHORTHAND_FEATURE} l_feature.make (line)

			elseif line.has_substring (Insertion_symbol) then
				create {MAKE_ROUTINE_FEATURE} l_feature.make (line)

			elseif across Test_evaluator_do_all as str all line.has_substring (str.item) end then
				create {EQA_TEST_EVALUATION_CALLBACK_FEATURE} l_feature.make (Current, line)
			else
				create {ROUTINE_FEATURE} l_feature.make (line)
			end
			feature_groups.last.features.extend (l_feature)
		end

feature {CLASS_FEATURE} -- Implementation attributes

	class_footer: SOURCE_LINES

	class_header: SOURCE_LINES

	class_notes: SOURCE_LINES

	encoding: EL_ENCODING

	feature_groups: EL_ARRAYED_LIST [CLASS_FEATURE_GROUP]

	source_path: EL_FILE_PATH

feature {NONE} -- Constants

	Test_evaluator_do_all: ARRAY [ZSTRING]
		once
			Result := << "do_all", "EL_EQA_TEST_EVALUATOR)" >>
		end

	Default_group: CLASS_FEATURE_GROUP
		once
			create Result.make ("")
		end

	Feature_header_export: EL_ZSTRING
		once
			Result := "feature {%S} -- "
		end

	Insertion_symbol: ZSTRING
		once
			Result := ":@"
		end

	Setter_shorthand: ZSTRING
		once
			Result := "%T@set"
		end

end
