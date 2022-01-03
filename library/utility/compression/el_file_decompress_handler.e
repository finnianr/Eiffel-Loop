note
	description: "File decompress handler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "3"

deferred class
	EL_FILE_DECOMPRESS_HANDLER

feature {EL_COMPRESSED_ARCHIVE_FILE} -- Event handling

	on_decompressed (archive: EL_COMPRESSED_ARCHIVE_FILE; index: INTEGER)
		require
			valid_read: archive.is_last_data_ok
		deferred
		end

	on_decompression_error (file_path: FILE_PATH; checksums_differ: BOOLEAN)
		deferred
		end

	on_unreadable_file_path
		deferred
		end

end
