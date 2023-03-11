note
	description: "Splits Eiffel source lines into feature groups and individual feature lines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-11 9:28:53 GMT (Saturday 11th March 2023)"
	revision: "16"

class
	SOURCE_MODEL

inherit
	EL_EIFFEL_SOURCE_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_FILE; EL_MODULE_LIO

	FEATURE_CONSTANTS

feature {NONE} -- Initialization

	make (a_source_path: FILE_PATH)
		local
			source_text: ZSTRING; utf: EL_UTF_CONVERTER
			space_editor: CLASS_LEADING_SPACE_EDITOR
		do
			make_machine
			source_path := a_source_path
			is_test_set := a_source_path.base.ends_with (Test_set_ending)
			create class_notes.make (10)
			create class_header.make (20)
			create class_footer.make (1)
			create group_header.make (3)
			create feature_group_list.make (8)

			create encoding.make_default

			if attached File.plain_text (a_source_path) as source_8 then
				if utf.is_utf_8_file (source_8) then
					encoding.set_utf (8)
				else
					encoding.set_latin (1)
				end
--				clean up any leading spaces at beginning of lines
				create space_editor.make_empty
				space_editor.set_source_text (source_8)
				if space_editor.leading_space_count > 0 then
					space_editor.replace_spaces
				end
				create source_text.make_from_file (source_8)
--				make sure there is no new-line after final end keyword
				source_text.right_adjust

				do_with_iterable_lines (agent find_class_declaration, source_text.split_list ('%N'))
			end
		end

feature -- Status query

	is_test_set: BOOLEAN

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
				feature_group_list.extend (create {FEATURE_GROUP}.make (group_header))
				group_header.wipe_out

				feature_group_list.add_feature (line, is_test_set)
				state := agent find_next_feature
			else
				group_header.extend (line)
			end
			if code_line_is_verbatim_string_start then
				state := agent find_verbatim_string_end
			end
		end

	find_first_feature_block (line: ZSTRING)
		do
			if code_line_starts_with (0, Keyword.feature_) then
				group_header.extend (line)
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

			elseif code_line_starts_with (0, Keyword.feature_) then
				group_header.extend (line)
				state := agent find_first_feature

			elseif code_line_is_feature_declaration then
				feature_group_list.add_feature (line, is_test_set)
				state := agent find_next_feature
			else
				feature_group_list.last.append (line)
			end
			if code_line_is_verbatim_string_start then
				state := agent find_verbatim_string_end
			end
		end

	find_verbatim_string_end (line: ZSTRING)
		do
			feature_group_list.last.append (line)
			if code_line_is_verbatim_string_end then
				state := agent find_next_feature
			end
		end

feature {CLASS_FEATURE} -- Implementation attributes

	class_footer: SOURCE_LINES

	class_header: SOURCE_LINES

	class_notes: SOURCE_LINES

	encoding: EL_ENCODING

	feature_group_list: FEATURE_GROUP_LIST

	group_header: EL_ZSTRING_LIST

	source_path: FILE_PATH

feature {NONE} -- Constants

	Test_set_ending: ZSTRING
		once
			Result := "_test_set.e"
		end

end