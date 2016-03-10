note
	description: "Summary description for {EL_ID3_TAG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

class
	EL_ID3_INFO

inherit
	EL_ID3_ENCODINGS
		export
			{NONE} all
		redefine
			default_create
		end

	EL_MODULE_STRING
		undefine
			default_create
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

	EL_MODULE_TAG
		undefine
			default_create
		end

	EL_MEMORY
		export
			{NONE} all
		undefine
			default_create
		end

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
					implementation := create_implementation (header.version)
				else
					implementation := create_implementation (a_version)
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
			name, value: ASTRING
		do
			log.enter ("initialize_tables")
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
						name.append_string ("COMM_")
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
				log.put_string_field (field.code + " (" + name + ")", value)
				log.put_new_line
			end
			log.exit
		end

feature -- Basic fields

	title: ASTRING
			--
		do
			Result := field_string (Tag.Title)
		end

	artist: ASTRING
			--
		do
			Result := field_string (Tag.Artist)
		end

	album: ASTRING
			--
		do
			Result := field_string (Tag.Album)
		end

	album_artist: ASTRING
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

	composer: ASTRING
			--
		do
			Result := field_string (Tag.Composer)
		end

	genre: ASTRING
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

	comment (a_key: ASTRING): ASTRING
			--
		do
			Result := table_text (a_key, comment_table)
		end

	user_text (a_key: ASTRING): ASTRING
			--
		do
			Result := table_text (a_key, user_text_table)
		end

	unique_id_for_owner (owner: STRING): STRING
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

	field_string (id: STRING): ASTRING
				--
		do
			Result := field_of_type (agent {EL_ID3_FRAME}.string, id)
		end

	field_language (id: STRING): ASTRING
				--
		do
			Result := field_of_type (agent {EL_ID3_FRAME}.string, id)
		end

	field_description (id: STRING): ASTRING
				--
		do
			Result := field_of_type (agent {EL_ID3_FRAME}.description, id)
		end

	field_summary (id: STRING): ASTRING
				--
		do
			Result := field_of_type (agent {EL_ID3_FRAME}.out, id)
		end

	field_integer (id: STRING): INTEGER
			--
		local
			l_str: STRING
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

	comment_table: EL_ASTRING_HASH_TABLE [EL_ID3_FRAME]

 	user_text_table: EL_ASTRING_HASH_TABLE [EL_ID3_FRAME]

	unique_id_list: LINKED_LIST [EL_ID3_UNIQUE_FILE_ID]

