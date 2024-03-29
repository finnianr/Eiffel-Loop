note
	description: "Network proxy for remote instance of class ${SIGNAL_MATH}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "11"

class
	SIGNAL_MATH_PROXY

inherit
	SIGNAL_MATH_I

	EROS_PROXY

create
	make

feature -- Access

	cosine_waveform (i_freq, log2_length: INTEGER; phase_fraction: DOUBLE): COLUMN_VECTOR_COMPLEX_64

			-- Processing instruction example:
				-- 		<?call {SIGNAL_MATH}.cosine_waveform (4, 7, 0.5)?>
		local
			l_result: EROS_MAKEABLE_RESULT [COLUMN_VECTOR_COMPLEX_64]
		do
			log.enter (R_cosine_waveform)
			create l_result.make_call (Current, R_cosine_waveform, [i_freq, log2_length, phase_fraction])
			Result := l_result.item
			log.exit
		end

end