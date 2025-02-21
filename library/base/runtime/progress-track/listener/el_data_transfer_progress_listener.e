note
	description: "[
		Listener to track the progress of a data transfer operation. Reading or writing from a file
		for example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-21 8:19:25 GMT (Friday 21st February 2025)"
	revision: "18"

class
	EL_DATA_TRANSFER_PROGRESS_LISTENER

inherit
	EL_PROGRESS_LISTENER
		rename
			make as make_exact
		redefine
			finish, reset
		end

	EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make (a_display: EL_PROGRESS_DISPLAY; a_estimated_byte_count: INTEGER)
		do
			make_exact (a_display, Default_final_tick_count)
			estimated_byte_count := a_estimated_byte_count
		end

feature -- Access

	byte_count: INTEGER
		-- bytes read/written

	estimated_byte_count: INTEGER

	proportion: DOUBLE
		-- progress proportion
		do
			Result := byte_count / estimated_byte_count
		end

feature -- Status query

	is_started: BOOLEAN

feature -- Element change

	increase_data_estimate (a_count: INTEGER)
		do
			estimated_byte_count := estimated_byte_count + a_count
		end

	increase_file_data_estimate (a_file_path: FILE_PATH)
		do
			if a_file_path.exists then
				increase_data_estimate (File.byte_count (a_file_path))
			end
		end

	set_final_tick_count (a_final_tick_count: like final_tick_count)
		do
			final_tick_count := a_final_tick_count
		end

feature {EL_SHARED_DATA_TRANSFER_PROGRESS_LISTENER} -- Event handling

	on_notify (increment_count: INTEGER)
		local
			new_tick_count: INTEGER
		do
			if not is_started then
				display.on_start ((estimated_byte_count / final_tick_count).rounded)
				is_started := True
			end
			if estimated_byte_count.to_boolean then
				byte_count := byte_count + increment_count
				new_tick_count := (final_tick_count * proportion).rounded

				if new_tick_count > tick_count then
					tick_count := new_tick_count
					display.set_progress (proportion)
				end
			end
		end

feature -- Basic operations

	finish
		do
			display.on_finish
			if not attached {EL_CONSOLE_PROGRESS_DISPLAY} display then
				log_outcome ("byte_count", estimated_byte_count, byte_count)
			end
			reset
		end

feature {NONE} -- Implementation

	reset
		do
			tick_count := 0
			byte_count := 0
			is_started := False
			estimated_byte_count := 0
			final_tick_count := Default_final_tick_count
		end

feature {NONE} -- Constants

	Default_final_tick_count: INTEGER
		once
			Result := 100
		end
end