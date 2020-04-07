note
	description: "Rbox ignored entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-07 11:16:01 GMT (Tuesday 7th April 2020)"
	revision: "18"

class
	RBOX_IGNORED_ENTRY

inherit
	RBOX_IRADIO_ENTRY
		redefine
			make, Template, Protocol
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_TIME

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			set_last_seen_time (Time.Unix_origin)
		end

feature -- Access

	last_seen_time: DATE_TIME
		do
			create Result.make_from_epoch (last_seen)
		end

	modification_time: DATE_TIME
		do
			create Result.make_from_epoch (mtime)
		end

feature -- Status query

	is_playlist: BOOLEAN
		do
			Result := genre ~ Playlist_genre
		end

feature -- Element change

	set_last_seen_time (a_last_seen_time: like last_seen_time)
		do
			last_seen := Time.unix_date_time (a_last_seen_time)
		end

	set_modification_time (a_modification_time: like modification_time)
		do
			mtime := Time.unix_date_time (a_modification_time)
		end

	set_title (a_title: like title)
			--
		do
			Title_set.put (a_title)
			title := Title_set.found_item
		end

feature -- Rhythmbox XML fields

	last_seen: INTEGER

	mtime: INTEGER
		-- Combination of file modification time and file size
		--
		-- rhythmdb.c
		-- /* compare modification time and size to the values in the Database.
		--  * if either has changed, we'll re-read the file.
		--  */
		-- new_mtime = g_file_info_get_attribute_uint64 (event->file_info, G_FILE_ATTRIBUTE_TIME_MODIFIED);
		-- new_size = g_file_info_get_attribute_uint64 (event->file_info, G_FILE_ATTRIBUTE_STANDARD_SIZE);
		-- if (entry->mtime == new_mtime && (new_size == 0 || entry->file_size == new_size)) {
		-- 	rb_debug ("not modified: %s", rb_refstring_get (event->real_uri));
		-- } else {
		-- 	rb_debug ("changed: %s", rb_refstring_get (event->real_uri));

feature -- Constants

	Protocol: ZSTRING
		once
			Result := "file"
		end

	Template: STRING
			--
		once
			Result := "[
				<entry type="ignore">
				#across $non_empty_string_fields as $field loop
					<$field.key>$field.item</$field.key>
				#end
					<location>$location_uri</location>
				#across $non_zero_integer_fields as $field loop
					<$field.key>$field.item</$field.key>
				#end
					<date>0</date>
				</entry>
			]"
		end

end
