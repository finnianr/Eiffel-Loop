note
	description: "File decompress handler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-14 10:45:34 GMT (Friday 14th August 2020)"
	revision: "1"

deferred class
	EL_FILE_DECOMPRESS_HANDLER

feature -- Basic operations

	on_decompressed (archive: EL_COMPRESSED_ARCHIVE_FILE; index: INTEGER)
		require
			valid_read: archive.is_last_data_ok
		deferred
		end

	on_unreadable_file_path
		deferred
		end

	on_decompression_error (file_path: EL_FILE_PATH; checksums_differ: BOOLEAN)
		deferred
		end
end
