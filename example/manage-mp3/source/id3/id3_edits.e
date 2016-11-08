note
	description: "Summary description for {ID3_EDIT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-12 7:57:46 GMT (Wednesday 12th October 2016)"
	revision: "2"

class
	ID3_EDITS

inherit
	ID3_EDIT_CONSTANTS

	EL_MODULE_TAG

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

	EL_MODULE_TIME

feature -- Basic operations

	set_fields_from_path (id3_info: EL_ID3_INFO; relative_song_path: EL_FILE_PATH)
			-- set genre and artist field from path, preserving any album artist info in the artist field
		local
			artist_dir, genre_dir: EL_DIR_PATH
			album_artist: ZSTRING
		do
			artist_dir := relative_song_path.parent
			genre_dir := artist_dir.parent
			lio.put_path_field ("MP3", relative_song_path)
			lio.put_new_line
			id3_info.set_genre (genre_dir.base)
			if artist_dir.base /~ id3_info.artist then
				album_artist := id3_info.album_artist
				if album_artist.is_empty then
					album_artist := id3_info.artist

				elseif not album_artist.ends_with (id3_info.artist) then
					album_artist.append_string_general (once ", ")
					album_artist.append (id3_info.artist)
				end

--				lio.put_labeled_string ("Genre", genre_dir.base)
--				lio.put_labeled_string (" Artist", artist_dir.base)
--				lio.put_labeled_string (" Album artists", album_artist)
--				lio.put_new_line

				id3_info.set_artist (artist_dir.base)
				id3_info.set_album_artist (album_artist)
			end
			id3_info.update
		end

	remove_rbox_id (id3_info: EL_ID3_INFO; relative_song_path: EL_FILE_PATH)
		do
			id3_info.remove_unique_id ("http://musicbrainz.org")
			id3_info.set_unique_id ("http://musicbrainz.org", "E5A98512-B327-2590-B57F-1516280FE58A")
			id3_info.update
		end

	delete_id3_comments (id3_info: EL_ID3_INFO; relative_song_path: EL_FILE_PATH)
		local
			l_frame: EL_ID3_FRAME; frame_string: ZSTRING; is_changed: BOOLEAN; pos_colon: INTEGER
		do
			if not id3_info.comment_table.is_empty then
				print_id3 (id3_info, relative_song_path)
				across id3_info.comment_table.current_keys as key loop
					l_frame := id3_info.comment_table [key.item]
					frame_string := l_frame.out
					lio.put_string_field (key.item, frame_string)
					lio.put_new_line
					if key.item.is_equal (ID3_frame_comment) then
						pos_colon := l_frame.string.index_of (':', 1)
						if pos_colon > 0 and then Comment_fields.has (l_frame.string.substring (1, pos_colon - 1)) then
							id3_info.set_comment (ID3_frame_c0, l_frame.string)
							is_changed := True
						end

					elseif key.item.is_equal (Id3_frame_performers) then
						id3_info.set_comment (ID3_frame_c0, Id3_frame_performers + ": " + l_frame.string)
						is_changed := True

					end
					if not key.item.is_equal (ID3_frame_c0) then
						id3_info.remove_comment (key.item)
						is_changed := True
					end
				end
				if is_changed then
					id3_info.update
				end
				lio.put_new_line
			end
		end

	normalize_comment (id3_info: EL_ID3_INFO; relative_song_path: EL_FILE_PATH)
			-- rename comment description 'Comment' as 'c0'
			-- This is an antidote to a bug in Rhythmbox version 2.97 where editions to
			-- 'c0' command are saved as 'Comment' and are no longer visible on reload.
		local
			text: ZSTRING
		do
			id3_info.comment_table.search (ID3_frame_comment)
			if id3_info.comment_table.found then
				text := id3_info.comment_table.found_item.string
				id3_info.remove_comment (ID3_frame_comment)
				if not id3_info.comment_table.has (ID3_frame_c0) then
					id3_info.set_comment (ID3_frame_c0, text)
				end
				print_id3_comments (id3_info, relative_song_path)
				id3_info.update
			end
		end

	print_id3_comments (id3_info: EL_ID3_INFO; relative_song_path: EL_FILE_PATH)
		do
			if not id3_info.comment_table.is_empty then
				print_id3 (id3_info, relative_song_path)
				across id3_info.comment_table as comment loop
					lio.put_string_field (comment.item.description, comment.item.out)
					lio.put_new_line
				end
				lio.put_new_line
			end
		end

	test (id3_info: EL_ID3_INFO; relative_song_path: EL_FILE_PATH)
		local
			mtime: INTEGER
		do
			print_id3 (id3_info, relative_song_path)
			mtime := Time.unix_date_time (id3_info.mp3_path.modification_date_time)
--			mtime := mtime & File_system.file_byte_count (id3_info.mp3_path)
			lio.put_integer_field ("File time", mtime)
			lio.put_new_line

			lio.put_integer_field ("Rhythmdb", 1383852243)
			lio.put_new_line

		end

	print_id3 (id3_info: EL_ID3_INFO; relative_song_path: EL_FILE_PATH)
		do
			lio.put_path_field ("Song", relative_song_path)
			lio.put_real_field (" Version", id3_info.version)
			lio.put_new_line
		end

	set_version_23 (id3_info: EL_ID3_INFO; relative_song_path: EL_FILE_PATH)
		do
			print_id3 (id3_info, relative_song_path)

			id3_info.set_version (2.3)
			id3_info.update
		end

	save_album_picture_id3 (id3_info: EL_ID3_INFO; relative_song_path: EL_FILE_PATH; name: ZSTRING)
		local
			jpg_file: RAW_FILE
			album_picture: EL_ID3_ALBUM_PICTURE
		do
			print_id3_comments (id3_info, relative_song_path)
			if id3_info.has_album_picture then
				print_id3 (id3_info, relative_song_path)
				create jpg_file.make_open_write (id3_info.mp3_path.with_new_extension ("jpg"))
				album_picture := id3_info.album_picture
				jpg_file.put_managed_pointer (album_picture.data, 0, album_picture.data.count)
				jpg_file.close
			else
				create album_picture.make_from_file (id3_info.mp3_path.parent + (name + ".jpeg"), name)
				id3_info.set_album_picture (album_picture)
				id3_info.set_user_text ("picture checksum", album_picture.checksum.out)
			end
			id3_info.set_version (2.3)
			id3_info.update
		end

end
