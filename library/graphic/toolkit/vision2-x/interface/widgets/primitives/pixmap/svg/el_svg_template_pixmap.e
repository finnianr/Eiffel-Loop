note
	description: "Summary description for {EL_SVG_TEMPLATE_PIXMAP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:13 GMT (Tuesday 2nd September 2014)"
	revision: "5"

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

	EL_SHARED_ONCE_STRINGS
		undefine
			default_create, is_equal, copy
		end

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
			create template
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

	set_color (name: ASTRING; a_color: EL_COLOR)
		do
			color_table [name] := a_color.rgb_24_bit
		end

	set_variable (name: ASTRING; value: ANY)
		do
			variables [name] := value
		end

feature {EL_SVG_PIXMAP} -- Implementation

	rendering_variables: ARRAYED_LIST [like Type_rendering_variable]
		do
			Result := Precursor
			across color_table as color loop
				Result.extend ([Initial_c, color.item])
			end
		end

	svg_xml (a_svg_template_path: like svg_template_path): STRING
		local
			svg_lines: EL_FILE_LINE_SOURCE; line: ASTRING
		do
			Result := empty_once_string_8
			update_variables
			create svg_lines.make (svg_template_path)
			from svg_lines.start until svg_lines.after loop
				line := svg_lines.item
				if line.has ('$') then
					check_for_xlink_uri (a_svg_template_path, line)
					template.set_template (line)
					across variables as variable loop
						if template.has_variable (variable.key) then
							template.set_variable (variable.key, variable.item)
						end
					end
					line := template.substituted
				end
				Result.append (line.to_utf8)
				Result.append_character ('%N')
				svg_lines.forth
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

	check_for_xlink_uri (a_svg_path: EL_FILE_PATH; line: ASTRING)
		local
			variable_pos, forward_slash_pos: INTEGER; dir_uri: EL_DIR_URI_PATH
		do
			Var_file_dir_uri.prepend_character ('$')
			variable_pos := line.substring_index (Var_file_dir_uri, 1)
			forward_slash_pos := variable_pos + Var_file_dir_uri.count
			Var_file_dir_uri.remove_head (1)
			if variable_pos > 0 and then line.character_32_item (forward_slash_pos) = '/' then
				dir_uri := a_svg_path.parent
				set_variable (Var_file_dir_uri, dir_uri.to_string)
			end
		end

feature {NONE} -- Internal attributes

	color_table: HASH_TABLE [INTEGER, STRING]

	template: EL_SUBSTITUTION_TEMPLATE [ASTRING]

	variables: EL_ASTRING_HASH_TABLE [ANY]

feature {NONE} -- Constants

	Var_file_dir_uri: ASTRING
		once
			Result := "file_dir_uri"
		end

end
