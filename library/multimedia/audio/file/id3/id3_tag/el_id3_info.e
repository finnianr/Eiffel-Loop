note
	description: "Id3 info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_ID3_INFO

inherit
	EL_ID3_ENCODINGS
		export
			{NONE} all
		redefine
			default_create
		end

	EL_MEMORY
		export
			{NONE} all
		undefine
			default_create
		end

	EL_MODULE_TAG

create
	make, make_version, make_version_23

feature {NONE} -- Initialization

	default_create
		do
			create unique_id_list.make
			create comment_table.make_equal (5)
			create user_text_table.make_equal (3)
			create basic_fields.make (10); basic_fields.compare_objects
			create internal_album_picture.make (0)
			encoding := Default_encoding
		end

	make (a_mp3_path: EL_FILE_PATH)
	 		--
		do
			make_version (a_mp3_path, 0.0)
		end

	make_version (a_mp3_path: EL_FILE_PATH; a_version: REAL)
		require
			valid_version: a_version /~ 0.0 implies a_version >= 2.2 and a_version <= 2.4
		local
			real: REAL
		do
			default_create
			create header.make (a_mp3_path)
			if header.is_valid then
				if a_version ~ real.zero then
					implementation := new_implementation (header.version)
				else
					implementation := new_implementation (a_version)
				end
				implementation.link_and_read (a_mp3_path)

				initialize_tables
				set_encoding_from_basic_fields
			else
				-- Create an empty ID3 2.3 set
				create {EL_LIBID3_TAG_INFO} implementation.make
				implementation.link (a_mp3_path)
				update
				create header.make (a_mp3_path)
			end
		end

	make_version_23 (id3_info: like Current)
			-- make version 2.3 id3
		do
			default_create
			create header.make (id3_info.mp3_path)

			create {EL_LIBID3_TAG_INFO} implementation.make
			implementation.set_version (2.3)
			header.set_version (2.3)

			-- Link without reading tags as they might be version 2.4 which will cause problems with libid3
			implementation.link (id3_info.mp3_path)
			encoding := id3_info.encoding

			across id3_info.basic_fields as field loop
				set_field_string (field.key, field.item.string, encoding)
			end
			across id3_info.comment_table as entry loop
				set_comment (entry.key, entry.item.string)
			end
			across id3_info.user_text_table as entry loop
				set_user_text (entry.key, entry.item.string)
			end
			across id3_info.unique_id_list as unique_id loop
				set_unique_id (unique_id.item.owner, unique_id.item.id)
			end
			if id3_info.has_album_picture then
				set_album_picture (id3_info.album_picture)
			end
		end

	initialize_tables
		local
			field: EL_ID3_FRAME
			name, value: ZSTRING
		do
--			log.enter ("initialize_tables")
			across fields as l_field loop
				field := l_field.item
				if attached {EL_ID3_UNIQUE_FILE_ID} field as unique_id_field and then not unique_id_field.id.is_empty then
					unique_id_list.extend (unique_id_field)
					name := unique_id_field.owner; value := unique_id_field.id

				elseif attached {EL_ALBUM_PICTURE_ID3_FRAME} field as picture_field then
					internal_album_picture.extend (picture_field)
					name := picture_field.description
					value := picture_field.picture.checksum.out

				elseif field.code ~ Tag.User_text then
					user_text_table [field.description] := field
					name := field.description; value := field.string

				elseif field.code ~ Tag.Comment then
					if field.description.is_empty then
						create name.make_empty
						name.append_string_general ("COMM_")
						name.append_integer (comment_table.count + 1)
					else
						name := field.description
					end
					comment_table.put (field, name)
					value := field.string

				elseif Tag.Basic.has (field.code) then
					basic_fields [field.code] := field
					name := Encoding_names [field.encoding]
					if field.code ~ Tag.Album_picture then
						value := field.out
					else
						value := field.string
					end

				else
					name := Encoding_names [field.encoding]; value := field.string

				end
--				log.put_string_field (field.code + " (" + name + ")", value)
--				log.put_new_line
			end
--			log.exit
		end

