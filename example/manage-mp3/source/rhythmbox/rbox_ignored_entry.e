note
	description: "Summary description for {RBOX_IGNORED_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-23 11:06:56 GMT (Sunday 23rd June 2013)"
	revision: "2"

class
	RBOX_IGNORED_ENTRY

inherit
	RBOX_IRADIO_ENTRY
		redefine
			building_action_table, getter_function_table, Template, Protocol, make
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_TIME

	EL_MODULE_TEST

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			last_seen_time := Time.Unix_origin.twin
		end

feature -- Access

	last_seen_time: DATE_TIME

	modification_time: DATE_TIME
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
		do
			if location.exists then
				if Test.is_executing then
					Result := test_time
				else
					Result := location.modification_time
				end
			else
				Result := Time.unix_origin
			end
		end

feature -- Element change

	set_last_seen_time (a_last_seen_time: like last_seen_time)
		do
			last_seen_time := a_last_seen_time
		end

feature {NONE} -- Implementation

	last_seen: INTEGER
		do
			Result := Time.unix_date_time (last_seen_time)
		end

	mtime: INTEGER
		do
			Result := Time.unix_date_time (modification_time)
		end

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
			--
		do
			Result := Precursor
			Result ["last-seen/text()"] := agent do create last_seen_time.make_from_epoch (node.to_integer) end
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["mtime", 		agent: INTEGER_REF do Result := mtime.to_reference end],
				["last_seen",	agent: INTEGER_REF do Result := last_seen.to_reference end]
			>>)
		end

feature -- Constants

	Template: STRING
			--
		once
			Result := "[
				<entry type="ignore">
					<title></title>
					<genre></genre>
					<artist></artist>
					<album></album>
					<location>$location_uri</location>
					<mtime>$mtime</mtime>
					<last-seen>$last_seen</last-seen>
					<date>0</date>
					<media-type>application/octet-stream</media-type>
				</entry>
			]"
		end

	Protocol: STRING
		once
			Result := "file"
		end

	Test_time: DATE_TIME
		do
			create Result.make (2011, 11, 11, 11, 11, 11)
		end

end
