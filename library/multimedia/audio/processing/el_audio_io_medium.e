note
	description: "Audio sample source for processing with EL_AUDIO_SAMPLE_PROCESSOR"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_AUDIO_IO_MEDIUM

feature {NONE} -- Initialization

	make (a_num_channels: INTEGER)
			--
		do
			num_channels := a_num_channels
			create processors.make (1, num_channels)
		end

feature -- Basic operations

	process_at_sample_rate (a_sample_rate: INTEGER)
			--
		deferred
		end

	process_all
			--
		deferred
		end

	do_all_channels (action: PROCEDURE [EL_AUDIO_SAMPLE_PROCESSOR, TUPLE [EL_AUDIO_SAMPLE_PROCESSOR]])
			--
		local
			i: INTEGER
		do
			from i := 1 until i > num_channels loop
				action.set_operands ([processors.item (i)])
				action.apply
				i := i + 1
			end
		end

feature -- Element change

	set_channel_processor (a_processor: EL_AUDIO_SAMPLE_PROCESSOR; channel: INTEGER)
			-- Set `sample_processor' to `a_sample_processor'.
		do
			processors [channel] := a_processor
		end

feature -- Access

	duration: REAL
			-- Duration in secs

	samples_per_sec: INTEGER
			--
		deferred
		end

	sample_count: INTEGER
			--
		deferred
		end

	num_channels: INTEGER

feature {NONE} -- Implementation

	processors: ARRAY [EL_AUDIO_SAMPLE_PROCESSOR]

end
