note
	description: "Summary description for {EL_APPLICATION_PIXMAP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-02 18:11:59 GMT (Thursday 2nd July 2015)"
	revision: "6"

deferred class
	EL_APPLICATION_PIXMAP

inherit
	EL_MODULE_GUI

	EL_MODULE_SCREEN

	EL_MODULE_IMAGE_PATH
		rename
			Image_path as Mod_image_path
		end

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

	pixmap (relative_path_steps: EL_PATH_STEPS): EL_PIXMAP
			-- Unscaled pixmap
		do
			Result := from_file (image_path (relative_path_steps))
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

feature -- SVG

	svg_of_width (relative_path_steps: EL_PATH_STEPS; width: INTEGER; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to width in pixels
		local
			l_image_path: like image_path
		do
			l_image_path := image_path (relative_path_steps)
			if l_image_path.with_new_extension ("png").exists then
				create {EL_SVG_TEMPLATE_PIXMAP} Result.make_with_width (l_image_path, width, background_color)

			else
				create Result.make_with_width (l_image_path, width, background_color)
			end
		end

	svg_of_width_cms (relative_path_steps: EL_PATH_STEPS; width_cms: REAL; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to width in centimeters
		local
			l_image_path: like image_path
		do
			l_image_path := image_path (relative_path_steps)
			if l_image_path.with_new_extension ("png").exists then
				create {EL_SVG_TEMPLATE_PIXMAP} Result.make_with_width_cms (l_image_path, width_cms, background_color)
			else
				create Result.make_with_width_cms (l_image_path, width_cms, background_color)
			end
		end

	svg_of_height (relative_path_steps: EL_PATH_STEPS; height: INTEGER; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to height in pixels
		local
			l_image_path: like image_path
		do
			l_image_path := image_path (relative_path_steps)
			if l_image_path.with_new_extension ("png").exists then
				create {EL_SVG_TEMPLATE_PIXMAP} Result.make_with_height (l_image_path, height, background_color)

			else
				create Result.make_with_height (l_image_path, height, background_color)
			end
		end

	svg_of_height_cms (relative_path_steps: EL_PATH_STEPS; height_cms: REAL; background_color: EL_COLOR): EL_SVG_PIXMAP
			-- Pixmap scaled to height in centimeters
		local
			l_image_path: like image_path
		do
			l_image_path := image_path (relative_path_steps)
			if l_image_path.with_new_extension ("png").exists then
				create {EL_SVG_TEMPLATE_PIXMAP} Result.make_with_height_cms (l_image_path, height_cms, background_color)
			else
				create Result.make_with_height_cms (l_image_path, height_cms, background_color)
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

end
