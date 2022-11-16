note
	description: "Main window for slide show generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	SLIDE_SHOW_WINDOW

inherit
	EL_TITLED_WINDOW
		rename
			background_color as window_background_color
		redefine
			 make, prepare_to_show
		end

	EL_MODULE_COLOR; EL_MODULE_TRACK; EL_MODULE_OS;  EL_MODULE_VISION_2

create
	make

feature {NONE} -- Initialization

	make
   			--
		do
			Precursor
			set_title ("Slide Show Generator")
			create progress_bar.make_size (10, 0.3)
			progress_bar.set_background_color (Color.White)
			progress_bar.set_foreground_color (Color.Green)
			create label
			Slide_show.generation_done.add_action (agent label.set_text ("DONE"))
		end

feature {NONE} -- Event handler

	on_generate
		do
			label.remove_text
			Track.progress (progress_bar, Slide_show.count, agent Slide_show.generate)
		end

feature {NONE} -- Implementation

	new_border_box: EL_VERTICAL_BOX
		do
			create Result.make_unexpanded (0.25, 0.2, <<
				Vision_2.new_horizontal_box (0, 0.2, <<
					Vision_2.new_label ("Generate slides"), Vision_2.new_button ("GO", agent on_generate), label
				>>),
				progress_bar,
				Vision_2.new_horizontal_box (0, 0.2, <<
					create {EL_EXPANDED_CELL}, Vision_2.new_button ("EXIT", agent on_close_request)
				>>)
			>>)
		end

	prepare_to_show
			--
		do
			extend (new_border_box)
			Screen.center (Current)
		end

feature {NONE} -- Internal attributes

	progress_bar: EL_PROGRESS_BAR

	label: EL_LABEL

feature {NONE} -- Constants

	Border_width_cms: REAL = 0.5

	Slide_show: SLIDE_SHOW
		once ("PROCESS")
			Result := create {EL_SINGLETON [SLIDE_SHOW]}
		end

end