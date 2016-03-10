note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	LB_MICROPHONE_FLASH_UI_LISTENER

inherit
	EL_FLASH_REMOTE_UI_EVENT_LISTENER
		rename
			make as make_with_port
		redefine
			on_close
		end

	LB_SHARED_CONFIGURATION
	
feature -- Initialization

	make (an_audio_input_window: LB_AUDIO_INPUT_WINDOW_THREAD_PROXY)
			--
		do
			make_with_port (config.Flash_receive_msg_port_num)
			audio_input_window := an_audio_input_window

			is_auto_launched := not config.is_debug_flash_mode.item

			command_actions.put (agent on_start, Cmd_start)
			command_actions.put (agent on_stop,	 Cmd_stop)
			
		end

feature -- Status query

	is_auto_launched: BOOLEAN

feature {NONE} -- Command actions

	on_stop
			--
		do
			audio_input_window.stop_recording
		end
		
	on_start
			--
		do
			audio_input_window.start_recording
		end

	on_close
			--
		do
			audio_input_window.destroy
			Precursor
		end

feature -- Implementation

	audio_input_window: LB_AUDIO_INPUT_WINDOW
	
feature {NONE} -- Constants

	Cmd_start: STRING = "start"

	Cmd_stop: STRING = "stop"

end

