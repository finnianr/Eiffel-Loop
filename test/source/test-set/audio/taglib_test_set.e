note
	description: "Tag info test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 15:44:42 GMT (Thursday   31st   October   2019)"
	revision: "7"

class
	TAGLIB_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EL_MODULE_LIO

	EL_MODULE_NAMING

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
				if mp3.has_version_2 then
					lio.put_path_field ("MP3", path.item.relative_path (Work_area_dir))
					lio.put_new_line
					print_frames (mp3.tag_v2)
					lio.put_new_line
				end
				mp3.dispose -- Allow deletion of files
			end
		end

feature {NONE} -- Implementation

	print_frames (tag: TL_ID3_V2_TAG)
		local
			name: STRING
		do
			across tag.iterable_frame_list as frame loop
				name := Naming.class_as_upper_snake (frame.item, 1, 2)
				lio.put_labeled_string (name, frame.item.id.to_string)
				lio.put_new_line
				if attached {TL_COMMENTS_ID3_FRAME} frame.item as comments then
					lio.put_string_field ("description", comments.description.to_string)
					lio.put_new_line
					lio.put_string_field ("text", comments.text.to_string)
					lio.put_new_line
					lio.put_string_field ("language", comments.language.to_string)
					lio.put_new_line
				elseif attached {TL_PICTURE_ID3_FRAME} frame.item as pic then
					lio.put_string_field ("description", pic.description.to_string)
					lio.put_new_line
					lio.put_string_field ("mime_type", pic.mime_type.to_string)
					lio.put_new_line
					lio.put_integer_field ("size", pic.picture.size.to_integer_32)
					lio.put_new_line
				elseif attached {TL_TEXT_IDENTIFICATION_ID3_FRAME} frame.item as text then
					across text.field_list.arrayed as field loop
						lio.put_labeled_substitution ("field_list", Index_template, [field.cursor_index, field.item.to_string])
						lio.put_new_line
					end
				else
					lio.put_string_field ("text", frame.item.text.to_string)
					lio.put_new_line
				end
				lio.put_new_line
			end
		end

	print_tag (tag: TL_ID3_TAG)
		local
			header: TL_ID3_V2_HEADER; field_string: TL_STRING
		do
			lio.put_labeled_string ("Class", Naming.class_as_upper_snake (tag, 1, 1))
			lio.put_new_line
			across Field_table as field loop
				field_string := field.item (tag)
				if not field_string.is_empty then
					lio.put_labeled_string (field.key, field_string.to_string)
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
			Result := OS.file_list (Eiffel_loop_dir.joined_dir_tuple (["contrib/C++/taglib/test_data"]), filter)
		end

feature {NONE} -- Constants

	Field_table: EL_HASH_TABLE [FUNCTION [TL_ID3_TAG, TL_STRING], STRING]
		once
			create Result.make (<<
				["album", agent {TL_ID3_TAG}.album],
				["artist", agent {TL_ID3_TAG}.artist],
				["comment", agent {TL_ID3_TAG}.comment],
				["title", agent {TL_ID3_TAG}.title]
			>>)
		end

	Filter: STRING = "*.mp3"

	Index_template: ZSTRING
		once
			Result := "[%S] %S"
		end
end
