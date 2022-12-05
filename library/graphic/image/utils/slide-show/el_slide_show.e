note
	description: "Abstract slide-show generated from Pyxis configuration"
	notes: "See end of class"
	descendants: "[
			EL_SLIDE_SHOW*
				[$source EL_IMAGE_MAGICK_SLIDE_SHOW]
				[$source SLIDE_SHOW]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 15:29:27 GMT (Monday 5th December 2022)"
	revision: "9"

deferred class
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

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
			--
		do
			config_name := a_file_path.base
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
			group_table := new_group_table
			create generation_done.make
		end

feature -- Pyxis Configured

	cover_image: FILE_PATH

	digit_count: INTEGER

	directory_list: EL_ARRAYED_LIST [DIR_PATH]

	exclusion_list: EL_ARRAYED_LIST [ZSTRING]

	font_height: INTEGER

	height: INTEGER

	image_extension: STRING

	jpeg_quality: NATURAL

	output_dir: DIR_PATH

	title_duration_ratio: INTEGER
		-- duration to display cover and titles relative to slides

	title_font: STRING

	width: INTEGER

feature -- Access

	aspect_ratio_formatted: ZSTRING
		do
			create Result.make (5)
			Result.append_rounded_double (width / height, 2)
		end

	config_name: ZSTRING

	count: INTEGER
		-- total number of slides
		do
			Result := title_duration_ratio
			across group_table as table loop
				Result := Result + title_duration_ratio + table.item.count
			end
		end

	generation_done: EL_EVENT_BROADCASTER
		-- generation done event broadcaster

feature -- Basic operations

	generate
		do
			OS.File_system.make_directory (output_dir)

			counter.reset
			lio.put_labeled_substitution (
				config_name, "size = %Sx%S; aspect ratio = %S; format = %S", [width, height, aspect_ratio_formatted, image_extension]
			)
			lio.put_new_line
			lio.put_labeled_substitution ("Generating", "%S slides", [count])
			lio.put_new_line

			across 1 |..| title_duration_ratio as n loop
				if attached new_slide (cover_image) as slide then
					counter.bump
					extend (slide)
				end
			end
			across group_table as table loop
				if table.item.count > 0 then
					generate_group (table.item.first.parent.base, table.key, table.item)
				end
			end
			generation_done.notify
			lio.put_line ("DONE")
		end

	print_info (slide: like new_slide; name: ZSTRING)
		deferred
		end

feature -- Element change

	extend (slide: like new_slide)
		deferred
		end

feature {NONE} -- Factory

	new_group_table: EL_FUNCTION_GROUP_TABLE [FILE_PATH, ZSTRING]
		do
			create Result.make (agent group_name, directory_list.count * 3)
			across directory_list as list loop
				across OS.sorted_file_list (list.item, "*." + image_extension) as path loop
					if not across exclusion_list as excluded some path.item.base.starts_with_zstring (excluded.item) end then
						Result.list_extend (path.item)
					end
				end
			end
		end

	new_slide (file_path: FILE_PATH): ANY
		deferred
		end

	new_title_slide (title, sub_title: ZSTRING): like new_slide
		deferred
		end

feature {NONE} -- Implementation

	generate_group (theme_name, name: ZSTRING; file_list: LIST [FILE_PATH])
		do
			if attached new_title_slide (theme_name, Sub_title_template #$ [name]) as title then
				across 1 |..| title_duration_ratio as n loop
					counter.bump
					extend (title)
				end
			end
			across file_list as list loop
				if attached new_slide (list.item) as slide then
					if list.is_first then
						print_info (slide, name)
					end
					counter.bump
					lio.put_natural_field ("Slide no.", counter.item)
					lio.put_new_line
					extend (slide)
				end
			end
		end

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

	counter: EL_NATURAL_32_COUNTER
		-- image counter

	group_table: like new_group_table

feature {NONE} -- Constants

	Element_node_fields: STRING = "directory_list"

	Root_node_name: STRING = "slide_show"

	Sub_title_template: ZSTRING
		once
			Result := "~ %S ~"
		end

	Transient_fields: STRING = "config_name, dimensions, integer, group_list, pixmap, counter"

note
	notes: "[
		Configuration Example

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			# Configuration file for SLIDE_SHOW_APP

			slide_show:
				output_dir = "Slides"; cover_image = "Matryoshka-Cover.jpeg"
				image_extension = jpeg; jpeg_quality = 90
				title_duration_ratio = 2; title_font = "Ubuntu-Medium"; font_height = 100
				width = 1920; height = 1080; digit_count = 3

				directory_list:
					item:
						"Artifacts"
						"Matryoshka Dolls"

				exclusion_list:
					item:
						"cathedral"
	]"

end