feature -- Status report

	is_libid3_implementation: BOOLEAN
			--
		do
			Result := attached {EL_LIBID3_TAG_INFO} implementation
		end

	has_multiple_owners_for_UFID: BOOLEAN
		do
			Result := unique_id_owner_counts.linear_representation.there_exists (
				agent (count: INTEGER): BOOLEAN
					do
						Result := count > 1
					end
			)
		end

	has_album_picture: BOOLEAN
		do
			Result := not internal_album_picture.is_empty
		end

	has_unique_id (owner: STRING): BOOLEAN
			--
		do
			Result := across unique_id_list as unique_file_id some unique_file_id.item.owner ~ owner end
		end

	duplicates_found: BOOLEAN

 feature -- Element change

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

	set_unique_id (owner_id, hex_string: STRING)
			--
		local
			owner_found: BOOLEAN
		do
			from unique_id_list.start until unique_id_list.after or owner_found loop
				if unique_id_list.item.owner ~ owner_id then
					owner_found := true
				else
					unique_id_list.forth
				end
			end
			if owner_found then
				unique_id_list.item.set_id (hex_string)
			else
				unique_id_list.extend (implementation.create_unique_file_id_field (owner_id, hex_string))
			end
		end

	set_year (a_year: INTEGER)
			--
		do
			set_year_from_string (a_year.out)
		ensure
			year_set: a_year > 0 implies year ~ a_year
		end

	set_year_from_string (a_year: ASTRING)
			--
		do
			set_field_string (Tag.Recording_time, a_year, encoding)
		end

	set_year_from_days (days: INTEGER)
			--
		do
			set_year (days // Days_in_year)
		end

	set_artist (a_artist: ASTRING)
			--
		do
			set_field_string (Tag.Artist, a_artist, encoding)
		ensure
			is_set: artist ~ a_artist
		end

	set_album_artist (a_album_artist: ASTRING)
			--
		do
			set_field_string (Tag.Album_artist, a_album_artist, encoding)
		ensure
			is_set: album_artist ~ a_album_artist
		end

	set_title (a_title: ASTRING)
			--
		do
			set_field_string (Tag.Title, a_title, encoding)
		ensure
			is_set: title ~ a_title
		end

	set_album (a_album: ASTRING)
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
			internal_album_picture.extend (implementation.create_album_picture_frame (a_picture))
		end

	set_genre (a_genre: ASTRING)
			--
		do
			set_field_string (Tag.Genre, a_genre, encoding)
		ensure
			is_set: genre ~ a_genre
		end

	set_composer (a_composer: ASTRING)
			--
		do
			set_field_string (Tag.Composer, a_composer, encoding)
		ensure
			is_set: composer ~ a_composer
		end

	set_comment (a_key, a_comment: ASTRING)
			--
		do
			set_table_item (comment_table, a_key, a_comment, Tag.Comment)
		end

	set_user_text (a_key, a_text: ASTRING)
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
			duration_field := implementation.create_field (Tag.Duration)
			set_field_string (Tag.Duration, millisecs.out, Encoding_ISO_8859_1)
		ensure
			is_set: duration ~ a_duration
		end


	Zero_duration: TIME
		once
			create Result.make_by_compact_time (0)
		end

 	set_field_string (name: STRING; value: ASTRING; a_encoding: INTEGER)
 		do
 			set_field_of_type (agent {EL_ID3_FRAME}.set_string, name, value, a_encoding)
 		end

 	set_field_description (name: STRING; value: ASTRING; a_encoding: INTEGER)
 		do
 			set_field_of_type (agent {EL_ID3_FRAME}.set_description, name, value, a_encoding)
 		end

 	set_field_language (name: STRING; value: ASTRING; a_encoding: INTEGER)
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

	set_table_item (table: like comment_table; a_key, a_string: ASTRING; a_code: STRING)
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
				field := implementation.create_field (a_code)
				field.set_encoding (encoding)
				table.extend (field, a_key)
			end
			set_field (field, a_key, a_string)
		ensure
			string_set: table.item (a_key).string ~ a_string and table.item (a_key).description ~ a_key
		end

	set_field (a_field: EL_ID3_FRAME; a_description, a_text: ASTRING)
		do
			a_field.set_encoding (encoding)
			a_field.set_description (a_description)
			a_field.set_string (a_text)
		end

 	set_field_of_type (setter_action: PROCEDURE [EL_ID3_FRAME, TUPLE]; name: STRING; value: ASTRING; a_encoding: INTEGER)
			--
		local
			field: EL_ID3_FRAME
		do
			if basic_fields.has_key (name) then
				field := basic_fields.found_item
			else
				field := implementation.create_field (name)
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
		local
			count: INTEGER
			owner_counts: like unique_id_owner_counts
		do
			from owner_counts.start until owner_counts.after loop
				from count := owner_counts.item_for_iteration until count = 1 loop
					remove_unique_id (owner_counts.key_for_iteration)
					count := count - 1
				end
				owner_counts.forth
			end
		end

	remove_unique_id (owner_id: STRING)
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

	remove_comment (a_key: ASTRING)
			--
		do
			remove_table_item (comment_table, a_key, Tag.Comment)
		end

	remove_user_text (a_key: ASTRING)
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

feature -- Constants

	Days_in_year: INTEGER = 365

	Default_encoding: INTEGER
			--
		once
			Result := Encoding_UTF_8
		end

feature {NONE} -- Implementation

	table_text (a_key: ASTRING; a_table: like comment_table): ASTRING
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

	remove_table_item (a_table: like comment_table; a_key: ASTRING; a_code: STRING)
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

	unique_id_owner_counts: HASH_TABLE [INTEGER, STRING]
		do
			create Result.make (7)
			Result.compare_objects
			from unique_id_list.start until unique_id_list.after loop
				Result.search (unique_id_list.item.owner)
				if Result.found then
					Result [unique_id_list.item.owner] := Result [unique_id_list.item.owner] + 1
				else
					Result.extend (1, unique_id_list.item.owner)
				end
				unique_id_list.forth
			end
		end

	field_of_type (getter_action: FUNCTION [EL_ID3_FRAME, TUPLE, ASTRING]; id: STRING): ASTRING
				--
		do
			basic_fields.search (id)
			if basic_fields.found then
				Result := getter_action.item ([basic_fields.found_item])
			else
				create Result.make_empty
			end
		end

	create_implementation (a_version: REAL): like implementation
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

end
