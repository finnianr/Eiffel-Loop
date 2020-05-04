note
	description: "Test set for classes [$source LIBID3_TAG_INFO] and [$source UNDERBIT_ID3_TAG_INFO]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-01 12:04:16 GMT (Friday 1st May 2020)"
	revision: "10"

class
	ID3_TAG_INFO_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EL_STRING_8_CONSTANTS

	EL_MODULE_NAMING

	ID3_SHARED_FRAME_FIELD_TYPES

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
--			eval.call ("underbit_id3_info", agent test_underbit_id3_info)
			eval.call ("libid3_info", 	agent test_libid3_info)
		end

feature -- Tests

	test_libid3_info
		do
			do_test ("read_id3", 2594784551, agent read_id3, [create {LIBID3_TAG_INFO}.make])
		end

	test_underbit_id3_info
		do
			do_test ("read_id3", 4103542626, agent read_id3, [create {UNDERBIT_ID3_TAG_INFO}.make])
		end

feature {NONE} -- Implementation

	binary_data_string (field: ID3_FRAME): STRING
		local
			count: INTEGER
		do
			Result := "count = "
			Result.append_integer (field.binary_data.count)
		end

	integer_string (field: ID3_FRAME): STRING
		do
			Result := field.integer.out
		end

	read_id3 (info: ID3_INFO_I)
		local
			l_path: EL_FILE_PATH; header: ID3_HEADER; prefix_words: INTEGER
		do
			across new_id3_file_list as path loop
				l_path := path.item
				create header.make (l_path)
				log.put_path_field ("ID3", l_path.relative_path (Work_area_dir))
				log.put_new_line
				log.put_labeled_string ("Version", header.version_name)
				log.put_new_line
				if attached {UNDERBIT_ID3_TAG_INFO} info then
					info.link_and_read (l_path)
					prefix_words := 2
				elseif l_path.base.has_substring ("compressed") then
					log.put_line ("compressed ignored")
				else
					info.link_and_read (l_path)
					prefix_words := 1
				end
				put_frames (info.frame_list, prefix_words)
				info.wipe_out -- close files for test deletion
			end
		end

	string_list_first (field: ID3_FRAME): ZSTRING
		local
			list: LIST [ZSTRING]
		do
			list :=  field.string_list
			if list.is_empty then
				create Result.make_empty
			else
				Result := list.first
			end
		end

	new_id3_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (work_area_data_dir, filter)
		end

	put_frames (list: ARRAYED_LIST [ID3_FRAME]; prefix_words: INTEGER)
		local
			string_value: READABLE_STRING_GENERAL
		do
			across list as frame loop
				log.put_labeled_string (Square_brackets #$ [frame.item.generator, frame.cursor_index], frame.item.code)
				log.put_new_line
				log.tab_right
				log.put_new_line
				across frame.item.field_list as field loop
					string_value := Empty_string_8
					if Frame_field_table.has_key (field.item.type) then
						string_value := Frame_field_table.found_item (frame.item)
					end
					log.put_labeled_substitution (
						Square_brackets #$ [Naming.class_with_separator (field.item, '_', prefix_words, 0), field.cursor_index],
						"%S: %S", [field.item.type_name, string_value]
					)
					log.put_new_line
					if attached {ID3_STRING_LIST_FIELD} field.item as l_field then
						across l_field.list as str loop
							if str.cursor_index > 1 then
								log.put_string_field (Square_brackets #$ ["string_list", str.cursor_index], str.item)
								log.put_new_line
							end
						end
					end
				end
				log.tab_left
				log.put_new_line
			end
			log.put_new_line
		end

feature {NONE} -- Constants

	Filter: STRING = "*"
--	Filter: STRING = "230-syncedlyrics.tag"
--	Filter: STRING = "230-picture.tag"
--	Filter: STRING = "230*.tag"
--	Filter: STRING = "thatspot.*"
--	Filter: STRING = "*compressed.tag"
--	Filter: STRING = "ozzy.tag"

	Frame_field_table: EL_HASH_TABLE [FUNCTION [ID3_FRAME, READABLE_STRING_GENERAL], NATURAL_8]
		once
			create Result.make (<<
				[Field_type.binary_data, agent binary_data_string],
				[Field_type.encoding, agent {ID3_FRAME}.encoding_name],
				[Field_type.description, agent {ID3_FRAME}.description],
				[Field_type.integer, agent integer_string],
				[Field_type.language,agent {ID3_FRAME}.language],
				[Field_type.latin_1_string, agent {ID3_FRAME}.latin_1_string],
				[Field_type.string, agent {ID3_FRAME}.string],
				[Field_type.string_list, agent string_list_first]
			>>)
		end

	Source_dir: EL_DIR_PATH
		once
			Result := "data/id3$"
		end

	Square_brackets: ZSTRING
		once
			Result := "%S [%S]"
		end

	Bracket_suffix: ZSTRING
		once
			Result := " (%S)"
		end
end
