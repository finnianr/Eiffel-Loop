note
	description: "Do nothing data transfer progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-22 8:51:09 GMT (Sunday   22nd   September   2019)"
	revision: "5"

class
	EL_DEFAULT_DATA_TRANSFER_PROGRESS_LISTENER

inherit
	EL_DATA_TRANSFER_PROGRESS_LISTENER
		redefine
			default_create, on_notify, increment_estimated_bytes, increment_estimated_bytes_from_file
		end

feature {NONE} -- Initialization

	default_create
		do
			create {EL_DEFAULT_PROGRESS_DISPLAY} display
		end

feature {NONE} -- Implementation

	increment_estimated_bytes (a_count: INTEGER)
		do
		end

	increment_estimated_bytes_from_file (a_file_path: EL_FILE_PATH)
		do
		end

	set_identified_text (id: INTEGER; a_text: ZSTRING)
		do
		end

	set_progress (proportion: DOUBLE)
		do
		end

	on_notify (a_byte_count: INTEGER)
		do
		end

	on_time_estimation (a_seconds: INTEGER)
		do
		end

	on_finish
		do
		end

end
