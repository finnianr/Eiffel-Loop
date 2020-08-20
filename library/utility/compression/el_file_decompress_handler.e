note
	description: "File decompress handler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-20 10:21:27 GMT (Thursday 20th August 2020)"
	revision: "2"

deferred class
	EL_FILE_DECOMPRESS_HANDLER

feature {EL_COMPRESSED_ARCHIVE_FILE} -- Event handling

	on_decompressed (archive: EL_COMPRESSED_ARCHIVE_FILE; index: INTEGER)
		require
			valid_read: archive.is_last_data_ok
		deferred
		end

	on_decompression_error (file_path: EL_FILE_PATH; checksums_differ: BOOLEAN)
		deferred
		end

	on_unreadable_file_path
		deferred
		end

end
