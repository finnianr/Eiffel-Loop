note
	description: "[
		Listener to track the progress of a data transfer operation. Reading or writing from a file
		for example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-24 8:27:59 GMT (Tuesday   24th   September   2019)"
	revision: "10"

class
	EL_DATA_TRANSFER_PROGRESS_LISTENER

inherit
	EL_PROGRESS_LISTENER
		rename
			make as make_exact
		redefine
			finish, reset
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO
		rename
			Args as Mod_args
		end

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

feature -- Element change

	increase_data_estimate (a_count: INTEGER)
		do
			estimated_byte_count := estimated_byte_count + a_count
		end

	increase_file_data_estimate (a_file_path: EL_FILE_PATH)
		do
			if a_file_path.exists then
				increase_data_estimate (File_system.file_byte_count (a_file_path))
			end
		end

	set_final_tick_count (a_final_tick_count: like final_tick_count)
		do
			final_tick_count := a_final_tick_count
		end

feature {EL_SHARED_DATA_TRANSFER_PROGRESS_LISTENER} -- Event handling

	on_notify (a_byte_count: INTEGER)
		do
			if bytes_per_tick = 0 then
				bytes_per_tick := estimated_byte_count // final_tick_count
				display.on_start (bytes_per_tick)
				next_byte_count := bytes_per_tick
			end
			byte_count := byte_count + a_byte_count
			if byte_count > next_byte_count then
				tick_count := tick_count + 1
				next_byte_count := next_byte_count + bytes_per_tick
				display.set_progress (tick_count / final_tick_count)
			end
		end

feature -- Basic operations

	finish
		do
			display.set_progress (1.0)
			display.on_finish
			if is_lio_enabled then
				lio.put_integer_field (display.generator + " byte_count", byte_count)
				if byte_count = estimated_byte_count then
					lio.put_string (" estimate OK")
				else
					lio.put_integer_field (" estimated_byte_count", estimated_byte_count)
				end
				lio.put_new_line
			end
			reset
		end

feature {NONE} -- Implementation

	reset
		do
			tick_count := 0
			byte_count := 0
			bytes_per_tick := 0
			estimated_byte_count := 0
			next_byte_count := 0
			final_tick_count := Default_final_tick_count
		end

feature {NONE} -- Internal attributes

	bytes_per_tick: INTEGER

	next_byte_count: INTEGER
		-- next value of `byte_count' to increment the `tick_count'

feature {NONE} -- Constants

	Default_final_tick_count: INTEGER
		once
			Result := 100
		end
end
