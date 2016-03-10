note
	description: "Summary description for {EL_SVG_PIXMAP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-10 10:37:34 GMT (Friday 10th January 2014)"
	revision: "3"

class
	EL_SVG_PIXMAP

inherit
	EL_PIXMAP
		rename
			pixmap_path as pixmap_path
		redefine
			initialize, set_background_color
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_SCREEN
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_SVG
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create, is_equal, copy
		end

	EL_SHARED_FILE_PROGRESS_LISTENER
		undefine
			default_create, is_equal, copy
		end

	EV_BUILDER

create
	default_create,
	make_from_other, make_with_width, make_with_height,
	make_with_width_cms, make_with_height_cms,
	make_with_path_and_width, make_with_path_and_height

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create svg_path
			create png_output_path
		end

	make_from_other (other: like Current)
			--
		do
			default_create
			is_width_scaled := other.is_width_scaled
			dimension := other.dimension
			svg_path := other.svg_path
			png_output_path := other.png_output_path
			pixmap_path := other.pixmap_path
			create text_origin.make (other.text_origin.x, other.text_origin.y)
			set_background_color (other.background_color)
			background_color_24_bit := other.background_color_24_bit
			update_pixmap (svg_path)
			is_made := update_pixmap_on_initialization
		end

	make_with_height (a_svg_path: like svg_path; a_height: INTEGER; a_background_color: EL_COLOR)
			--
		do
			make_with_path_and_height (a_svg_path, a_height, a_background_color)
		end

	make_with_height_cms (a_svg_path: like svg_path; a_height_cms: REAL; a_background_color: EL_COLOR)
			--
		do
			make_with_path_and_height (
				a_svg_path, Screen.vertical_pixels (a_height_cms), a_background_color
			)
		end

	make_with_width (a_svg_path: like svg_path; a_width: INTEGER; a_background_color: EL_COLOR)
			--
		do
			make_with_path_and_width (a_svg_path, a_width, a_background_color)
		end

	make_with_width_cms (a_svg_path: like svg_path; a_width_cms: REAL; a_background_color: EL_COLOR)
			--
		do
			make_with_path_and_width (
				a_svg_path, Screen.horizontal_pixels (a_width_cms), a_background_color
			)
		end

	make_with_path_and_width (a_svg_path: like svg_path;  a_width: INTEGER; a_background_color: EV_COLOR)
			--
		do
			default_create
			svg_path := a_svg_path
			create text_origin
			is_width_scaled := True
			set_dimension (a_width)
			set_background_color (a_background_color)
			is_made := update_pixmap_on_initialization
			update_pixmap_if_made
		end

	make_with_path_and_height (a_svg_path: like svg_path; a_height: INTEGER; a_background_color: EV_COLOR)
			--
		do
			default_create
			svg_path := a_svg_path
			create text_origin
			is_width_scaled := False
			set_dimension (a_height)
			set_background_color (a_background_color)
			is_made := update_pixmap_on_initialization
			update_pixmap_if_made
		end

feature -- Access

	svg_path: EL_FILE_PATH

	png_output_path: EL_FILE_PATH
		-- png output path

	dimension: INTEGER
		-- pixel dimension width or height depending on is_width_scaled

feature -- Status report

	is_width_scaled: BOOLEAN

feature -- Element change

	set_svg_path (a_svg_path: like svg_path)
		do
			svg_path := a_svg_path
			update_pixmap_if_made
		end

	set_dimension (a_dimension: INTEGER)
			--
		do
			dimension := a_dimension
			update_pixmap_if_made
		end

	set_dimension_cms (a_dimension_cms: REAL)
			--
		do
			if is_width_scaled then
				dimension := Screen.horizontal_pixels (a_dimension_cms)
			else
				dimension := Screen.vertical_pixels (a_dimension_cms)
			end
			update_pixmap_if_made
		end

	set_background_color (a_color: like background_color)
			--
		do
			Precursor (a_color)
			background_color_24_bit := background_color.rgb_24_bit
			update_pixmap_if_made
		end

