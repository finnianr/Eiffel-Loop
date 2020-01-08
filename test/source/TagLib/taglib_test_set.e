note
	description: "Tag info test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 14:27:46 GMT (Wednesday 8th January 2020)"
	revision: "13"

class
	TAGLIB_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as Eiffel_loop_dir
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_LIO

	EL_MODULE_NAMING

	EL_MODULE_TUPLE

feature -- Tests

	test_read_basic_id3
		local
			mp3: TL_MPEG_FILE
		do
			across file_list as path loop
				create mp3.make (path.item)
				lio.put_path_field ("MP3", path.item.relative_path (Work_area_dir))
				lio.put_new_line
				if mp3.has_version_1 then
					print_tag (mp3.tag_v1)
				end
				if mp3.has_version_2 then
					print_tag (mp3.tag_v2)
				end
				lio.put_new_line
				mp3.dispose -- Allow deletion of files
			end
		end

	test_read_id3_frames
		local
			mp3: TL_MPEG_FILE
		do
			across file_list as path loop
				create mp3.make (path.item)
				lio.put_path_field ("MP3", path.item.relative_path (Work_area_dir))
				lio.tab_right
				lio.put_new_line
				if not mp3.has_version_2 then
					print_frames (mp3.tag_v2)
				end
				lio.tab_left
				lio.put_new_line
				mp3.dispose -- Allow deletion of files
			end
		end

feature {NONE} -- Implementation

	print_frames (tag: TL_ID3_V2_TAG)
		local
			name: STRING
		do
			across tag.all_frames_list as frame loop
				name := Naming.class_as_upper_snake (frame.item, 1, 2)
				lio.put_labeled_string (name, frame.item.id.to_string_8)
				lio.put_new_line
				if attached {TL_COMMENTS_ID3_FRAME} frame.item as comments then
					lio.put_string_field ("description", comments.description)
					lio.put_new_line
					lio.put_string_field ("text", comments.text)
					lio.put_new_line
					lio.put_string_field ("language", comments.language)
					lio.put_new_line
				elseif attached {TL_PICTURE_ID3_FRAME} frame.item as pic then
					lio.put_string_field ("description", pic.description)
					lio.put_new_line
					lio.put_string_field ("mime_type", pic.mime_type)
					lio.put_string_field ("; type", pic.type)
					lio.put_new_line
					lio.put_integer_field ("byte count", pic.picture.count)
					lio.put_new_line
				elseif attached {TL_TEXT_IDENTIFICATION_ID3_FRAME} frame.item as text then
					across text.field_list.arrayed as field loop
						lio.put_labeled_substitution ("field_list", Index_template, [field.cursor_index, field.item])
						lio.put_new_line
					end
				else
					lio.put_string_field ("text", frame.item.text)
					lio.put_new_line
				end
				lio.put_new_line
			end
		end

	print_tag (tag: TL_ID3_TAG)
		local
			header: TL_ID3_V2_HEADER; field_string: ZSTRING
		do
			lio.put_labeled_string ("Class", Naming.class_as_upper_snake (tag, 1, 1))
			lio.put_new_line
			across Field_table as field loop
				field_string := field.item (tag)
				if not field_string.is_empty then
					lio.put_labeled_string (field.key, field_string)
					lio.put_new_line
				end
			end
			if attached {TL_ID3_V2_TAG} tag as v2 then
				header := v2.header
				lio.put_integer_field ("major_version", header.major_version)
				lio.put_new_line
				lio.put_integer_field ("revision_number", header.revision_number)
				lio.put_new_line
			end
		end

	source_file_list: EL_FILE_PATH_LIST
		do
--			Result := OS.file_list (Eiffel_loop_dir.joined_dir_tuple (["contrib/C++/taglib/test_data"]), Filter.mp3)
			Result := OS.file_list (EL_test_data_dir.joined_dir_path ("id3$"), Filter.every)
		end

feature {NONE} -- Constants

	Field_table: EL_HASH_TABLE [FUNCTION [TL_ID3_TAG, ZSTRING], STRING]
		once
			create Result.make (<<
				["album", agent {TL_ID3_TAG}.album],
				["artist", agent {TL_ID3_TAG}.artist],
				["comment", agent {TL_ID3_TAG}.comment],
				["title", agent {TL_ID3_TAG}.title]
			>>)
		end

	Filter: TUPLE [every, mp3, tag: STRING]
		once
			create Result
			Tuple.fill (Result, "*, *.mp3, *.tag")
		end

	Index_template: ZSTRING
		once
			Result := "[%S] %S"
		end
end
