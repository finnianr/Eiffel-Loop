note
	description: "[
		Wrapper for swgen test signal generation command
		It generates 1 second of audio signal sweeping from 'frequency_lower' to 'frequency_lower' at
		'cycles_per_sec' times per second

		See: http://manpages.ubuntu.com/manpages/natty/man1/swgen.1.html
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-18 14:15:05 GMT (Saturday 18th June 2016)"
	revision: "5"

deferred class
	EL_WAV_GENERATION_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as output_file_path,
			set_path as set_output_file_path
		redefine
			make_default, getter_function_table, output_file_path, var_name_path
		end

feature {NONE} -- Initialization

	make_default
		do
			sample_rate := Default_sample_rate
			frequency_lower := 1000; frequency_upper := 10000
			duration := 1
			cycles_per_sec := 1
			Precursor
		end

feature -- Element change

	set_sample_rate (a_sample_rate: INTEGER)
			--
		do
			sample_rate := a_sample_rate
		end

	set_frequency_lower (a_frequency_lower: like frequency_lower)
			--
		do
			frequency_lower := a_frequency_lower
		end

	set_frequency_upper (a_frequency_upper: like frequency_upper)
			--
		do
			frequency_upper := a_frequency_upper
		end

	set_cycles_per_sec (a_cycles_per_sec: like cycles_per_sec)
			--
		do
			cycles_per_sec := a_cycles_per_sec
		end

	set_duration (a_duration: like duration)
		do
			duration := a_duration
		end

feature -- Access

	sample_rate: INTEGER

	cycles_per_sec: REAL

	frequency_lower: INTEGER

	frequency_upper: INTEGER

	duration: INTEGER
		-- duration in seconds

	minimum_sample_rate: INTEGER
		do
			Result := sample_rate.max (frequency_upper * 2 + frequency_upper // 10)
		end

	output_file_path: EL_FILE_PATH


feature {NONE} -- Evolicity reflection

	var_name_path: ZSTRING
		do
			Result := "output_file_path"
		end

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["cycles_per_sec", 		agent: REAL_REF do Result := cycles_per_sec.to_reference end],
				["frequency_lower",		agent: INTEGER_REF do Result := frequency_lower.to_reference end],
				["frequency_upper",		agent: INTEGER_REF do Result := frequency_upper.to_reference end],
				["duration", 				agent: INTEGER_REF do Result := duration.to_reference end],
				["minimum_sample_rate",	agent: INTEGER_REF do Result := minimum_sample_rate.to_reference end]
			>>)
		end

feature {NONE} -- Constants

	Default_sample_rate: INTEGER = 8000
		-- Samples per sec

end
