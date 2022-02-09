note
	description: "[
		Example program to demonstrate use of [$source EL_FUNCTION_DISTRIBUTER] and [$source EL_PROCEDURE_DISTRIBUTER]
		for distributing the work of executing agent routines over a maximum number of threads.
	]"
	instructions: "[
		 Example of command to the run the finalized build
		
			el_concurrency -sine_wave_integration -command_type distributed_function -logging\
								-integral_range "0, 3" -multiplicands "0.1, 0.2, 2" \
								-term_count 20 -task_count 64 -delta_count 4000000 -thread_count 8
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 8:56:19 GMT (Wednesday 9th February 2022)"
	revision: "2"

class
	SINE_WAVE_INTEGRATION_APP

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [INTEGRATION_COMMAND]
		redefine
			new_command, new_command_options
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			create Result.make_empty
		end

	default_make: PROCEDURE [like command]
		local
			wave: SINE_WAVE
		do
			create wave
			Result := agent {like command}.make (Option, agent wave.complex_sine_wave (?, sine_multiplicands))
		end

	new_command: INTEGRATION_COMMAND
		do
			if attached Command_factory.new_item_from_alias (Option.method) as new then
				Result := new
			end
		end

	new_command_options: like Option
		do
			Result := Option
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current,
		SINGLE_THREAD_INTEGRATION,
		DISTRIBUTED_FUNCTION_INTEGRATION,
		DISTRIBUTED_PROCEDURE_INTEGRATION
	]
		do
			create Result.make
		end

	sine_multiplicands: SPECIAL [DOUBLE]
		do
			Result := Option.multiplicands.to_array
		end

feature {NONE} -- Constants

	Command_factory: EL_OBJECT_FACTORY [INTEGRATION_COMMAND]
		once
			create Result.make (<<
				["single_thread", {SINGLE_THREAD_INTEGRATION}],
				["distributed_function", {DISTRIBUTED_FUNCTION_INTEGRATION}],
				["distributed_procedure", {DISTRIBUTED_PROCEDURE_INTEGRATION}]
			>>)
		end

	Option: INTEGRATION_COMMAND_OPTIONS
		once
			create Result.make
		end

note
	to_do: "[
		https://superuser.com/questions/226552/how-to-tell-how-many-cpus-cores-you-have-on-windows-7
		WMIC CPU Get /Format:List
	]"
end