note
	description: "Svg template pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 16:12:08 GMT (Friday 8th January 2021)"
	revision: "15"

class
	EL_SVG_TEMPLATE_PIXMAP

inherit
	EL_SVG_PIXMAP
		rename
			svg_path as svg_template_path,
			update_pixmap_if_made as update_png
		export
			{ANY} is_initialized, update_png
		redefine
			update_pixmap_on_initialization, initialize, make_with_path_and_width, make_with_path_and_height,
			rendering_variables, svg_xml
		end

	EL_MODULE_BUFFER

create
	default_create, make_from_other,

	make_with_width_cms, make_with_height_cms,
	make_with_width, make_with_height,
	make_with_path_and_width, make_with_path_and_height,

	make_transparent_with_width, make_transparent_with_height,
	make_transparent_with_width_cms, make_transparent_with_height_cms,
	make_transparent_with_path_and_width, make_transparent_with_path_and_height

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create color_table.make_equal (3)
			create variables.make_equal (3)
			create template.make_default
		end

	make_with_path_and_height (a_svg_template_path: like svg_template_path; a_height: INTEGER; a_background_color: EL_COLOR)
		do
			Precursor (a_svg_template_path, a_height, a_background_color)
			is_made := True
		end

	make_with_path_and_width (a_svg_template_path: like svg_template_path;  a_width: INTEGER; a_background_color: EL_COLOR)
			--
		do
			Precursor (a_svg_template_path, a_width, a_background_color)
			is_made := True
		end

feature -- Element change

	set_color (a_name: ZSTRING; a_color: EL_COLOR)
		do
			color_table [a_name] := a_color.rgb_24_bit
		end

	set_variable (a_name: ZSTRING; value: ANY)
		do
			variables [a_name] := value
		end

feature {EL_SVG_PIXMAP} -- Implementation

	rendering_variables: EL_ARRAYED_MAP_LIST [STRING, INTEGER]
		do
			Result := Precursor
			across color_table as l_color loop
				Result.extend (Initial_c, l_color.item)
			end
		end

	svg_xml (a_svg_template_path: EL_FILE_PATH): STRING
		local
			svg_in: PLAIN_TEXT_FILE; done: BOOLEAN; line: STRING
		do
			create svg_in.make_open_read (a_svg_template_path)
			create Result.make (svg_in.count + 100)
			update_variables
			from until done loop
				svg_in.read_line
				if svg_in.end_of_file then
					done := True
				else
					line := svg_in.last_string
					if line.has ('$') then
						check_for_xlink_uri (a_svg_template_path, line)
						template.set_template (line)
						across variables as variable loop
							if template.has_variable (variable.key) then
								template.set_variable (variable.key, variable.item)
							end
						end
						Result.append (template.substituted)
					else
						Result.append (line)
					end
					Result.append_character ('%N')
				end
			end
		end

	update_pixmap_on_initialization: BOOLEAN
		do
			Result := False
		end

	update_variables
		local
			color_id: STRING
		do
			across color_table as table loop
				color_id := table.item.to_hex_string
				color_id.put ('#', 2)
				color_id.remove_head (1)
				set_variable (table.key, color_id)
			end
		end

	check_for_xlink_uri (a_svg_path: EL_FILE_PATH; line: STRING)
		local
			dir_uri: EL_DIR_URI_PATH
		do
			if line.has_substring (Xlink_uri_placeholder) then
				dir_uri := a_svg_path.parent
				set_variable (Var_file_dir_uri, dir_uri.to_string.to_utf_8)
			end
		end

feature {NONE} -- Internal attributes

	color_table: HASH_TABLE [INTEGER, STRING]

	template: EL_STRING_8_TEMPLATE

	variables: EL_ZSTRING_HASH_TABLE [ANY]

feature {NONE} -- Constants

	Var_file_dir_uri: ZSTRING
		once
			Result := "file_dir_uri"
		end

	Xlink_uri_placeholder: STRING
		once
			Result := "$/"
			Result.insert_string (Var_file_dir_uri.to_latin_1, 2)
		end
end