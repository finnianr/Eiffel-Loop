note
	description: "Configurable slide-show generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-02 16:34:48 GMT (Thursday 2nd June 2022)"
	revision: "4"

class
	EL_SLIDE_SHOW

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			make, Transient_fields, Root_node_name
		end

	EL_MODULE_LIO; EL_MODULE_OS

	EL_SHARED_PROGRESS_LISTENER

create
	make

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
			--
		do
			create directory_list.make (20)
			create exclusion_list.make_empty
			title_duration_ratio := 2; width := 1920; height := 1080; digit_count := 3
			jpeg_quality := 90
			create counter

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

feature -- Measurement

	digit_count: INTEGER

	font_height: INTEGER

	height: INTEGER

	jpeg_quality: NATURAL

	title_duration_ratio: INTEGER
		-- duration to display cover and titles relative to slides

	width: INTEGER

feature {EL_SLIDE_GROUP} -- Factory

	new_group (name: ZSTRING; file_list: EL_ARRAYED_LIST [FILE_PATH]): EL_SLIDE_GROUP
		do
			create Result.make (name, file_list, Current)
		end

	new_group_list: EL_ARRAYED_LIST [like new_group]

		do
			if attached new_group_table as group_table then
				create Result.make (group_table.count)
				across group_table as table loop
					Result.extend (new_group (table.key, table.item))
				end
			end
		end

	new_group_table: EL_FUNCTION_GROUP_TABLE [FILE_PATH, ZSTRING]
		do
			create Result.make (agent group_name, directory_list.count * 3)
			across directory_list as list loop
				across OS.sorted_file_list (list.item, "*." + image_extension) as path loop
					if not across exclusion_list as excluded some path.item.base.starts_with (excluded.item) end then
						Result.list_extend (path.item)
					end
				end
			end
		end

feature {NONE} -- Implementation

	group_name (file_path: FILE_PATH): ZSTRING
		local
			l_path: FILE_PATH
		do
			l_path := file_path.base
			l_path.remove_extension; l_path.remove_extension
			Result := l_path.base
		end

	sequence_path: FILE_PATH
		do
			Result := output_dir + counter.zero_padded (digit_count)
			Result.add_extension (image_extension)
		end

feature {NONE} -- Internal attributes

	directory_list: EL_ARRAYED_LIST [DIR_PATH]

	exclusion_list: EL_ARRAYED_LIST [ZSTRING]

	counter: EL_NATURAL_32_COUNTER
		-- image counter

feature {NONE} -- Constants

	Element_node_fields: STRING = "directory_list"

	Root_node_name: STRING = "slide_show"

	Transient_fields: STRING = "dimensions, integer, group_list, pixmap, counter"

end