feature -- Basic fields

	title: ZSTRING
			--
		do
			Result := field_string (Tag.Title)
		end

	artist: ZSTRING
			--
		do
			Result := field_string (Tag.Artist)
		end

	album: ZSTRING
			--
		do
			Result := field_string (Tag.Album)
		end

	album_artist: ZSTRING
			--
		do
			Result := field_string (Tag.Album_artist)
		end

	album_picture: EL_ID3_ALBUM_PICTURE
		do
			if has_album_picture then
--				log_or_io.put_string_field ("APIC", basic_fields.item (Tag.album_picture).out)
--				log_or_io.put_new_line
				Result := internal_album_picture.first.picture
			else
				create Result
			end
		end

	composer: ZSTRING
			--
		do
			Result := field_string (Tag.Composer)
		end

	genre: ZSTRING
			--
		do
			Result := field_string (Tag.Genre)
		end

	year: INTEGER
			--
		do
			Result := field_integer (Tag.Recording_time)
			if Result = 0 then
				Result := field_integer (Tag.Year)
			end
		end

	track: INTEGER
			--
		do
			Result := field_integer (Tag.Track)
		end

	duration: TIME
			--
		do
			create Result.make_by_fine_seconds (field_integer (Tag.duration) / 1000)
		end

 	basic_fields: HASH_TABLE [EL_ID3_FRAME, STRING]
 		-- Basic field frames

feature -- Access

	header: EL_ID3_HEADER

	version: REAL
			--
		do
			Result := header.version
		end

	major_version: INTEGER
			--
		do
			Result := 2
		end

	comment (a_key: ZSTRING): ZSTRING
			--
		do
			Result := table_text (a_key, comment_table)
		end

	user_text (a_key: ZSTRING): ZSTRING
			--
		do
			Result := table_text (a_key, user_text_table)
		end

	unique_id_for_owner (owner: ZSTRING): STRING
			--
		do
			create Result.make_empty
			from unique_id_list.start until unique_id_list.after loop
				if unique_id_list.item.owner ~ owner then
					Result := unique_id_list.item.id
				end
				unique_id_list.forth
			end
		end

	field_string (id: STRING): ZSTRING
				--
		do
			Result := field_of_type (agent {EL_ID3_FRAME}.string, id)
		end

	field_language (id: STRING): ZSTRING
				--
		do
			Result := field_of_type (agent {EL_ID3_FRAME}.string, id)
		end

	field_description (id: STRING): ZSTRING
				--
		do
			Result := field_of_type (agent {EL_ID3_FRAME}.description, id)
		end

	field_summary (id: STRING): ZSTRING
				--
		do
			Result := field_of_type (agent {EL_ID3_FRAME}.out_z, id)
		end

	field_integer (id: STRING): INTEGER
			--
		local
			l_str: ZSTRING
		do
			l_str := field_string (id)
			if l_str.is_integer then
				Result := l_str.to_integer
			end
		end

	fields_with_id (id: STRING): LINKED_LIST [EL_ID3_FRAME]
				--
		local
		 		i: INTEGER
		do
				create Result.make
				from i := 1 until i > fields.count loop
					if fields.i_th (i).code ~ id then
						Result.extend (fields.i_th (i))
					 end
					i := i + 1
				end
		end

	encoding_name: STRING
			--
		do
			Result := Encoding_names [encoding]
		end

	encoding: INTEGER

	mp3_path: EL_FILE_PATH
		do
			Result := implementation.mp3_path
		end

	comment_table: EL_ZSTRING_HASH_TABLE [EL_ID3_FRAME]

 	user_text_table: EL_ZSTRING_HASH_TABLE [EL_ID3_FRAME]

	unique_id_list: LINKED_LIST [EL_ID3_UNIQUE_FILE_ID]

