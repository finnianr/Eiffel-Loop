note
	description: "Configuration for slide-show"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-26 17:07:09 GMT (Thursday 26th May 2022)"
	revision: "1"

class
	SLIDE_SHOW_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			make, Transient_fields
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_MODULE_OS

	EL_MODULE_GUI

	EL_MODULE_COLOR

create
	make

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
			--
		do
			make_solitary
			create directory_list.make (20)
			create exclusion_list.make_empty
			title_duration_ratio := 2; width := 1920; height := 1080; digit_count := 3
			Precursor (a_file_path)
			-- make absolute paths
			directory_list.extend (output_dir)
			across directory_list as list loop
				if not list.item.is_absolute then
					list.item.set_parent (a_file_path.parent #+ list.item.parent)
				end
			end
			directory_list.remove_last
			group_list := new_group_list
			create dimensions.make_size (width, height)
			create integer.make (digit_count)
			integer.zero_fill
		end

feature -- Access

	cover_image: FILE_PATH

	group_list: like new_group_list

	image_extension: STRING

	output_dir: DIR_PATH

	title_font: STRING

	total_image_count: INTEGER
		do
			Result := title_duration_ratio
			across group_list as list loop
				Result := Result + list.item.image_count
			end
		end

	sequence_path: FILE_PATH
		do
			Result := output_dir + integer.formatted (sequence_number)
			Result.add_extension (image_extension)
		end

	new_area: CAIRO_DRAWING_AREA
		do
			create Result.make_with_size (width, height)
			Result.set_color (Color.black)
			Result.fill
		end

	new_theme_font: EV_FONT
		do
			create Result.make_with_values (Gui.Family_sans, Gui.Weight_bold, Gui.Shape_regular, font_height)
			Result.preferred_families.extend (title_font)
		end

	new_name_font: EV_FONT
		do
			create Result.make_with_values (Gui.Family_sans, Gui.Weight_regular, Gui.Shape_italic, font_height * 2 // 3)
			Result.preferred_families.extend (title_font)
		end

feature -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (4, 2)
		end

feature -- Measurement

	dimensions: EL_RECTANGLE

	digit_count: INTEGER

	height: INTEGER

	sequence_number: INTEGER

	title_duration_ratio: INTEGER
		-- duration to display cover and titles relative to slides

	width: INTEGER

	font_height: INTEGER

feature -- Element change

	bump_sequence
		do
			sequence_number := sequence_number + 1
		end

	reset_sequence
		do
			sequence_number := 0
		end

feature {NONE} -- Factory

	group_name (file_path: FILE_PATH): ZSTRING
		local
			dot_index, hyphen_index: INTEGER
		do
			dot_index := file_path.dot_index
			hyphen_index := file_path.base.last_index_of ('-', dot_index)
			if hyphen_index > 0 then
				Result := file_path.base.substring (1, hyphen_index - 1)
			else
				Result := file_path.base_sans_extension
			end
			Result.replace_character ('-', ' ')
			Result.to_proper_case
		end

	new_group_list: EL_ARRAYED_LIST [SLIDE_GROUP]
		local
			group_table: EL_FUNCTION_GROUP_TABLE [FILE_PATH, ZSTRING]
		do
			create Result.make (directory_list.count * 10)
			create group_table.make (agent group_name, directory_list.count * 3)
			across directory_list as list loop
				across OS.sorted_file_list (list.item, "*." + image_extension) as path loop
					if not across exclusion_list as excluded some path.item.base.starts_with (excluded.item) end then
						group_table.list_extend (path.item)
					end
				end
			end
			across group_table as table loop
				Result.extend (create {SLIDE_GROUP}.make (table.key, table.item, Current))
			end
		end

feature {NONE} -- Internal attributes

	directory_list: EL_ARRAYED_LIST [DIR_PATH]

	exclusion_list: EL_ARRAYED_LIST [ZSTRING]

	integer: FORMAT_INTEGER

feature {NONE} -- Constants

	Element_node_fields: STRING = "directory_list"

	Transient_fields: STRING = "dimensions, integer, group_list"

end