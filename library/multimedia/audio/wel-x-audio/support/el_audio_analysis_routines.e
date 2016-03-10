note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_AUDIO_ANALYSIS_ROUTINES

inherit
	DOUBLE_MATH
		rename
			log as logarithm
		export
			{NONE} all
		end

	EL_MODULE_LOG

feature -- Element change

	set_signal_threshold (a_signal_threshold: like noise_threshold)
			-- Set `noise_threshold' to `a_signal_threshold'.
		do
			noise_threshold := a_signal_threshold
		ensure
			noise_threshold_assigned: noise_threshold = a_signal_threshold
		end

feature -- Status query

	is_signal: BOOLEAN
			--
		do
			if rms_energy = 0 then
				calculate_rms_energy
			end
			if noise_threshold = 0 then
				Result := rms_energy < Noise_threshold_default
			else
				Result := rms_energy < noise_threshold
			end
		end

feature -- Measurement

	calculate_rms_energy
			-- Calculate root mean square based on percentage of samples
		local
			square_sum: INTEGER_64
			i, test_count, sample_value, num_samples_to_test, offset_to_next_sample: INTEGER
			sample: MANAGED_POINTER
		do
			num_samples_to_test := (sample_count * Percent_of_samples_for_signal_test).rounded
			offset_to_next_sample := num_samples_to_test * sample_bytes

			create sample.share_from_pointer (data, sample_bytes)
			from
				i := 0
			until
				-- There is a jump in the sound level of more than silent threshold
				i >= bytes_recorded
			loop
				sample.set_from_pointer (data + i, sample_bytes)
--				if format.bits_per_sample = 8 then
--					sample_value := sample.read_integer_8 (0)
--				else
--					sample_value := sample.read_integer_16 (0)
--				end
				square_sum := square_sum + sample_value * sample_value
				test_count := test_count + 1
				i := i + offset_to_next_sample
			end
			rms_energy := sqrt (square_sum / test_count).rounded

		end

feature -- Access

	rms_energy: INTEGER

	noise_threshold: INTEGER

feature {NONE} -- Implementation

	data: POINTER
			--
		deferred
		end

	bytes_recorded: INTEGER
			--
		deferred
		end

	sample_count: INTEGER
			--
		deferred
		end

	sample_bytes: INTEGER
			--
		deferred
		end

	Noise_threshold_default: INTEGER = 100

	Percent_of_samples_for_signal_test: REAL = 0.01

end



