note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_AUDIO_SAMPLE_LIST

inherit
	EL_MODULE_LOG
		undefine
			copy, is_equal
		end

	DOUBLE_MATH
		rename
			log as logarithm
		undefine
			copy, is_equal
		end

	PLATFORM
		undefine
			copy, is_equal
		end

feature -- Measurement

	rms_energy: REAL
			-- Normalised RMS energy based on samples in the range [-1, 1]
		local
			square_sum: DOUBLE
			test_count, offset_to_next_sample: INTEGER
			num_samples_to_test, normalized_value: REAL
		do
--			log.enter ("rms_energy")
			num_samples_to_test := (1.0).max (sample_count * Rms_sample_ratio).truncated_to_real
			offset_to_next_sample := (sample_count / num_samples_to_test).rounded

			from start until after loop
				normalized_value := normalized_item
				square_sum := square_sum + normalized_value * normalized_value
				test_count := test_count + 1
				move (offset_to_next_sample)
			end
			if test_count > 1 then
				Result := sqrt (square_sum / test_count).truncated_to_real
			end

--			log.put_string ("sqrt (")
--			log.put_real (square_sum)
--			log.put_string ("/")
--			log.put_real (test_count)
--			log.put_string (") = ")
--			log.put_real_field ("Result", Result)
--			log.put_new_line
--			log.exit
		end

feature {NONE} -- Implementation

	normalized_item: REAL
			--
		deferred
		end

	start
			--
		deferred
		end

	after: BOOLEAN
			--
		deferred
		end

	sample_count: INTEGER
			--
		deferred
		end

	move (i: INTEGER)
			-- Move cursor `i' positions.
		deferred
		end

feature {NONE} -- Constant

	Rms_sample_ratio: REAL = 0.02
			-- Percentage of samples used to calculate RMS approxiametely.

end
