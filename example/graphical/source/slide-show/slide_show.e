note
	description: "Configurable slide-show generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-09 9:37:08 GMT (Monday 9th September 2024)"
	revision: "8"

class
	SLIDE_SHOW

inherit
	EL_SLIDE_SHOW
		undefine
			new_lio
		redefine
			make, generate
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_RECTANGULAR

	EL_MODULE_COLOR; EL_MODULE_LOG; EL_MODULE_TEXT

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

	generate
		do
			log.enter ("generate_all")
			Precursor
			log.exit
		end

	print_info (slide: like new_slide; name: ZSTRING)
		do
			slide.dimensions.print_info (lio, name)
		end

feature -- Element change

	extend (slide: like new_slide)
		do
			drawing_area.fill
			drawing_area.draw_fitted_area (slide)
			save_next_jpeg
		end

feature {NONE} -- Factory

	new_name_font: EV_FONT
		do
			create Result.make_with_values (
				Text_.Family_sans, Text_.Weight_regular, Text_.Shape_italic, font_height * 2 // 3
			)
			Result.preferred_families.extend (title_font)
		end

	new_slide (file_path: FILE_PATH): CAIRO_DRAWING_AREA
		do
			create Result.make_with_path (file_path)
		end

	new_theme_font: EV_FONT
		do
			create Result.make_with_values (Text_.Family_sans, Text_.Weight_bold, Text_.Shape_regular, font_height)
			Result.preferred_families.extend (title_font)
		end

	new_title_slide (title, sub_title: ZSTRING): like new_slide
		local
			rect: EL_RECTANGLE; l_height: INTEGER
		do
			rect := dimensions
			create Result.make_with_size (rect.width, rect.height)

			Result.set_color (Color.Black); Result.fill

			Result.set_color (Color.White)

			l_height := (rect.height / 5).rounded
			rect.set_height (l_height)
			across << title, sub_title >> as str loop
				rect.move_by (0, rect.height)
				if str.is_first then
					Result.set_font (new_theme_font)
				else
					Result.set_font (new_name_font)
				end
				Result.draw_centered_text (str.item, rect)
			end
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