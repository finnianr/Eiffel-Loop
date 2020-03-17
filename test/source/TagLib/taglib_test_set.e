note
	description: "Tag info test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-17 18:25:34 GMT (Tuesday 17th March 2020)"
	revision: "20"

class
	TAGLIB_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		redefine
			on_clean
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_NAMING

	EL_MODULE_TUPLE

	EL_ZSTRING_CONSTANTS

	EL_SHARED_CONSOLE_COLORS

	TL_SHARED_PICTURE_TYPE_ENUM

	TEST_STRING_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
--			eval.call ("picture_edit", agent test_picture_edit)
			eval.call ("read_basic_id3", agent test_read_basic_id3)
			eval.call ("read_v2_frames", agent test_read_v2_frames)
			eval.call ("string_setting", agent test_string_setting)
			eval.call ("string_conversion", agent test_string_conversion)
		end

feature -- Tests

	test_picture_edit
		local
			mp3: TL_MPEG_FILE; picture: TL_ID3_PICTURE
			base_230: ZSTRING
		do
			base_230 := Picture_230_tag.twin
			base_230.remove_tail (4)

			file_list.find_first_true (agent {EL_FILE_PATH}.base_matches (base_230))
			if file_list.found then
				create mp3.make (file_list.path)
				create picture.make (Top_png_path, "Upwards arrow", Picture_type.other)
				mp3.tag.set_picture (picture)
				mp3.save
				mp3.dispose
				create mp3.make (file_list.path)
				assert ("same picture", picture ~ mp3.tag.picture)
				mp3.dispose
			else
				assert (Picture_230_tag + " not found", False)
			end
		end

	test_read_basic_id3
		do
			across file_list as path loop
				do_test (
					"print_tag", Checksum_table.item (path.item.base).print_tag,
					agent print_tag, [path.item.relative_path (Work_area_dir)]
				)
			end
		end

	test_read_v2_frames
		do
			across file_list as path loop
				do_test (
					"print_v2_frames", Checksum_table.item (path.item.base).print_frames,
					agent print_v2_frames, [path.item.relative_path (Work_area_dir)]
				)
			end
		end

	test_string_conversion
		local
			tl_string: TL_STRING
		do
			create tl_string.make_empty
			across Text_lines as line loop
				tl_string.set_from_string (line.item)
				assert ("same string", tl_string.to_string_32 (False) ~ line.item)
			end
		end

	test_string_setting
		local
			mp3: TL_MPEG_FILE; title: ZSTRING
		do
			across file_list as path loop
				create mp3.make (path.item)
				title := Text_lines.circular_i_th (path.cursor_index)
				if not mp3.tag.is_default then
					mp3.tag.set_title (title)
					assert ("title set", mp3.tag.title ~ title)
				end
			end
		end

