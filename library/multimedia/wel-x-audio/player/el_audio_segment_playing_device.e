note
	description: "Audio segment playing device"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_AUDIO_SEGMENT_PLAYING_DEVICE

inherit
	WEX_MCI_WAVE_AUDIO
		rename
			playing as is_playing
		end

	WEX_MCI_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature -- Basic operations

	play_segment (segment_params: EL_AUDIO_SEGMENT_PARAMS)
			--
		require
			opened: opened
			not_already_playing: not is_playing
			can_play: can_play
		local
			play_parms: WEX_MCI_PLAY_PARMS
		do
			create play_parms.make (parent, segment_params.onset, segment_params.offset)
			play_device (play_parms, Mci_notify | Mci_from | Mci_to)
		end

end