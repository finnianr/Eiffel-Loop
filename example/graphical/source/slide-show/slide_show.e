note
	description: "Configurable slide-show generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-02 16:34:48 GMT (Thursday 2nd June 2022)"
	revision: "4"

class
	SLIDE_SHOW

inherit
	EL_SLIDE_SHOW
		undefine
			new_lio
		redefine
			make, new_group
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_RECTANGULAR

	EL_MODULE_COLOR; EL_MODULE_LOG; EL_MODULE_GUI

create
	make

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
			--
		do
			make_solitary

			Precursor (a_file_path)
			create drawing_area.make_with_size (width, height)
			drawing_area.set_color (Color.black)
			drawing_area.fill
		end

feature -- Basic operations

	generate_all (label: EV_TEXTABLE)
		do
			log.enter ("generate_all")
			OS.File_system.make_directory (output_dir)

			counter.reset
			label.remove_text
			lio.put_labeled_string ("Configured aspect", dimensions.aspect_ratio_formatted)
			lio.put_new_line

			across 1 |..| title_duration_ratio as n loop
				if attached new_image (cover_image) as image then
					add_image (image)
				end
			end
			across group_list as list loop
				list.item.generate
			end
			if attached ("DONE !") as str then
				label.set_text (str)
				log.put_line (str)
			end
			log.exit
		end

	add_image (image: CAIRO_DRAWING_AREA)

		do
			drawing_area.fill
			drawing_area.draw_fitted_area (image)
			save_next_jpeg
		end

	add_named_image (file_path: FILE_PATH; print_info: BOOLEAN)
		do
			if attached new_image (file_path) as image then
				if print_info then
					image.dimensions.print_info (lio, group_name (file_path))
				end
				add_image (image)
			end
		end

feature {SLIDE_GROUP} -- Factory

	new_group (name: ZSTRING; file_list: EL_ARRAYED_LIST [FILE_PATH]): SLIDE_GROUP
		do
			create Result.make (name, file_list, Current)
		end

	new_name_font: EV_FONT
		do
			create Result.make_with_values (Gui.Family_sans, Gui.Weight_regular, Gui.Shape_italic, font_height * 2 // 3)
			Result.preferred_families.extend (title_font)
		end

	new_image (file_path: FILE_PATH): CAIRO_DRAWING_AREA
		do
			create Result.make_with_path (file_path)
		end

	new_theme_font: EV_FONT
		do
			create Result.make_with_values (Gui.Family_sans, Gui.Weight_bold, Gui.Shape_regular, font_height)
			Result.preferred_families.extend (title_font)
		end

feature {NONE} -- Implementation

	save_next_jpeg
		do
			counter.bump
			drawing_area.save_as_jpeg (sequence_path, jpeg_quality)
			progress_listener.notify_tick
		end

feature {NONE} -- Internal attributes

	drawing_area: CAIRO_DRAWING_AREA

end