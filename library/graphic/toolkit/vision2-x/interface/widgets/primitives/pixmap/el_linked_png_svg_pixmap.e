note
	description: "PNG graphic linked to SVG"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-28 16:40:15 GMT (Tuesday 28th January 2014)"
	revision: "3"

class
	EL_LINKED_PNG_SVG_PIXMAP

inherit
	EL_SVG_PIXMAP
		rename
			svg_path as svg_template_path,
			update_pixmap_if_made as update_png
		export
			{ANY} is_initialized, update_png
		redefine
			update_pixmap_on_initialization, initialize, make_with_path_and_width, make_with_path_and_height,
			update_pixmap, modifyable_colors, set_background_color
		end

create
	default_create,
	make_from_other,
	make_with_width_cms, make_with_height_cms,
	make_with_width, make_with_height,
	make_with_path_and_width, make_with_path_and_height

feature {NONE} -- Initialization

	make_with_path_and_width (a_svg_template_path: like svg_template_path;  a_width: INTEGER; a_background_color: EV_COLOR)
			--
		do
			Precursor (a_svg_template_path, a_width, a_background_color)
			is_made := True
		end

	make_with_path_and_height (a_svg_template_path: like svg_template_path; a_height: INTEGER; a_background_color: EV_COLOR)
		do
			Precursor (a_svg_template_path, a_height, a_background_color)
			is_made := True
		end

	initialize
		do
			Precursor
			create variables.make_equal (3)
			create color_table.make_equal (3)
		end

feature -- Element change

	set_color (name: EL_ASTRING; a_color: EL_COLOR)
		do
			color_table [name] := a_color.rgb_24_bit
		end

	set_file_path_variable (name: STRING; file_path: EL_FILE_PATH)
		do
			if {PLATFORM}.is_windows then
				set_variable (name, quasi_unix_path (file_path).to_utf8)
			else
				set_variable (name, file_path.to_string.to_utf8)
			end
		end

	set_variable (name, a_value: STRING)
		do
			variables [name] := a_value
		end

	set_background_color (a_color: like background_color)
			--
		do
			implementation.set_background_color (a_color)
			background_color_24_bit := background_color.rgb_24_bit
		end

feature {EL_SVG_PIXMAP} -- Implementation

	update_pixmap (a_svg_path: like svg_template_path)
		local
			color_id: STRING
			l_svg_path: like svg_template_path
			l_png_output_dir: like png_output_dir
			svg_template: EL_SUBSTITUTION_TEMPLATE [STRING]
			svg_file: PLAIN_TEXT_FILE
		do
			l_png_output_dir := png_output_dir
			File_system.make_directory (l_png_output_dir)
			l_svg_path := l_png_output_dir + svg_template_path.base
			if not l_svg_path.exists or else not png_output_path.exists then
				create svg_template.make (File_system.plain_text (svg_template_path))
				set_file_path_variable (Var_image_path, svg_template_path.with_new_extension (Extension_png))
				across color_table as table loop
					color_id := table.item.to_hex_string
					color_id.put ('#', 2)
					color_id.remove_head (1)
					variables [table.key] := color_id
				end
				across variables as var loop
					if svg_template.has_variable (var.key) then
						svg_template.set_variable (var.key, var.item)
					end
				end
				create svg_file.make_open_write (l_svg_path.unicode)
				svg_file.put_string (svg_template.substituted)
				svg_file.close
			end
			Precursor (l_svg_path)
		end

	update_pixmap_on_initialization: BOOLEAN
		do
			Result := False
		end

	modifyable_colors: ARRAYED_LIST [INTEGER]
		do
			Result := Precursor
			Result.append (color_table.linear_representation)
		end

	quasi_unix_path (windows_path: EL_FILE_PATH): EL_ASTRING
			-- Returns quasi unix path for SVG element <image xlink:href/>
			-- Example:
			-- 	C:\Program files\icons\button.png
			-- becomes:
			-- 	/C:/Program files/icons/button.png
		require
			platform_is_windows: {PLATFORM}.is_windows
		do
			Result := windows_path.to_unix.to_string
			if windows_path.is_absolute then
				Result.prepend_character ('/')
			end
		end

	color_table: HASH_TABLE [INTEGER, STRING]

	variables: HASH_TABLE [STRING, STRING]

feature {NONE} -- Constants

	Var_image_path: STRING = "image_path"

end