feature -- Status report

	is_libid3_implementation: BOOLEAN
			--
		do
			Result := attached {EL_LIBID3_TAG_INFO} implementation
		end

	has_multiple_owners_for_UFID: BOOLEAN
		do
			Result := across unique_id_owner_counts as count some count.item > 1 end
		end

	has_album_picture: BOOLEAN
		do
			Result := not internal_album_picture.is_empty
		end

	has_unique_id (owner: ZSTRING): BOOLEAN
			--
		do
			Result := across unique_id_list as unique_file_id some unique_file_id.item.owner ~ owner end
		end

	duplicates_found: BOOLEAN

 feature -- Element change

	set_beats_per_minute (a_beats_per_minute: INTEGER)
			--
		do
			set_beats_per_minute_from_string (a_beats_per_minute.out)
		end

	set_beats_per_minute_from_string (a_beats_per_minute: ZSTRING)
			--
		do
			set_field_string (Tag.Beats_per_minute, a_beats_per_minute, encoding)
		end

	set_encoding (a_name: STRING)
			--
		local
			l_encoding: INTEGER
			l_changed: BOOLEAN
		do
			l_encoding := Encoding_unknown
			across Encoding_names as name loop
				if name.item ~ a_name.as_upper then
					l_encoding := name.key
				end
			end
			if l_encoding /= Encoding_unknown then
				encoding := l_encoding
				across fields as field loop
					if field.item.encoding /= encoding then
						l_changed := True
						field.item.set_encoding (encoding)
					end
				end
				if l_changed then
					update
				end
			end
		end

	set_music_brainz_track_id (track_id: STRING)
		do
			remove_unique_id (Http_musicbrainz_org)
			set_unique_id (Http_musicbrainz_org, track_id)
		end

	set_music_brainz_field (name: STRING; value: ZSTRING)
		require
			valid_name: Music_brainz_fields.has (name)
		local
			mb_name: ZSTRING
		do
			mb_name := Music_brainz_prefix + name
			if value.is_empty then
				remove_user_text (mb_name)
			else
				set_user_text (mb_name, value)
			end
		end

	set_version (a_version: REAL)
			--
		local
			id3_info_23: like Current
		do
			if version /= a_version then
				if a_version < 2.4 then
					create id3_info_23.make_version_23 (Current)

					-- Dispose 2.4 immediately to ensure file write lock is released (Underbit implementation)
					implementation.dispose
					copy (id3_info_23)
				end
			end
		end

	set_unique_id (owner_id: ZSTRING; hex_string: STRING)
			--
		local
			owner_found: BOOLEAN
		do
			across unique_id_list as unique_id until owner_found loop
				owner_found := unique_id.item.owner ~ owner_id
			end
			if owner_found then
				unique_id_list.item.set_id (hex_string)
			else
				unique_id_list.extend (implementation.new_unique_file_id_field (owner_id, hex_string))
			end
		end

	set_year (a_year: INTEGER)
			--
		do
			set_year_from_string (a_year.out)
		ensure
			year_set: a_year > 0 implies year ~ a_year
		end

	set_year_from_string (a_year: ZSTRING)
			--
		do
			set_field_string (Tag.Recording_time, a_year, encoding)
		end

	set_year_from_days (days: INTEGER)
			--
		do
			set_year (days // Days_in_year)
		end

	set_artist (a_artist: ZSTRING)
			--
		do
			set_field_string (Tag.Artist, a_artist, encoding)
		ensure
			is_set: artist ~ a_artist
		end

	set_album_artist (a_album_artist: ZSTRING)
			--
		do
			set_field_string (Tag.Album_artist, a_album_artist, encoding)
		ensure
			is_set: album_artist ~ a_album_artist
		end

	set_title (a_title: ZSTRING)
			--
		do
			set_field_string (Tag.Title, a_title, encoding)
		ensure
			is_set: title ~ a_title
		end

	set_album (a_album: ZSTRING)
			--
		do
			set_field_string (Tag.Album, a_album, encoding)
		ensure
			is_set: album ~ a_album
		end

	set_album_picture (a_picture: EL_ID3_ALBUM_PICTURE)
		do
			if has_album_picture then
				remove_field (internal_album_picture.first)
				internal_album_picture.wipe_out
			end
			internal_album_picture.extend (implementation.new_album_picture_frame (a_picture))
		end

	set_genre (a_genre: ZSTRING)
			--
		do
			set_field_string (Tag.Genre, a_genre, encoding)
		ensure
			is_set: genre ~ a_genre
		end

	set_composer (a_composer: ZSTRING)
			--
		do
			set_field_string (Tag.Composer, a_composer, encoding)
		ensure
			is_set: composer ~ a_composer
		end

	set_comment (a_key, a_comment: ZSTRING)
			--
		do
			set_table_item (comment_table, a_key, a_comment, Tag.Comment)
		end

	set_user_text (a_key, a_text: ZSTRING)
			--
		do
			set_table_item (user_text_table, a_key, a_text, Tag.User_text)
		end

	set_track (a_track: INTEGER)
			--
		do
			set_field_string (Tag.Track, a_track.out, encoding)
		ensure
			is_set: track ~ a_track
		end

	set_duration (a_duration: TIME)
			--
		local
			duration_field: EL_ID3_FRAME
			millisecs: INTEGER
		do
			millisecs := (a_duration.relative_duration (Zero_duration).fine_seconds_count * 1000).rounded
			duration_field := implementation.new_field (Tag.Duration)
			set_field_string (Tag.Duration, millisecs.out, Encoding_ISO_8859_1)
		ensure
			is_set: duration ~ a_duration
		end


	Zero_duration: TIME
		once
			create Result.make_by_compact_time (0)
		end

 	set_field_string (name: STRING; value: ZSTRING; a_encoding: INTEGER)
 		do
 			set_field_of_type (agent {EL_ID3_FRAME}.set_string, name, value, a_encoding)
 		end

 	set_field_description (name: STRING; value: ZSTRING; a_encoding: INTEGER)
 		do
 			set_field_of_type (agent {EL_ID3_FRAME}.set_description, name, value, a_encoding)
 		end

 	set_field_language (name: STRING; value: ZSTRING; a_encoding: INTEGER)
 		do
 			set_field_of_type (agent {EL_ID3_FRAME}.set_language, name, value, a_encoding)
 		end

	append_unique_ids (id_list: LINKED_LIST [EL_ID3_UNIQUE_FILE_ID])
			--
		do
			from id_list.start until id_list.after loop
				set_unique_id (id_list.item.owner, id_list.item.id)
				id_list.forth
			end
		end

feature {NONE} -- Element change

	set_table_item (table: like comment_table; a_key, a_string: ZSTRING; a_code: STRING)
			-- set comment or user text table
		require
			valid_table: table = comment_table or table = user_text_table
		local
			field: EL_ID3_FRAME
		do
			table.search (a_key)
			if table.found then
				field := table.found_item
			else
				field := implementation.new_field (a_code)
				field.set_encoding (encoding)
				table.extend (field, a_key)
			end
			set_field (field, a_key, a_string)
		ensure
			string_set: table.item (a_key).string ~ a_string and table.item (a_key).description ~ a_key
		end

	set_field (a_field: EL_ID3_FRAME; a_description, a_text: ZSTRING)
		do
			a_field.set_encoding (encoding)
			a_field.set_description (a_description)
			a_field.set_string (a_text)
		end

 	set_field_of_type (setter_action: PROCEDURE; name: STRING; value: ZSTRING; a_encoding: INTEGER)
			--
		local
			field: EL_ID3_FRAME
		do
			if basic_fields.has_key (name) then
				field := basic_fields.found_item
			else
				field := implementation.new_field (name)
				if Tag.Basic.has (name) then
					basic_fields [name] := field
				end
			end
			field.set_encoding (encoding)
			setter_action.call ([field, value])
		end

feature -- Removal

	remove_duplicate_unique_ids
			--
		do
			across unique_id_owner_counts as owner_count loop
				across 2 |..| owner_count.item as n loop
					remove_unique_id (owner_count.key)
				end
			end
		end

	remove_unique_id (owner_id: ZSTRING)
			--
		local
			found: BOOLEAN
		do
			from unique_id_list.start until found or unique_id_list.after loop
				if unique_id_list.item.owner ~ owner_id then
					remove_field (unique_id_list.item)
					unique_id_list.remove
					found := True
				else
					unique_id_list.forth
				end
			end
		end

	remove_comment (a_key: ZSTRING)
			--
		do
			remove_table_item (comment_table, a_key, Tag.Comment)
		end

	remove_user_text (a_key: ZSTRING)
			--
		do
			remove_table_item (user_text_table, a_key, Tag.User_text)
		end

	remove_all_unique_ids
			--
		do
			remove_fields_with_id (Tag.unique_file_id)
		end

	remove_fields_with_id (id: STRING)
				--
		do
			fields_with_id (id).do_all (agent remove_field)
			if id ~ Tag.Comment then
				comment_table.wipe_out
			end
			if id ~ Tag.Unique_file_id then
				unique_id_list.wipe_out
			end
			if Tag.Basic.has (id) then
				Basic_fields.remove (id)
			end
		end

	remove_basic_field (code: STRING)
				-- Remove field
		do
			basic_fields.search (code)
			if basic_fields.found then
				remove_field (basic_fields.found_item)
				basic_fields.remove (code)
			end
		end

	remove_field (field: EL_ID3_FRAME)
				-- Remove field
		do
			implementation.prune (field)
		end

	remove_album_picture
		do
			if has_album_picture then
				remove_field (internal_album_picture.first)
				internal_album_picture.wipe_out
			end
		end

	wipe_out
			--
		local
			containers: ARRAY [COLLECTION [EL_ID3_FRAME]]
		do
			containers := << unique_id_list, basic_fields, comment_table, user_text_table >>
			across containers as container loop
				container.item.wipe_out
			end
			implementation.wipe_out
		end

feature -- File writes

	update
			--
		do
			implementation.update_v2
		end

--	update_v1
--			--
--		do
--			implementation.update_v1
--		end

--	update_v2
--			--
--		do
--			implementation.update_v2
--		end

	strip_v1
			--
		require
			valid_implementation: is_libid3_implementation
		do
			implementation.strip_v1
		end

	strip_v2
			--
		require
			valid_implementation: is_libid3_implementation
		do
			implementation.strip_v2
		end

feature {NONE} -- Implementation

	table_text (a_key: ZSTRING; a_table: like comment_table): ZSTRING
			--
		do
			a_table.search (a_key)
			if a_table.found then
				Result := a_table.found_item.string
			else
				create Result.make_empty
			end
		end

	set_encoding_from_basic_fields
		do
			basic_fields.search (Tag.Title)
			if not basic_fields.found then
				basic_fields.search (Tag.Artist)
			end
			if basic_fields.found then
				encoding := basic_fields.found_item.encoding
			end
		end

	remove_table_item (a_table: like comment_table; a_key: ZSTRING; a_code: STRING)
			--
		do
			a_table.search (a_key)
			if a_table.found then
				-- Make sure any duplicate fields are removed
				from fields.start until fields.after loop
					if fields.item.code ~ a_code and then fields.item.description ~ a_key then
						implementation.detach (fields.item)
						fields.remove
					else
						fields.forth
					end
				end
				a_table.remove (a_key)
			end
		end

	unique_id_owner_counts: HASH_TABLE [INTEGER, ZSTRING]
		do
			create Result.make_equal (7)
			across unique_id_list as unique_id loop
				Result.put (1, unique_id.item.owner)
				if Result.conflict then
					Result [unique_id.item.owner] := Result [unique_id.item.owner] + 1
				end
			end
		end

	field_of_type (getter_action: FUNCTION [ZSTRING]; id: STRING): ZSTRING
				--
		do
			basic_fields.search (id)
			if basic_fields.found then
				Result := getter_action.item ([basic_fields.found_item])
			else
				create Result.make_empty
			end
		end

	new_implementation (a_version: REAL): like implementation
		do
			if a_version = 2.4 then
				create {EL_UNDERBIT_ID3_TAG_INFO} Result.make

			elseif a_version <= 2.3 and a_version >= 2.0 then
				create {EL_LIBID3_TAG_INFO} Result.make
				Result.set_version (a_version)

			else
				-- Unknown version
				create {EL_UNDERBIT_ID3_TAG_INFO} Result.make
			end

		end

	fields: ARRAYED_LIST [EL_ID3_FRAME]
		do
			Result := implementation.frame_list
		end

	internal_album_picture: ARRAYED_LIST [EL_ALBUM_PICTURE_ID3_FRAME]

	implementation: EL_ID3_INFO_I

feature -- Constants

	Days_in_year: INTEGER = 365

	Default_encoding: INTEGER
			--
		once
			Result := Encoding_UTF_8
		end

	Http_musicbrainz_org: ZSTRING
		once
			Result := "http://musicbrainz.org"
		end

	Music_brainz_prefix: ZSTRING
		once
			Result := "musicbrainz_"
		end

	Music_brainz_fields: ARRAY [STRING]
		once
			Result := << "artistid", "albumid", "albumartistid", "artistsortname" >>
			Result.compare_objects
		end
end
