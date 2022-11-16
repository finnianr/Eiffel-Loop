note
	description: "Do nothing data transfer progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_DEFAULT_DATA_TRANSFER_PROGRESS_LISTENER

inherit
	EL_DATA_TRANSFER_PROGRESS_LISTENER
		redefine
			default_create, on_notify, increase_data_estimate, increase_file_data_estimate
		end

feature {NONE} -- Initialization

	default_create
		do
			create {EL_DEFAULT_PROGRESS_DISPLAY} display
		end

feature {NONE} -- Implementation

	increase_data_estimate (a_count: INTEGER)
		do
		end

	increase_file_data_estimate (a_file_path: FILE_PATH)
		do
		end

	set_identified_text (id: INTEGER; a_text: ZSTRING)
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