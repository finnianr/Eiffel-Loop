note
	description: "Configurable slide-show generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-31 16:43:32 GMT (Tuesday 31st May 2022)"
	revision: "3"

class
	SLIDE_SHOW

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

	EL_RECTANGULAR

	EL_MODULE_COLOR; EL_MODULE_LOG; EL_MODULE_OS; EL_MODULE_GUI

	EL_SHARED_PROGRESS_LISTENER

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
			create drawing_area.make_with_size (width, height)
			drawing_area.set_color (Color.black)
			drawing_area.fill
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

feature -- Measurement

	digit_count: INTEGER

	font_height: INTEGER

	height: INTEGER

	jpeg_quality: NATURAL

	title_duration_ratio: INTEGER
		-- duration to display cover and titles relative to slides

	width: INTEGER

feature {SLIDE_GROUP} -- Factory

	new_group_list: EL_ARRAYED_LIST [SLIDE_GROUP]
		do
			if attached new_group_table as group_table then
				create Result.make (group_table.count)
				across group_table as table loop
					Result.extend (create {SLIDE_GROUP}.make (table.key, table.item, Current))
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

	group_name (file_path: FILE_PATH): ZSTRING
		local
			l_path: FILE_PATH
		do
			l_path := file_path.base
			l_path.remove_extension; l_path.remove_extension
			Result := l_path.base
		end

	save_next_jpeg
		do
			counter.bump
			drawing_area.save_as_jpeg (sequence_path, jpeg_quality)
			progress_listener.notify_tick
		end

	sequence_path: FILE_PATH
		do
			Result := output_dir + counter.zero_padded (digit_count)
			Result.add_extension (image_extension)
		end

feature {NONE} -- Internal attributes

	drawing_area: CAIRO_DRAWING_AREA

	directory_list: EL_ARRAYED_LIST [DIR_PATH]

	exclusion_list: EL_ARRAYED_LIST [ZSTRING]

	counter: EL_NATURAL_32_COUNTER
		-- image counter

feature {NONE} -- Constants

	Element_node_fields: STRING = "directory_list"

	Transient_fields: STRING = "dimensions, integer, group_list, pixmap, counter"

end