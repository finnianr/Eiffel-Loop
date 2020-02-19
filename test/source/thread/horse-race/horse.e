note
	description: "Horse"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-19 15:43:20 GMT (Wednesday 19th February 2020)"
	revision: "1"

class
	HORSE

inherit
	EL_THREAD_ACCESS

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (a_color: INTEGER; a_horse_moved: CONDITION_VARIABLE)
		do
			color := a_color; horse_moved := a_horse_moved
			horse_representation := "¬m°"
			create race_lane.make (new_race_lane)
		end

feature -- Access

	color: INTEGER

	get_race_lane (lane_out: STRING)
		do
			lane_out.wipe_out
			restrict_access (race_lane)
				lane_out.append (race_lane.item)
			end_restriction (race_lane)
		end

feature -- Basic operations

	race
		local
			wait_time_ms: INTEGER
		do
			from until step_count = Maximum_steps loop
				wait_time_ms := Minimum_wait_time_ms
				-- add some variablity
				if attached {RANDOM} restricted_access (Once_random) as random then
					random.forth
					wait_time_ms := wait_time_ms + random.item \\ Variable_wait_time_ms

					end_restriction (Once_random)
				end
				Execution_environment.sleep (wait_time_ms)

				advance
				horse_moved.signal -- signal main thread that horse moved
			end
		end

feature {NONE} -- Implementation

	advance
		 -- advance horse one character
		do
			if attached {STRING} restricted_access (race_lane) as lane then
				if step_count >= 1 then
					lane [step_count] := ' ' -- blank out tail of horse
				end
				step_count := step_count + 1
--				advance horse in race lane string
				lane.replace_substring (horse_representation, step_count, step_count + 2)

				end_restriction (race_lane)
			end
		end

	new_race_lane: STRING
		do
			create Result.make_filled (' ', Maximum_steps + 3)
			Result.replace_substring (horse_representation, 1, 3)
			Result [101] := '|' -- add finish line
		end

feature {NONE} -- Internal attributes

	horse_moved: CONDITION_VARIABLE

	race_lane: EL_MUTEX_REFERENCE [STRING]
		-- shared access to string between horse thread and main thread

	step_count: INTEGER

	horse_representation: STRING
		-- how the horse looks on screen: ¬m°

feature -- Constants

	Maximum_steps: INTEGER = 100

	Minimum_race_time_ms: INTEGER = 20_000
		-- we want the race to be a very minimum of 20 secs

	Minimum_wait_time_ms: INTEGER
		once
			Result := ((Minimum_race_time_ms / Maximum_steps) * 0.3).rounded
		end

	Variable_wait_time_ms: INTEGER
		-- add 70% variability
		once
			Result := ((Minimum_race_time_ms / Maximum_steps) * 0.7).rounded
		end

	Once_random: EL_MUTEX_REFERENCE [RANDOM]
		-- shared random across all horse threads
		local
			time: TIME
		once ("PROCESS")
			create time.make_now
			create Result.make (create {RANDOM}.set_seed (time.seconds))
		end

end
