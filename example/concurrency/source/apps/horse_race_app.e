note
	description: "[
		Simulates a horse race as a concurrency exercise using class ${EL_PROCEDURE_DISTRIBUTER}.
	]"
	notes: "[
		**Finalized Usage**
		
			el_concurrency -horse_race
			
		**Related**
		
		See also ${SINE_WAVE_INTEGRATION_APP} for an example of integral calculation
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-08 11:20:35 GMT (Monday 8th May 2023)"
	revision: "8"

class
	HORSE_RACE_APP

inherit
	EL_APPLICATION

	EL_SINGLE_THREAD_ACCESS
		rename
			make_default as make_thread_access
		end

	EL_LOGGABLE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	initialize
		do
			make_thread_access

			create race_lane.make_empty
			create horse_moved.make
			create horse_list.make (Horse_colors.count)
			create finish_list.make (Horse_colors.count)
			across Horse_colors as l_color loop
				horse_list.extend (create {HORSE}.make (l_color.item, horse_moved))
			end
			-- create a thread pool with `horse_list.count' number of threads
			create distributer.make_threads (horse_list.count)
		end

feature -- Basic operations

	run
			--
		do
			from start_race until finish_list.full loop
				-- wait until condition variable signal is received from an advancing horse
				wait_until (horse_moved) -- from EL_SINGLE_THREAD_ACCESS
				display_lanes (False)
				distributer.collect (finish_list) -- collect any HORSE procedure targets that have finished
			end

			-- technically we don't need these 2 lines since we already know the `finish_list' is full
			-- but is useful when we need to wait until everything is finished
			distributer.do_final -- Wait for everthing to finish
			distributer.collect (finish_list) -- Collect remaining targets in finish list

			lio.put_new_line
			lio.put_line ("RACE RESULTS"); lio.put_new_line
			across finish_list as horse loop
				lio.put_substitution ("Place [%S] is ", [horse.cursor_index])
				lio.set_text_color (horse.item.color)
				lio.put_line (Color.name (horse.item.color))
				lio.set_text_color (Color.Default)
			end
		end

feature {NONE} -- Implementation

	display_lanes (initial: BOOLEAN)
		do
			if not initial then
				lio.move_cursor_up (horse_list.count)
			end
			across horse_list as horse loop
				horse.item.get_race_lane (race_lane)
				lio.set_text_color (horse.item.color)
				lio.put_line (race_lane)
				lio.set_text_color (Color.default)
			end
		end

	start_race
		do
			lio.put_line ("HORSE RACE"); lio.put_new_line
			display_lanes (True)
			across horse_list as horse loop
				-- This call will block if there are no available threads in the thread pool to assign a horse
				-- but in this case it will return immediately since we made sure to have one thread per horse.
				distributer.wait_apply (agent (horse.item).race)
			end
		end

feature {NONE} -- Internal attributes

	distributer: EL_PROCEDURE_DISTRIBUTER [HORSE]

	horse_list: ARRAYED_LIST [HORSE]

	finish_list: like horse_list

	horse_moved: CONDITION_VARIABLE

	race_lane: STRING
		-- race lane for single horse

feature {NONE} -- Constants

	Horse_colors: ARRAY [INTEGER]
		once
			Result := << Color.Black, Color.Blue, Color.Yellow, Color.Cyan, Color.Green, Color.Purple, Color.Red >>
		end

	Description: STRING = "Simulates a horse race as a concurrency exercise"

end