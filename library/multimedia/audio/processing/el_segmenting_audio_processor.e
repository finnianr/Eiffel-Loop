note
	description: "Processes audio in manageable segments separated by silence (low signal)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_SEGMENTING_AUDIO_PROCESSOR

inherit
	EL_AUDIO_SAMPLE_PROCESSOR
		redefine
			on_start
		end
		
feature {NONE} -- Initialization

	make (a_segment_duration: REAL)
			-- make with segment_duration in seconds
		do
			segment_duration := a_segment_duration
		end
		
feature -- Access

	segment_duration: REAL
		
feature -- Basic operations

	on_start
			-- 
		require else
			segment_duration_big_enough: segment_duration > sample_rms_chunk_millisecs * 2 / 1000.0
		do
			samples_per_segment := (sample_count * (segment_duration / duration)).rounded
			samples_per_rms_chunk := (samples_per_sec * (sample_rms_chunk_millisecs / 1000.0)).rounded
			create segment_rms_chunk_list.make (
				(segment_duration / (sample_rms_chunk_millisecs / 1000.0)).rounded
			)
			create last_rms_chunk.make (samples_per_rms_chunk)
		end

	do_with_sample_at_time (value, index: INTEGER; offset_time: REAL)
			--
		do
		end
		
	do_with_sample (value, index: INTEGER)
			--
		local
			is_last_sample: BOOLEAN
		do
			is_last_sample := index = sample_count
			last_rms_chunk.extend (value.to_integer_16)

			if is_last_sample or last_rms_chunk.sample_count = samples_per_rms_chunk then
				segment_rms_chunk_list.extend (last_rms_chunk)
				segment_sample_count := segment_sample_count + samples_per_rms_chunk
				if is_last_sample or 
					(segment_sample_count > samples_per_segment 
						and then last_rms_chunk.rms_energy < Silent_rms_threshold)  
				then
					process_segment (segment_rms_chunk_list)
					segment_rms_chunk_list.wipe_out
					segment_sample_count := 0
				end
				create last_rms_chunk.make (samples_per_rms_chunk)
			end
		end
		
	process_segment (chunk_list: like segment_rms_chunk_list)
			-- 
		deferred
		end
		
feature {NONE} -- Implementation

	samples_per_segment: INTEGER
	
	segment_rms_chunk_list: ARRAYED_LIST [EL_16_BIT_AUDIO_SAMPLE_ARRAYED_LIST]
	
	last_rms_chunk: EL_16_BIT_AUDIO_SAMPLE_ARRAYED_LIST
	
	samples_per_rms_chunk: INTEGER
			-- Number of samples
	
	segment_sample_count: INTEGER
	
feature -- Constant

	sample_rms_chunk_millisecs: INTEGER = 200
			-- Size of chunk to measure RMS signal
		
	silent_rms_threshold: REAL = 0.01
		
end
