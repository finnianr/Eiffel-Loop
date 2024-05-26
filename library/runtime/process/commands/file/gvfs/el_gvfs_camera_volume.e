note
	description: "${EL_GVFS_VOLUME} that is a multi-media/camera device"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-26 15:05:45 GMT (Sunday 26th May 2024)"
	revision: "1"

class
	EL_GVFS_CAMERA_VOLUME

inherit
	EL_GVFS_VOLUME
		rename
			file_list as new_file_list,
			make as make_volume
		export
			{NONE} all
			{ANY} is_mounted
		end

	EL_MODULE_DATE_TIME; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

	EL_CHARACTER_32_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_alias_name, a_name: ZSTRING; a_is_windows_format: BOOLEAN)
		do
			make_volume (a_name, a_is_windows_format)
			alias_name := a_alias_name
		end

feature -- Access

	date_string_offset: INTEGER
		-- offset in file name to characters specifying a date formatted as "yyyymm"

feature -- Element change

	set_date_string_offset (a_date_string_offset: INTEGER)
		do
			date_string_offset := a_date_string_offset
		end

feature -- Basic operations

	do_collated_transfer (source_dir, destination_dir: DIR_PATH; extension: STRING)
		-- move all files in `source_dir' with extension `extension' to created directory
		-- under `destination_dir' with structure "<alias_name>/<year>/<month-number>-<month-name>"
		do
			lio.put_labeled_string ("Extension", extension)
			lio.put_new_line
			if extension.count > 0
				and then attached new_file_list (source_dir, extension) as file_list
				and then file_list.count > 0
			then
				transfer (file_list, destination_dir)
				lio.put_new_line
			else
				lio.put_line ("Nothing to transfer")
			end
		end

feature {NONE} -- Implementation

	transfer (file_list: EL_FILE_PATH_LIST; destination_dir: DIR_PATH)
		local
			sorted_dir: DIR_PATH
		do
			across file_list as list loop
				if attached new_year_month (list.item.base) as year_month
					and then year_month.character_count = YYYYMM.count
					and then Months_interval.has (year_month.last.to_integer)
				then
					lio.put_index_labeled_string (list, "Transfering %S", list.item.to_string)
					lio.put_new_line
					sorted_dir := destination_dir.joined_dir_tuple (new_directory_tuple (year_month))

					lio.put_path_field ("to", sorted_dir)
					lio.put_new_line

					File_system.make_directory (sorted_dir)
					copy_file_from (list.item, sorted_dir)
					try_remove (list.item, sorted_dir + list.item.base)
				else
					lio.put_path_field ("Ignoring file", list.item)
					lio.put_new_line
				end
			end
		end

	try_remove (source_path, copied_path: FILE_PATH)
		-- remove `source_path' file if copied file size equals source file size
		local
			copied_file_size: INTEGER
		do
			if attached file_info (source_path) as info then
				copied_file_size := File.byte_count (copied_path)
				if info.size = copied_file_size then
					File.set_modification_time (copied_path, info.modified)
					lio.put_line ("Copy OK")
					remove_file (source_path)
				else
					lio.put_labeled_substitution (
						"Differing", "Actual: %S, Copied %S", [info.size, copied_file_size]
					)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Factory

	new_directory_tuple (year_month: EL_ZSTRING_LIST): TUPLE [name, year, numbered_month: ZSTRING]
		require
			valid_character_count: year_month.character_count = YYYYMM.count
		local
			month_name, year, month: ZSTRING; month_index: INTEGER
		do
			year := year_month [1]; month := year_month [2]
			month_index := month.to_integer
			if Date_time.Months_text.valid_index (month_index) then
				month_name := Date_time.Months_text [month_index]
				month_name.to_proper
			else
				month_name := "???"
			end
			Result := [alias_name, year, hyphen.joined (month, month_name)]
		end

	new_year_month (base: ZSTRING): EL_ZSTRING_LIST
		do
			create Result.make_from_substrings (base, date_string_offset + 1, << 4, 2 >>)
		end

feature {NONE} -- Internal attributes

	alias_name: ZSTRING

feature {NONE} -- Constants

	YYYYMM: STRING = "YYYYMM"

	Months_interval: INTEGER_INTERVAL
		once
			Result := 1 |..| 12
		end

end