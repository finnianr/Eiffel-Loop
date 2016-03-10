note
	description: "Summary description for {ID3_EDIT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ID3_EDITS

inherit
	ID3_EDIT_CONSTANTS

	EL_MODULE_TAG

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

	EL_MODULE_TIME

feature -- Basic operations

	delete_id3_comments (relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
		local
			l_frame: EL_ID3_FRAME
			frame_string: EL_ASTRING
			is_changed: BOOLEAN
			pos_colon: INTEGER
		do
			if not id3_info.comment_table.is_empty then
				print_id3 (relative_song_path, id3_info)
				across id3_info.comment_table.current_keys as key loop
					l_frame := id3_info.comment_table [key.item]
					frame_string := l_frame.out
					log_or_io.put_string_field (key.item, frame_string)
					log_or_io.put_new_line
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
				log_or_io.put_new_line
			end
		end

	normalize_comment (relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
			-- rename comment description 'Comment' as 'c0'
			-- This is an antidote to a bug in Rhythmbox version 2.97 where editions to
			-- 'c0' command are saved as 'Comment' and are no longer visible on reload.
		local
			text: EL_ASTRING
		do
			id3_info.comment_table.search (ID3_frame_comment)
			if id3_info.comment_table.found then
				text := id3_info.comment_table.found_item.string
				id3_info.remove_comment (ID3_frame_comment)
				if not id3_info.comment_table.has (ID3_frame_c0) then
					id3_info.set_comment (ID3_frame_c0, text)
				end
				print_id3_comments (relative_song_path, id3_info)
				id3_info.update
			end
		end

	print_id3_comments (relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
		do
			if not id3_info.comment_table.is_empty then
				print_id3 (relative_song_path, id3_info)
				across id3_info.comment_table as comment loop
					log_or_io.put_string_field (comment.item.description, comment.item.out)
					log_or_io.put_new_line
				end
				log_or_io.put_new_line
			end
		end

	test (relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
		local
			mtime: INTEGER
		do
			print_id3 (relative_song_path, id3_info)
			mtime := Time.unix_date_time (id3_info.mp3_path.modification_time)
--			mtime := mtime & File_system.file_byte_count (id3_info.mp3_path)
			log_or_io.put_integer_field ("File time", mtime)
			log_or_io.put_new_line

			log_or_io.put_integer_field ("Rhythmdb", 1383852243)
			log_or_io.put_new_line

		end

	print_id3 (relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
		do
			log_or_io.put_path_field ("Song", relative_song_path)
			log_or_io.put_real_field (" Version", id3_info.version)
			log_or_io.put_new_line
		end

	set_version_23 (relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
		do
			print_id3 (relative_song_path, id3_info)

			id3_info.set_version (2.3)
			id3_info.update
		end

	save_album_picture_id3 (relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO; name: EL_ASTRING)
		local
			jpg_file: RAW_FILE
			album_picture: EL_ID3_ALBUM_PICTURE
		do
			print_id3_comments (relative_song_path, id3_info)
			if id3_info.has_album_picture then
				print_id3 (relative_song_path, id3_info)
				create jpg_file.make_open_write (id3_info.mp3_path.with_new_extension ("jpg").unicode)
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
