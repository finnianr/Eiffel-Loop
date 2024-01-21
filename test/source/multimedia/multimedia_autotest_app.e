note
	description: "Finalized executable tests for library [./library/multi-media.html multi-media.ecf]"
	notes: "[
		Command option: `-multimedia_autotest'
		
		**Test Sets**
		
			${AUDIO_COMMAND_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-21 12:54:19 GMT (Sunday 21st January 2024)"
	revision: "70"

class
	MULTIMEDIA_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [AUDIO_COMMAND_TEST_SET]

create
	make

feature {NONE} -- Compile classes

	compile: TUPLE [
		EL_8_BIT_AUDIO_PCM_SAMPLE,
		EL_16_BIT_AUDIO_SAMPLE_ARRAYED_LIST,
		EL_16_BIT_AUDIO_PCM_SAMPLE,
		EL_32_BIT_AUDIO_PCM_SAMPLE,

		EL_AUDIO_SAMPLE_MEMORY_LIST,
		EL_AUDIO_RMS_ENERGY,
		EL_AUDIO_SAMPLE_PROCESSOR,
		EL_AUDIO_SEGMENT_PARAMS,

		EL_FIXED_DEPTH_WAVE_FILE [EL_AUDIO_PCM_SAMPLE],
		EL_MP3_AUDIO_SIGNATURE_READER,
		EL_MONO_UNITIZED_SAMPLE_FILE,
		EL_MULTICHANNEL_AUDIO_UNIT_SAMPLE_ARRAY [NUMERIC],

		EL_PCM_SAMPLE_BLOCK_ARRAY [NUMERIC],
		EL_SEGMENTING_AUDIO_PROCESSOR,
		EL_WAVE_FILE,
		EL_WAVE_SAMPLE_FILE [EL_AUDIO_PCM_SAMPLE]
	]
		do
			create Result
		end
end