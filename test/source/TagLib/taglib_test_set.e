note
	description: "Tag info test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-24 13:47:15 GMT (Tuesday 24th March 2020)"
	revision: "26"

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

	EL_MODULE_DIGEST

	EL_MODULE_NAMING

	EL_MODULE_TUPLE

	EL_ZSTRING_CONSTANTS

	EL_SHARED_CONSOLE_COLORS

	TL_SHARED_PICTURE_TYPE_ENUM

	TL_SHARED_ONCE_STRING_LIST

	TEST_STRING_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("comments", agent test_comments)
			eval.call ("picture_edit", agent test_picture_edit)
			eval.call ("picture_mime_types", agent test_picture_mime_types)
			eval.call ("get_set_basic_fields", agent test_get_set_basic_fields)
			eval.call ("read_frames_v2_x", agent test_read_v2_frames)
			eval.call ("string_conversion", agent test_string_conversion)
			eval.call ("string_list", agent test_string_list)
			eval.call ("string_setting", agent test_string_setting)
			eval.call ("ufid", agent test_ufid)
			eval.call ("user_text", agent test_user_text)
			eval.call ("major_version_change", agent test_major_version_change)
		end

feature -- Tests

	test_comments
		local
			mp3: TL_MPEG_FILE; preference: ZSTRING; musicmatch: STRING
			table: EL_HASH_TABLE [STRING, STRING]
		do
			musicmatch := "MusicMatch_"
			create table.make (<<
				["Tempo", "Pretty fast"], ["Mood", "Upbeat"], ["Situation", "Any"], ["Preference", "Excellent"]
			>>)
			file_list.find_first_base (That_spot_tag)
			assert ("exists", file_list.found)
			create mp3.make (file_list.path)
			across table as text loop
				assert ("same string", mp3.tag.comment_with (musicmatch + text.key).text.same_string (text.item))
			end

			create table.make (<<
				["First_line", "In that spot, over here in that spot."], -- Test new comment
				["Preference", "5 stars"]
			>>)
			across table as text loop
				mp3.tag.set_comment_with (musicmatch + text.key, text.item)
				assert ("same string", mp3.tag.comment_with (musicmatch + text.key).text.same_string (text.item))
			end
		end

	test_picture_edit
		local
			mp3: TL_MPEG_FILE; picture: TL_ID3_PICTURE
		do
			file_list.find_first_base (Picture_230_tag)
			if file_list.found then
				create mp3.make (file_list.path)
				create picture.make (Top_png_path, "Upwards arrow", Picture_type.other)
				mp3.tag.set_picture (picture)
				mp3.save
				mp3.dispose
				create mp3.make (file_list.path)
				assert ("same picture", picture ~ mp3.tag.picture)
			else
				assert (Picture_230_tag + " not found", False)
			end
		end

	test_picture_mime_types
		local
			picture: TL_ID3_PICTURE
			table: EL_HASH_TABLE [STRING, STRING]
		do
			create table.make (<<
				["pic.jpeg", "image/jpeg"], ["pic.jpg", "image/jpeg"], ["pic.png", "image/png"]
			>>)
			across table as pic loop
				create picture.make (pic.key, "", Picture_type.other)
				assert ("valid mime type", picture.mime_type ~ pic.item)
			end
		end

	test_get_set_basic_fields
		do
			across file_list as path loop
				do_test (
					"get_set_basic_fields", Checksum_table.item (path.item.base).get_set_basic_fields,
					agent get_set_basic_fields, [path.item.relative_path (Work_area_dir)]
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

	test_string_list
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_with_separator ("one, two, three", ',', True)
			Once_string_list.wipe_out
			Once_string_list.append (list)
			assert ("same list", list ~ Once_string_list.to_list)
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

	test_ufid
		local
			mp3: TL_MPEG_FILE; ufid: TL_UNIQUE_FILE_IDENTIFIER
			ufid_list: ARRAYED_LIST [TL_UNIQUE_FILE_IDENTIFIER]
			owner: ZSTRING; id: STRING
		do
			file_list.find_first_base (Unicode_230_tag)
			create ufid_list.make (2)
			if file_list.found then
				create mp3.make (file_list.path)
				across << "FJR", "MGH" >> as owner_id loop
					owner := owner_id.item; id := Digest.md5 (owner_id.item).to_base_64_string
					mp3.tag.set_unique_id (owner, id)
					ufid := mp3.tag.unique_id (owner)
					ufid_list.extend (ufid)
					assert ("not default", not ufid.is_default)
					assert ("same owner", owner ~ ufid.owner)
					assert ("same id", id ~ ufid.identifier)
				end
				across mp3.tag.unique_id_list as l_ufid loop
					assert ("same identifier", l_ufid.item.same_as (ufid_list.i_th (l_ufid.cursor_index)))
				end
			end
		end

	test_user_text
		local
			mp3: TL_MPEG_FILE; title: ZSTRING
			user_text_table: EL_HASH_TABLE [STRING, STRING]
			count: INTEGER
		do
			create user_text_table.make (<<
				["compression example", "This sample user text"],
				["example text frame", "This text and the description"]
			>>)
			across file_list as path loop
				create mp3.make (path.item)
				if mp3.tag.has_user_text then
					across user_text_table as text loop
						if mp3.tag.has_user_text_with (text.key) then
							assert ("text starts with", mp3.tag.user_text (text.key).starts_with_general (text.item))
							mp3.tag.set_user_text (text.key, text.item)
							assert ("same text", text.item ~ mp3.tag.user_text (text.key).to_latin_1)
							count := count + 1
						end
					end
				end
			end
			assert ("all examples found", count = user_text_table.count)
		end

	test_major_version_change
		local
			mp3: TL_MPEG_FILE
		do
			file_list.find_first_base (Silence_240_mp3)
			if file_list.found then
				create mp3.make (file_list.path)
				assert ("major version 4", mp3.id3_version.major = 4)
				mp3.save_version (3)
				mp3.dispose
				create mp3.make (file_list.path)
				assert ("major version 3", mp3.id3_version.major = 3)
			end
		end

feature {NONE} -- Implementation

	enclosed (a_str: ZSTRING): ZSTRING
		do
			Result := a_str.enclosed ('(', ')')
		end

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

	get_set_basic_fields (relative_path: EL_FILE_PATH)
		local
			mp3: TL_MPEG_FILE; tag: TL_ID3_TAG; field_string, string: ZSTRING
			value, index: INTEGER
		do
			create mp3.make (Work_area_dir + relative_path)
			tag := mp3.tag
			print_version (mp3)
			if tag.version > 0 then
				across Get_set_names as name loop
					index := (name.cursor_index - 1) * 2 + 1
					if attached {FUNCTION [TL_ID3_TAG, ZSTRING]} Get_set_routines [index] as get_string then
						field_string := get_string (tag)
						if not field_string.is_empty then
							print_field (name.item, field_string)
						end
						if attached {PROCEDURE [TL_ID3_TAG, READABLE_STRING_GENERAL]} Get_set_routines [index + 1] as set_string then
							if field_string.starts_with_general ("THAT SPOT") then
								-- why is post-condition failing?
							else
								field_string := enclosed (field_string)
							end
							set_string (tag, field_string)
							string := get_string (tag)
							assert ("same string", get_string (tag) ~ field_string)
						end
					elseif attached {FUNCTION [TL_ID3_TAG, INTEGER]} Get_set_routines [index] as get_integer then
						value := get_integer (tag)
						if value > 0 then
							log.put_integer_field (name.item, value)
							log.put_new_line
							if attached {PROCEDURE [TL_ID3_TAG, INTEGER]} Get_set_routines [index + 1] as set_integer then
								set_integer (tag, value + 1)
								assert ("same value", get_integer (tag) = value + 1)
							end
						end
					end
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
						if attached {TL_USER_TEXT_IDENTIFICATION_ID3_FRAME} text as user then
							log.put_string_field ("; description", user.description)
						end
						log.put_new_line
						across text.field_list as field loop
							print_field (Array_template #$ ["field_list", field.cursor_index], field.item)
						end

					elseif attached {TL_UNIQUE_FILE_IDENTIFIER_ID3_FRAME} frame.item as l_unique then
						log.put_string_field ("; identifier", l_unique.identifier)
						log.put_string_field ("; owner", l_unique.owner)
						log.put_new_line
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

	Checksum_table: HASH_TABLE [TUPLE [get_set_basic_fields, print_frames: NATURAL], STRING]
		once
			create Result.make (11)
			Result ["221-compressed.tag"] := checksums (3085819510, 3246236924)
			Result ["230-compressed.tag"] := checksums (839599359, 3424301073)
			Result ["230-syncedlyrics.tag"] := checksums (1669786640, 4124037141)
			Result [Picture_230_tag] := checksums (1095970239, 32249346)
			Result [Unicode_230_tag] := checksums (109896957, 3709611927)
			Result ["ozzy.tag"] := checksums (3778416931, 3042106295)
			Result [That_spot_tag] := checksums (4253022495, 2234758446)

			-- MP3 extension
			Result [Silence_240_mp3] := checksums (3490969276, 1488597223)
			Result ["crc53865.mp3"] := checksums (1317037298, 3992252498)
		end

	Data_dir: EL_DIR_PATH
		once
			Result := EL_test_data_dir.joined_dir_path ("id3$")
		end

	Get_set_routines: ARRAY [ROUTINE]
		once
			Result := <<
				agent {TL_ID3_TAG}.album, agent {TL_ID3_TAG}.set_album,
				agent {TL_ID3_TAG}.artist, agent {TL_ID3_TAG}.set_artist,
				agent {TL_ID3_TAG}.comment, agent {TL_ID3_TAG}.set_comment,
				agent {TL_ID3_TAG}.genre, agent {TL_ID3_TAG}.set_genre,
				agent {TL_ID3_TAG}.title, agent {TL_ID3_TAG}.set_title,
				agent {TL_ID3_TAG}.track, agent {TL_ID3_TAG}.set_track,
				agent {TL_ID3_TAG}.year, agent {TL_ID3_TAG}.set_year
			>>
		ensure
			twice_number_of_names: Result.count // Get_set_names.count = 2
		end

	Get_set_names: EL_STRING_8_LIST
		once
			create Result.make_with_separator ("album, artist, comment, genre, title, track, year", ',', True)
		end

	Unicode_230_tag: ZSTRING
		once
			Result := "230-unicode.tag"
		end

	Picture_230_tag: ZSTRING
		once
			Result := "230-picture.tag"
		end

	Silence_240_mp3: ZSTRING
		once
			Result := "240-silence.mp3"
		end

	That_spot_tag: ZSTRING
		once
			Result := "thatspot.tag"
		end

	Top_png_path: EL_FILE_PATH
		once
			Result := Eiffel_loop_dir + "doc/images/top.png"
		end

end
