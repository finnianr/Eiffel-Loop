note
	description: "Application pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

deferred class
	EL_APPLICATION_PIXMAP

inherit
	EL_MODULE_GUI

	EL_MODULE_SCREEN

	EL_MODULE_IMAGE_PATH
		rename
			Image_path as Mod_image_path
		end

	EL_FACTORY_CLIENT

feature -- Access

	from_file (a_file_path: EL_FILE_PATH): EL_PIXMAP
			--
		do
			if a_file_path.exists then
				create Result
				Result.set_with_named_file (a_file_path)
			else
				Result := Unknown_pixmap
			end
		end

	image_path (relative_path_steps: EL_PATH_STEPS): EL_FILE_PATH
		deferred
		end

feature -- Constants

	Transparent_color: EL_COLOR
		local
			svg_pixmap: EL_SVG_PIXMAP
		once
			create svg_pixmap
			Result := svg_pixmap.Transparent_color
		end

feature -- PNG

	of_height (relative_path_steps: EL_PATH_STEPS; a_height: INTEGER): EL_PIXMAP
			-- Pixmap scaled to height in pixels
		do
			Result := pixmap (relative_path_steps)
			Result.scale_to_height (a_height)
		end

	of_height_cms (relative_path_steps: EL_PATH_STEPS; height_cms: REAL): EL_PIXMAP
			-- Pixmap scaled to height in centimeters
		do
			Result := pixmap (relative_path_steps)
			Result.scale_to_height_cms (height_cms)
		end

	of_width (relative_path_steps: EL_PATH_STEPS; a_width: INTEGER): EL_PIXMAP
			-- Pixmap scaled to width in pixels
		do
			Result := pixmap (relative_path_steps)
			Result.scale_to_width (a_width)
		end

	of_width_cms (relative_path_steps: EL_PATH_STEPS; width_cms: REAL): EL_PIXMAP
			-- Pixmap scaled to width in centimeters
		do
			Result := pixmap (relative_path_steps)
			Result.scale_to_width_cms (width_cms)
		end

	pixmap (relative_path_steps: EL_PATH_STEPS): EL_PIXMAP
			-- Unscaled pixmap
		do
			Result := from_file (image_path (relative_path_steps))
		end

feature -- SVG

	svg_of_height (relative_path_steps: EL_PATH_STEPS; height: INTEGER; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to height in pixels
		do
			Result := new_svg_pixmap (
				agent {EL_SVG_PIXMAP}.make_with_height (image_path (relative_path_steps), height, background_color)
			)
		end

	svg_of_height_cms (relative_path_steps: EL_PATH_STEPS; height_cms: REAL; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to height in centimeters
		do
			Result := new_svg_pixmap (
				agent {EL_SVG_PIXMAP}.make_with_height_cms (image_path (relative_path_steps), height_cms, background_color)
			)
		end

	svg_of_width (relative_path_steps: EL_PATH_STEPS; width: INTEGER; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to width in pixels
		do
			Result := new_svg_pixmap (
				agent {EL_SVG_PIXMAP}.make_with_width (image_path (relative_path_steps), width, background_color)
			)
		end

	svg_of_width_cms (relative_path_steps: EL_PATH_STEPS; width_cms: REAL; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to width in centimeters
		do
			Result := new_svg_pixmap (
				agent {EL_SVG_PIXMAP}.make_with_width_cms (image_path (relative_path_steps), width_cms, background_color)
			)
		end

feature {NONE} -- Factory

	new_svg_pixmap (make_pixmap: PROCEDURE): EL_SVG_PIXMAP
		do
			Procedure.set_from_other (make_pixmap)
			if attached {like image_path} Procedure.closed_operands.reference_item (1) as l_image_path then
				if l_image_path.with_new_extension (Png_extension).exists then
					Result := Svg_factory.instance_from_type ({EL_SVG_TEMPLATE_PIXMAP}, make_pixmap)
				else
					Result := Svg_factory.instance_from_type ({EL_SVG_PIXMAP}, make_pixmap)
				end
			end
			if attached {EL_SVG_TEMPLATE_PIXMAP} Result as template_pixmap then
				template_pixmap.update_png
			end
		end

feature -- Constants

	Unknown_pixmap: EL_PIXMAP
			-- Square tile with a question mark
		local
			font: EL_FONT
			rect: EL_RECTANGLE
		once
			create font.make_bold ("Verdana", 1.0)
			create rect.make_for_text ("?", font)
			create Result.make_with_rectangle (rect)
			Result.set_background_color (GUI.Black)
			Result.set_foreground_color (GUI.White)
			Result.clear
			Result.set_font (font)
			Result.draw_centered_text ("?", rect)
		end

feature {NONE} -- Constants

	Png_extension: ZSTRING
		once
			Result := "png"
		end

	Procedure: EL_PROCEDURE
		once
			create Result
		end

	SVG_factory: EL_OBJECT_FACTORY [EL_SVG_PIXMAP]
		once
			create Result
		end

end
