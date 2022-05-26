note
	description: "Group of numbered slides"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-26 17:03:57 GMT (Thursday 26th May 2022)"
	revision: "1"

class
	SLIDE_GROUP

inherit
	ANY

	EL_MODULE_LIO; EL_MODULE_COLOR; EL_MODULE_VISION_2; EL_MODULE_GUI

	EL_SHARED_PROGRESS_LISTENER

create
	make

feature {NONE} -- Initialization

	make (a_name: like name; a_file_list: like file_list; a_config: SLIDE_SHOW_CONFIG)
		do
			name := a_name; file_list := a_file_list; config := a_config
			theme_name := file_list.first.parent.base
		end

feature -- Access

	file_list: EL_ARRAYED_LIST [FILE_PATH]

	name: ZSTRING

	theme_name: ZSTRING

feature -- Measurement

	image_count: INTEGER
		do
			Result := config.title_duration_ratio + file_list.count
		end

feature -- Basic operations

	generate
		local
			pixmap: EL_PIXMAP; area: CAIRO_DRAWING_AREA
		do
			pixmap := title_pixmap

			area := config.new_area
			area.fill
			area.draw_centered_pixmap (pixmap)

			across 1 |..| config.title_duration_ratio as n loop
				-- Generate title image
				config.bump_sequence
				area.save_as_jpeg (config.sequence_path, 90)
				progress_listener.notify_tick
			end

			across file_list as list loop
				config.bump_sequence
				create pixmap
				pixmap.set_with_named_file (list.item)
				if list.is_first then
					print_info (pixmap.dimensions)
				end
				area.fill
				area.draw_centered_pixmap (pixmap)
				area.save_as_jpeg (config.sequence_path, 90)
				progress_listener.notify_tick
			end
		end

feature {NONE} -- Implementation

	print_info (rect: EL_RECTANGLE)
		local
			aspect: STRING
		do
			aspect := config.Double.formatted (rect.aspect_ratio)
			lio.put_labeled_substitution (name, "dimensions = %Sx%S; aspect ratio = %S", [rect.width, rect.height, aspect])
			lio.put_new_line
		end

	title_pixmap: EL_PIXMAP
		local
			rect: EL_RECTANGLE; height: INTEGER
		do
			rect := config.dimensions.twin
			Result := rect
			Result.set_background_color (Color.Black)
			Result.clear
			Result.set_foreground_color (Color.White)

			height := (rect.height / 5).rounded
			rect.set_height (height)
			across << theme_name, Name_template #$ [name] >> as title loop
				rect.move_by (0, rect.height)
				if title.is_first then
					Result.set_font (config.new_theme_font)
				else
					Result.set_font (config.new_name_font)
				end
				Result.draw_centered_text (title.item, rect)
			end
		end

feature {NONE} -- Internal attributes

	config: SLIDE_SHOW_CONFIG

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "~ %S ~"
		end

end