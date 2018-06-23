note
	description: "Rbox ignored entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-18 11:47:37 GMT (Monday 18th June 2018)"
	revision: "11"

class
	RBOX_IGNORED_ENTRY

inherit
	RBOX_IRADIO_ENTRY
		redefine
			make, building_action_table, Template, Protocol
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			is_equal
		end

	EL_MODULE_TIME
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_database: like database)
			--
		do
			Precursor (a_database)
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

feature -- Element change

	set_genre (a_genre: like genre)
			--
		do
			genre := a_genre
		end

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
			title := a_title
		end

feature -- Rhythmbox XML fields

	last_seen: INTEGER

	mtime: INTEGER
		-- Combination of file modification time and file size
		--
		-- rhythmdb.c
		-- /* compare modification time and size to the values in the database.
		--  * if either has changed, we'll re-read the file.
		--  */
		-- new_mtime = g_file_info_get_attribute_uint64 (event->file_info, G_FILE_ATTRIBUTE_TIME_MODIFIED);
		-- new_size = g_file_info_get_attribute_uint64 (event->file_info, G_FILE_ATTRIBUTE_STANDARD_SIZE);
		-- if (entry->mtime == new_mtime && (new_size == 0 || entry->file_size == new_size)) {
		-- 	rb_debug ("not modified: %s", rb_refstring_get (event->real_uri));
		-- } else {
		-- 	rb_debug ("changed: %s", rb_refstring_get (event->real_uri));

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			Result := Precursor
			Result.merge (building_actions_for_type ({INTEGER}, Text_element_node))
		end

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
