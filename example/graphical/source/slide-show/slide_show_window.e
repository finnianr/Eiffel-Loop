note
	description: "Main window for slide show generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-26 17:06:59 GMT (Thursday 26th May 2022)"
	revision: "1"

class
	SLIDE_SHOW_WINDOW

inherit
	EL_TITLED_WINDOW
		rename
			background_color as window_background_color
		redefine
			 make, prepare_to_show
		end

	EL_MODULE_COLOR; EL_MODULE_TRACK; EL_MODULE_FILE_SYSTEM;  EL_MODULE_VISION_2

	EL_SHARED_PROGRESS_LISTENER

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
		end

feature {NONE} -- Event handler

	on_generate
		do
			Track.progress (progress_bar, Config.total_image_count, agent generate_all)
		end

feature {NONE} -- Implementation

	generate_all
		local
			pixmap: EL_PIXMAP
		do
			log.enter ("generate_all")
			File_system.make_directory (Config.output_dir)

			Config.reset_sequence
			label.remove_text
			lio.put_labeled_string ("Configured aspect", config.Double.formatted (Config.dimensions.aspect_ratio))
			lio.put_new_line

			if attached Config.new_area as area then
				create pixmap
				pixmap.set_with_named_file (config.cover_image)
				area.draw_centered_pixmap (pixmap)
				across 1 |..| Config.title_duration_ratio as n loop
					Config.bump_sequence
					-- Generate cover image
					area.save_as_jpeg (Config.sequence_path, 90)
					progress_listener.notify_tick
				end
			end
			across Config.group_list as list loop
				list.item.generate
			end
			if attached ("DONE !") as str then
				label.set_text (str)
				log.put_line (str)
			end
			log.exit
		end

	new_border_box: EL_VERTICAL_BOX
		do
			create Result.make_unexpanded (0.25, 0.2, <<
				Vision_2.new_horizontal_box (0, 0.2, <<
					Vision_2.new_label ("Generate slides"), Vision_2.new_button ("GO", agent on_generate), label
				>>),
				progress_bar
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

	Config: SLIDE_SHOW_CONFIG
		once
			Result := create {EL_SINGLETON [SLIDE_SHOW_CONFIG]}
		end

end