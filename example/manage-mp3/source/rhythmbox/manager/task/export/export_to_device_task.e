note
	description: "Export to device task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 12:02:48 GMT (Saturday 19th February 2022)"
	revision: "8"

deferred class
	EXPORT_TO_DEVICE_TASK

inherit
	RBOX_MANAGEMENT_TASK
		redefine
			make
		end

	EL_MODULE_TUPLE

feature {RBOX_MUSIC_MANAGER} -- Initialization

	make (a_file_path: FILE_PATH)
		do
			Precursor (a_file_path)
			device := new_device
			if not device.volume.is_valid then
				error_message := Volume_error #$ [volume.name]
			end
		end

feature -- Access

	playlist_export: PLAYLIST_EXPORT_INFO

	volume: VOLUME_INFO

feature -- Status query

	is_full_export_task: BOOLEAN
		deferred
		end

feature {NONE} -- Factory

	new_device: STORAGE_DEVICE
		do
			if volume.type ~ Device_type.test and volume.name ~ Tablet then
				create {TEST_STORAGE_DEVICE} Result.make (Current)

			elseif volume.type.as_lower ~ Device_type.nokia_phone then
				create {NOKIA_PHONE_DEVICE} Result.make (Current)

			elseif volume.type.as_lower ~ Device_type.samsung_tablet then
				create {SAMSUNG_TABLET_DEVICE} Result.make (Current)

			elseif playlist_export.is_windows_path then
				create {NOKIA_PHONE_DEVICE} Result.make (Current)

			else
				create Result.make (Current)
			end
		end

feature {NONE} -- Implementation

	export_to_device (a_condition: EL_QUERY_CONDITION [RBOX_SONG]; name_clashes: LINKED_LIST [FILE_PATH])
		do
			if name_clashes.is_empty then
				device.export_songs_and_playlists (a_condition)
			else
				-- A problem on NTFS and FAT32 filesystems
				lio.put_line ("CASE INSENSITIVE NAME CLASHES FOUND")
				lio.put_new_line
				across name_clashes as path loop
					lio.put_path_field ("MP3 %S", path.item)
					lio.put_new_line
				end
				lio.put_new_line
				lio.put_line ("Fix before proceeding")
			end
		end

feature {EL_EQA_TEST_SET} -- Initialization

	device: like new_device

feature {NONE} -- Constants

	Device_type: TUPLE [test, samsung_tablet, nokia_phone: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "TEST, samsung tablet, nokia phone")
		end

	Tablet: ZSTRING
		once
			Result := "TABLET"
		end

	Volume_error: ZSTRING
		once
			Result := "Volume %"%S%" not mounted"
		end

end