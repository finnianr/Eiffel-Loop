note
	description: "Audio monitor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_AUDIO_MONITOR

inherit
	WEL_GROUP_BOX
		rename
			make as make_group_box
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_parent: WEL_WINDOW; a_name: STRING; a_x, a_y, a_width, a_height: INTEGER)
			--
		local
			border_left, border_top: INTEGER
		do
			make_group_box (a_parent, a_name, a_x, a_y, a_width, a_height, 0)

			border_top := 20

			border_left := (height * 0.2).rounded

			create signal_level_meter.make (
				a_parent,
				-- Position
				x + border_left , y + border_top,

				-- Size
				width - border_left * 2 , ((height - border_top) * 0.6).rounded,
				-1
			)
			signal_level_meter.set_range (0, 2000)
		end


feature -- Element change

	set_signal_threshold (rms_energy: REAL)
			--
		do
			signal_level_meter.set_signal_threshold (rms_energy)
		end

feature -- Access

	signal_level_meter: EL_AUDIO_SIGNAL_LEVEL_METER

end