feature {EL_SVG_PIXMAP} -- Implementation

	set_pixmap_path_from_svg
		local
			background_color_id: EL_ASTRING
		do
			png_output_path := (png_output_dir + svg_path.base).without_extension

			across modifyable_colors as l_color loop
				create background_color_id.make_from_string (l_color.item.to_hex_string)
				background_color_id.put ('c', 2)
--				Result [2] := 'c' This has a bug in the finalized exe
				background_color_id.remove_head (1)
				png_output_path.add_extension (background_color_id)
			end

			if is_width_scaled then
				png_output_path.add_extension (Initial_w + dimension.out )
			else
				png_output_path.add_extension (Initial_h + dimension.out )
			end
			png_output_path.add_extension (Extension_png)
			pixmap_path := png_output_path.to_path
		end

	png_output_dir: EL_DIR_PATH
		local
			base_path, pixmap_base_path: EL_DIR_PATH
			relative_path: EL_FILE_PATH
		do
			base_path := Execution_environment.Application_installation_dir
			if Execution_environment.Application_installation_dir.is_parent_of (svg_path) then
				pixmap_base_path := Execution_environment.User_configuration_dir
			else
				base_path := svg_path.parent
				pixmap_base_path := base_path
			end
			relative_path := svg_path.relative_path (base_path)
			Result := pixmap_base_path.joined_file_path (relative_path).parent
		end

	update_pixmap_if_made
		do
			if is_made then
				set_pixmap_path_from_svg
				update_pixmap (svg_path)
			end
		end

	update_pixmap (a_svg_path: like svg_path)
			--
		local
			png_dir: EL_DIR_PATH
		do
			log.enter_no_header ("update_pixmap")
			if a_svg_path.exists and then not png_output_path.exists then
				png_dir := png_output_path.parent
				if not png_dir.exists then
					File_system.make_directory (png_dir)
				end
				log_or_io.put_string_field ("Writing", png_output_path.to_string)
				log_or_io.put_new_line
				if is_width_scaled then
					SVG.write_png_of_width (a_svg_path, png_output_path, dimension, background_color_24_bit)
				else
					SVG.write_png_of_height (a_svg_path, png_output_path, dimension, background_color_24_bit)
				end
				file_listener.on_write (File_system.file_byte_count (png_output_path))
			end
			if png_output_path.exists then
				set_with_named_path (pixmap_path)
				pixmap_exists := True
			end
			log.exit_no_trailer
		ensure
			write_succeeded: a_svg_path.exists implies pixmap_exists
		end

	update_pixmap_on_initialization: BOOLEAN
		do
			Result := True
		end

	set_centered_text_origin (a_width, a_height, left_offset, right_offset: INTEGER)
			--
		do
			create text_origin.make (
				((width - a_width) / 2).rounded,
				((height - a_height) / 2).rounded
			)
		end

	modifyable_colors: ARRAYED_LIST [INTEGER]
		do
			create Result.make (1)
			Result.extend (background_color_24_bit)
		end

	is_made: BOOLEAN

	text_origin: EV_COORDINATE

	background_color_24_bit: INTEGER

--	template: EL_SUBSTITUTION_TEMPLATE [EL_ASTRING]

feature -- Conversion

	to_pixmap: EV_PIXMAP
		local
			pixel_buffer: EV_PIXEL_BUFFER
		do
			create pixel_buffer.make_with_pixmap (Current)
			create Result.make_with_pixel_buffer (pixel_buffer)
		end

feature {NONE} -- Constants

	Extension_png: EL_ASTRING
		once
			Result := "png"
		end

	Initial_w: EL_ASTRING
		once
			Result := "w"
		end

	Initial_h: EL_ASTRING
		once
			Result := "h"
		end

end