feature {NONE} -- Implementation

	checksums (a_print_tag, a_print_frames: NATURAL): like Checksum_table.item
		do
			Result := [a_print_tag, a_print_frames]
		end

	print_field (name: STRING; value: ZSTRING)
		local
			list: EL_SPLIT_ZSTRING_LIST
		do
			if value.has ('%N') then
				if value.has_substring (CR_new_line) then
					create list.make (value, CR_new_line)
				else
					create list.make (value, character_string ('%N'))
				end
				log.put_labeled_string (name, "%"[")
				log.tab_right
				log.put_new_line
				across << list.first_item (True), n_character_string ('.', 2), list.last_item (True) >> as line loop
					log.put_string (line.item)
					if line.is_last then
						log.tab_left
					end
					log.put_new_line
				end
				log.set_text_color (Color.Yellow)
				log.put_string ("]%"")
				log.set_text_color (Color.Default)
			elseif value.count >= 80 then
				log.put_string_field_to_max_length (name, value, 80)
			else
				log.put_string_field (name, value)
			end
			log.put_new_line
		end

	print_tag (relative_path: EL_FILE_PATH)
		local
			mp3: TL_MPEG_FILE; tag: TL_ID3_TAG; field_string: ZSTRING
		do
			create mp3.make (Work_area_dir + relative_path)
			tag := mp3.tag
			print_version (mp3)
			if attached {TL_ID3_V2_TAG} tag as v2 and then v2.duration > 0 then
				lio.put_integer_field ("Duration", v2.duration)
				lio.put_new_line
			end
			across Field_table as field loop
				field_string := field.item (tag)
				if not field_string.is_empty then
					print_field (field.key, field_string)
				end
			end
		end

	print_v2_frames (relative_path: EL_FILE_PATH)
		local
			mp3: TL_MPEG_FILE; name: STRING
		do
			create mp3.make (Work_area_dir + relative_path)
			if mp3.has_version_1 then
				print_version (mp3)

			elseif attached {TL_ID3_V2_TAG} mp3.tag as tag then
				print_version (mp3)
				across tag.all_frames_list as frame loop
					name := Naming.class_as_upper_snake (frame.item, 1, 2)
					log.put_labeled_string (name, frame.item.id.to_string_8)
					if attached {TL_COMMENTS_ID3_FRAME} frame.item as comments then
						print_field ("; language", comments.language)
						print_field ("description", comments.description)
						print_field ("text", comments.text)
					elseif attached {TL_PICTURE_ID3_FRAME} frame.item as pic then
						log.put_string_field ("; mime_type", pic.mime_type)
						log.put_string_field ("; type", pic.type)
						log.put_integer_field ("; byte count", pic.picture.count)
						log.put_new_line
						print_field ("description", pic.description)
					elseif attached {TL_TEXT_IDENTIFICATION_ID3_FRAME} frame.item as text then
						log.put_new_line
						across text.field_list.arrayed as field loop
							print_field (Array_template #$ ["field_list", field.cursor_index], field.item)
						end
					else
						print_field ("; text", frame.item.text)
					end
				end
			else
				log.put_line ("Unknown version")
			end
		end

	print_version (mp3: TL_MPEG_FILE)
		do
			log.put_labeled_substitution ("Version", "%S.%S.%S", mp3.id3_version)
			log.put_new_line
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir, "*")
		end

feature {NONE} -- Events

	on_clean
		do
			{MEMORY}.full_collect
			Precursor {EL_COPIED_FILE_DATA_TEST_SET}
		end

feature {NONE} -- Constants

	Array_template: ZSTRING
		once
			Result := "%S [%S]"
		end

	CR_new_line: ZSTRING
		once
			Result := "%R%N"
		end

	Checksum_table: HASH_TABLE [TUPLE [print_tag, print_frames: NATURAL], STRING]
		once
			create Result.make (11)
			Result ["221-compressed.tag"] := checksums (2345267516, 3246236924)
			Result ["230-compressed.tag"] := checksums (237988789, 985249350)
			Result ["230-syncedlyrics.tag"] := checksums (474628871, 4124037141)
			Result [Picture_230_tag] := checksums (267318710, 32249346)
			Result ["230-unicode.tag"] := checksums (2150173072, 1124208054)
			Result ["ozzy.tag"] := checksums (4088983894, 3042106295)
			Result ["thatspot.tag"] := checksums (1455176272, 2234758446)

			-- MP3 extension
			Result ["240-silence.mp3"] := checksums (161761856, 1488597223)
			Result ["crc53865.mp3"] := checksums (4078009405, 3992252498)
		end

	Data_dir: EL_DIR_PATH
		once
			Result := EL_test_data_dir.joined_dir_path ("id3$")
		end

	Field_table: EL_HASH_TABLE [FUNCTION [TL_ID3_TAG, ZSTRING], STRING]
		once
			create Result.make (<<
				["album", agent {TL_ID3_TAG}.album],
				["artist", agent {TL_ID3_TAG}.artist],
				["comment", agent {TL_ID3_TAG}.comment],
				["title", agent {TL_ID3_TAG}.title]
			>>)
		end

	Picture_230_tag: ZSTRING
		once
			Result := "230-picture.tag"
		end

	Top_png_path: EL_FILE_PATH
		once
			Result := Eiffel_loop_dir + "doc/images/top.png"
		end

end
