note
	description: "Summary description for {SERIALIZATION_LISTENER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 13:22:30 GMT (Friday 1st July 2016)"
	revision: "5"

deferred class
	EL_FILE_PROGRESS_LISTENER

inherit
	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	make
		do
			create timer.make
		end

feature -- Element change

	increment_estimated_bytes_from_file (a_file_path: EL_FILE_PATH)
		do
			if a_file_path.exists then
				increment_estimated_bytes (File_system.file_byte_count (a_file_path))
			end
		end

	increment_estimated_bytes (a_count: INTEGER)
		do
			estimated_byte_count := estimated_byte_count + a_count
			timer.start
		end

	set_text (a_text: ZSTRING)
		deferred
		end

feature -- Status query

	is_time_estimated: BOOLEAN
		-- true if completion time has been estimated

feature {EL_NOTIFYING_FILE, EL_SHARED_FILE_PROGRESS_LISTENER} -- Event handling

	on_notify (a_byte_count: INTEGER)
		do
			byte_count := byte_count + a_byte_count
			tick_count := byte_count // Bytes_per_tick
			if tick_count > previous_tick_count then
				previous_tick_count := tick_count

				if is_time_estimated then
					set_progress (byte_count / estimated_byte_count)
				else
					if tick_count >= Time_estimatation_tick_count then
						timer.stop
						bytes_per_sec := byte_count / (timer.elapsed_millisecs / 1000)
						on_time_estimation ((estimated_byte_count / bytes_per_sec).rounded)
						is_time_estimated := True
					end
				end
			end
		end

	on_time_estimation (a_seconds: INTEGER)
			-- called when completion time is estimatated
		deferred
		end

	on_finish
		deferred
		end

feature -- Basic operations

	set_progress (proportion: DOUBLE)
		deferred
		end

	finish
		do
--			log.enter ("on_finish")
			byte_count := byte_count + tick_count
--			log.put_integer_interval_field ("Bytes", byte_count |..| sum_file_count)
--			log.put_new_line
			tick_count := 0
			set_progress (byte_count / estimated_byte_count)
			on_finish
--			log.exit
		end

feature {NONE} -- Implementation

	timer: EL_EXECUTION_TIMER

	estimated_byte_count: INTEGER

	byte_count: INTEGER
		-- bytes read/written

	tick_count: INTEGER
		-- number of times set_progress has been called

	previous_tick_count: INTEGER

	bytes_per_sec: DOUBLE

feature {NONE} -- Constants

	Bytes_per_tick: INTEGER
		once
			Result := 256
		end
		-- data bytes per progress tick

	Time_estimatation_tick_count: INTEGER
			-- number of ticks required to estimate completion time
		once
			Result := 8 -- 256 * 8 = 2K
		end

end