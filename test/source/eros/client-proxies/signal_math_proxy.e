note
	description: "Signal math proxy"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-19 16:30:47 GMT (Sunday 19th January 2020)"
	revision: "6"

class
	SIGNAL_MATH_PROXY

inherit
	SIGNAL_MATH_I

	EROS_REMOTE_PROXY

create
	make

feature -- Access

	cosine_waveform (i_freq, log2_length: INTEGER; phase_fraction: DOUBLE): COLUMN_VECTOR_COMPLEX_DOUBLE

			-- Processing instruction example:
   			-- 		<?call {SIGNAL_MATH}.cosine_waveform (4, 7, 0.5)?>
		do
			log.enter (R_cosine_waveform)
			call (R_cosine_waveform, [i_freq, log2_length, phase_fraction])

			if not has_error and then attached {like cosine_waveform} result_object as l_result then
				Result := l_result
			else
				create Result.make
			end
			log.exit
		end

end
