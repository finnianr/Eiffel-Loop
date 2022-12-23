note
	description: "ID3 tag edits"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-23 17:13:48 GMT (Friday 23rd December 2022)"
	revision: "18"

deferred class
	ID3_TAG_INFO_ROUTINES

inherit
	EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO

	EL_MODULE_TUPLE

	TL_SHARED_PICTURE_TYPE_ENUM

feature -- Basic operations

	set_fields_from_path (id3_info: TL_MPEG_FILE; relative_song_path: FILE_PATH)
			-- set genre and artist field from path, preserving any album artist info in the artist field
		local
			artist_dir, genre_dir: DIR_PATH
			album_artist: ZSTRING
		do
			artist_dir := relative_song_path.parent
			genre_dir := artist_dir.parent
			lio.put_path_field ("MP3 %S", relative_song_path)
			lio.put_new_line
			id3_info.tag.set_genre (genre_dir.base)
			if artist_dir.base /~ id3_info.tag.artist then
				album_artist := id3_info.tag.album_artist
				if album_artist.is_empty then
					album_artist := id3_info.tag.artist

				elseif not album_artist.ends_with_zstring (id3_info.tag.artist) then
					album_artist.append_string_general (once ", ")
					album_artist.append (id3_info.tag.artist)
				end

--				lio.put_labeled_string ("Genre", genre_dir.base)
--				lio.put_labeled_string (" Artist", artist_dir.base)
--				lio.put_labeled_string (" Album artists", album_artist)
--				lio.put_new_line

				id3_info.tag.set_artist (artist_dir.base)
				id3_info.tag.set_album_artist (album_artist)
			end
			id3_info.save
		end

	delete_id3_comments (id3_info: TL_MPEG_FILE; relative_song_path: FILE_PATH)
		local
			is_changed: BOOLEAN; pos_colon: INTEGER
			text, description: ZSTRING
		do
			if id3_info.tag.has_comment then
				print_id3 (id3_info, relative_song_path)
				across id3_info.tag.comment_list as list loop
					text := list.item.text
					description := list.item.description
					lio.put_string_field (description, text)
					lio.put_new_line
					if description ~ ID3_frame.comment then
						pos_colon := text.index_of (':', 1)
						if pos_colon > 0 and then Comment_fields.has (text.substring (1, pos_colon - 1)) then
							id3_info.tag.set_comment_with (ID3_frame.c0, text)
							is_changed := True
						end

					elseif description ~ ID3_frame.performers then
						id3_info.tag.set_comment_with (ID3_frame.c0, ID3_frame.performers + ": " + text)
						is_changed := True

					end
					if description /~ ID3_frame.c0 then
						id3_info.tag.remove_comment (description)
						is_changed := True
					end
				end
				if is_changed then
					id3_info.save
				end
				lio.put_new_line
			end
		end

	normalize_comment (id3_info: TL_MPEG_FILE; relative_song_path: FILE_PATH)
			-- rename comment description 'Comment' as 'c0'
			-- This is an antidote to a bug in Rhythmbox version 2.97 where editions to
			-- 'c0' command are saved as 'Comment' and are no longer visible on reload.
		local
			text: ZSTRING
		do
			if id3_info.tag.has_comment_with (ID3_frame.comment) then
				text := id3_info.tag.comment_with (ID3_frame.comment).text
				id3_info.tag.remove_comment (ID3_frame.comment)
				if not id3_info.tag.has_comment_with (ID3_frame.c0) then
					id3_info.tag.set_comment_with (ID3_frame.c0, text)
				end
				print_id3_comments (id3_info, relative_song_path)
				id3_info.save
			end
		end

	print_id3_comments (id3_info: TL_MPEG_FILE; relative_song_path: FILE_PATH)
		local
			comment_list: LIST [TL_COMMENTS]
		do
			comment_list := id3_info.tag.comment_list
			if not comment_list.is_empty then
				print_id3 (id3_info, relative_song_path)
				across comment_list as list loop
					lio.put_string_field (list.item.description, list.item.text.out)
					lio.put_new_line
				end
				lio.put_new_line
			end
		end

	id3_test (id3_info: TL_MPEG_FILE; relative_song_path: FILE_PATH)
		local
			mtime: INTEGER
		do
			print_id3 (id3_info, relative_song_path)
			mtime := File.modification_time (id3_info.path)
--			mtime := mtime & File.byte_count (id3_info.mp3_path)
			lio.put_integer_field ("File time", mtime)
			lio.put_new_line

			lio.put_integer_field ("Rhythmdb", 1383852243)
			lio.put_new_line

		end

	print_id3 (id3_info: TL_MPEG_FILE; relative_song_path: FILE_PATH)
		do
			lio.put_path_field ("Song %S", relative_song_path)
			lio.put_labeled_string (" Version", id3_info.formatted_version)
			lio.put_new_line
		end

	set_version_23 (id3_info: TL_MPEG_FILE; relative_song_path: FILE_PATH)
		do
			print_id3 (id3_info, relative_song_path)
			id3_info.save_version (3)
		end

feature {NONE} -- Constants

	ID3_frame: TUPLE [c0, comment, performers: ZSTRING]
			-- c0 = Rhythmbox standard comment description
			-- Comment = Rhythmbox non-standard comment description
		once
			create Result
			Tuple.fill (Result, "c0, Comment, Performers")
		end

	Comment_fields: EL_ZSTRING_LIST
		once
			Result := "Artists, Singers"
		end
end