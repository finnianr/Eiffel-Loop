note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_AUDIO_SAMPLE_PROCESSOR

feature -- Access

	sample_count: INTEGER

	samples_per_sec: INTEGER

	duration: REAL
			--
		do
			Result := (sample_count / samples_per_sec).truncated_to_real
		end

feature -- Element change

	set_sample_count (a_sample_count: like sample_count)
			-- Set `sample_count' to `a_sample_count'.
		do
			sample_count := a_sample_count
		ensure
			sample_count_assigned: sample_count = a_sample_count
		end

	set_samples_per_sec (a_samples_per_sec: like samples_per_sec)
			-- Set `samples_per_sec' to `a_samples_per_sec'.
		do
			samples_per_sec := a_samples_per_sec
		ensure
			samples_per_sec_assigned: samples_per_sec = a_samples_per_sec
		end

feature -- Basic operations

	on_start
			--
		do
		end

	on_finish
			--
		do
		end

	do_with_sample_at_time (value, index: INTEGER; offset_time: REAL)
			--
		require
			valid_index: index >= 1 and index <= sample_count
		deferred
		end

	do_with_sample (value, index: INTEGER)
			--
		require
			valid_index: index >= 1 and index <= sample_count
		deferred
		end

end
