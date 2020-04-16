note
	description: "Export to device task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-15 11:32:53 GMT (Wednesday 15th April 2020)"
	revision: "5"

deferred class
	EXPORT_TO_DEVICE_TASK

inherit
	RBOX_MANAGEMENT_TASK

	EL_MODULE_TUPLE

feature -- Access

	playlist_export: PLAYLIST_EXPORT_INFO

	volume: VOLUME_INFO

feature -- Status query

	is_full_export_task: BOOLEAN
		deferred
		end

feature -- Factory

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

end
