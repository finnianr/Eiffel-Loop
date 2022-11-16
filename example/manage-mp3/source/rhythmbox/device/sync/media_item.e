note
	description: "Media item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "9"

deferred class
	MEDIA_ITEM

inherit
	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature -- Access

	checksum: NATURAL_32
		deferred
		end

	to_sync_item (is_windows_format: BOOLEAN): MEDIA_SYNC_ITEM
		do
			create Result.make (id, checksum, exported_relative_path (is_windows_format))
		end

	exported_relative_path (is_windows_format: BOOLEAN): FILE_PATH
		local
			ntfs: EL_NT_FILE_SYSTEM_ROUTINES
		do
			if is_windows_format then
				Result := ntfs.translated (relative_path, '-')
			else
				Result := relative_path
			end
		end

	file_size_mb: DOUBLE
		deferred
		end

	id: STRING

	relative_path: FILE_PATH
		deferred
		end

feature -- Status query

	is_update: BOOLEAN

feature -- Status change

	mark_as_update
		do
			is_update := True
		end

feature -- Element change

	set_id_from_uuid (a_id: EL_UUID)
		do
			id := a_id.to_delimited (':')
		end

feature {NONE} -- Constants

	Default_uuid: EL_UUID
		once
			create Result.make_default
		end

	Default_id: STRING
		once
			Result := Default_uuid.to_delimited (':')
		end

end