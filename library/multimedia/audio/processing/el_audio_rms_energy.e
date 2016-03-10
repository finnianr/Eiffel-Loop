note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_AUDIO_RMS_ENERGY

inherit
	EL_AUDIO_SAMPLE_PROCESSOR

	DOUBLE_MATH
		rename
			log as logarithm
		end

	EL_MODULE_LOG

	EL_EVENT_CHECKER

create
	make

feature {NONE} -- Initialization

	make (block_duration_millisecs: INTEGER)
			--
		do
			block_duration := (block_duration_millisecs / 1000.0).truncated_to_real
		end

feature -- Basic operations

	calculate (sample_source: EL_AUDIO_IO_MEDIUM)
			--
		do
			create rms_array.make (1, (sample_source.duration / block_duration).ceiling )
			block_index := 1
			sample_square_sum := 0
			rms_block_offset := block_duration
			rms_sum_over_threshold := 0
			rms_count_over_threshold := 0
			sample_source.set_channel_processor (Current, 1)

			sample_source.process_at_sample_rate ((1.0 / block_duration * Samples_per_block).rounded)
			rms_mean_over_threshold := (rms_sum_over_threshold.to_double / rms_count_over_threshold).rounded
		end

feature -- Access

	rms_array: ARRAY [INTEGER]

	rms_mean_over_threshold: INTEGER

	block_duration: REAL

	mean_over_threshold: INTEGER

feature {NONE} -- Implementation

	do_with_sample_at_time (value, index: INTEGER; offset_time: REAL)
			--
		local
			rms_value: INTEGER
		do
			if offset_time > rms_block_offset then
				rms_value  := sqrt (sample_square_sum.to_double).rounded
				rms_array [block_index] := rms_value
				if rms_value > Signal_threshold then
					rms_sum_over_threshold := rms_sum_over_threshold + rms_value
					rms_count_over_threshold := rms_count_over_threshold + 1
				end
				block_index := block_index + 1
				rms_block_offset := block_duration * block_index
				sample_square_sum := 0

				-- Intended for UI events
			end
			sample_square_sum := sample_square_sum + value * value

			check_events
		end

	do_with_sample (value, index: INTEGER)
			-- Not used
		do
		end

	rms_sum_over_threshold: INTEGER_64

	rms_count_over_threshold: INTEGER

	sample_square_sum: INTEGER_64

	block_index: INTEGER

	rms_block_offset: REAL

feature -- Constants

	Signal_threshold: INTEGER = 1000
			-- Minimum level

	Samples_per_block: INTEGER = 8
			-- Number of representative samples per block to calculate
			-- More means more accurate but slower

end
