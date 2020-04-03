note
	description: "Wave sample file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-03 15:10:50 GMT (Friday 3rd April 2020)"
	revision: "5"

class
	EL_WAVE_SAMPLE_FILE [S -> EL_AUDIO_PCM_SAMPLE create make end]

inherit
	EL_WAVE_SAMPLE_FILE_ABS

create
	make

feature {NONE} -- Factory

	new_sample: EL_AUDIO_PCM_SAMPLE
			--
		do
			Result := create {S}.make
		end

end
