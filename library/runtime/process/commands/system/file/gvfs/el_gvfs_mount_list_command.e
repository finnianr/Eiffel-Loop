note
	description: "[
		Parse mount uri's from result of command:
		
			gvfs-mount --list
			
		Example:
			
			Volume(0): SAMSUNG Android
				Type: GProxyVolume (GProxyVolumeMonitorMTP)
				Mount(0): SAMSUNG Android -> mtp://[usb:003,008]/
					Type: GProxyShadowMount (GProxyVolumeMonitorMTP)
	]"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-09 9:47:31 GMT (Tuesday 9th May 2023)"
	revision: "19"

class
	EL_GVFS_MOUNT_LIST_COMMAND

inherit
	EL_GVFS_OS_COMMAND [TUPLE]
		rename
			find_line as find_volume
		export
			{NONE} all
			{ANY} execute
		redefine
			make_default, find_volume, reset
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make_default
		do
			create uri_table.make_equal (3)
			Precursor
		end

feature -- Access

	uri_table: EL_ZSTRING_HASH_TABLE [EL_URI]

feature {NONE} -- Line states

	find_volume (line: ZSTRING)
		local
			f: EL_COLON_FIELD_ROUTINES
		do
			if line.starts_with (Text.volume) then
				state := agent find_mount (?, f.value (line))
			end
		end

	find_mount (line, volume: ZSTRING)
		local
			f: EL_COLON_FIELD_ROUTINES; split_list: EL_SPLIT_ZSTRING_LIST
		do
			line.left_adjust
			if line.starts_with (Text.mount) then
				create split_list.make_by_string (f.value (line), Text.map_arrow)
				if split_list.count = 2 then
					if split_list.first_item ~ volume then
						uri_table [volume] := split_list.last_item.to_latin_1
					end
				end
				state := agent find_volume
			end
		end

feature {NONE} -- Implementation

	reset
		do
			Precursor
			uri_table.wipe_out
		end

feature {NONE} -- Constants

	Template: STRING = "gvfs-mount --list"

	Text: TUPLE [map_arrow, mount, volume: ZSTRING]
		once
			create Result
			Tuple.fill_adjusted (Result, " -> ,Mount(,Volume(", False)
		end

end