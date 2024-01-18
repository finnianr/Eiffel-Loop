note
	description: "[
		Implements ${EL_SLIDE_SHOW} using [https://www.imagemagick.org ImageMagick] convert command
		to fit images into specified geometry and generate title pages.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_IMAGE_MAGICK_SLIDE_SHOW

inherit
	EL_SLIDE_SHOW
		rename
			generate as execute
		export
			{EL_COMMAND_CLIENT} make
		end

	EL_APPLICATION_COMMAND
		undefine
			is_equal
		end

create
	make

feature -- Constants

	Description: STRING = "Generate slides for video"

feature -- Basic operations

	print_info (a_slide: like new_slide; name: ZSTRING)
		do
			lio.put_labeled_string ("Theme", name)
			lio.put_new_line
		end

feature -- Element change

	extend (a_slide: like new_slide)
		do
			a_slide.put_path (Slide.output_path, sequence_path)
			a_slide.execute
		end

feature {NONE} -- Factory

	new_slide (file_path: FILE_PATH): EL_OS_COMMAND
		do
			Result := Slide_command
			Result.put_path (Slide.source_path, file_path)
			Result.put_string (Slide.size, size_dimensions)
		end

	new_title_slide (a_title, sub_title: ZSTRING): like new_slide
		do
			Result := Title_command
			Result.put_string (Title.size, size_dimensions)
			Result.put_string (Title.italic_font, title_font + "-Italic")
			Result.put_integer (Title.italic_height, (font_height * 8 / 10).rounded)
			Result.put_string (Title.sub_title, sub_title)
			Result.put_string (Title.font, title_font)
			Result.put_integer (Title.font_height, font_height)
			Result.put_integer (Title.line_separation, (font_height * 1.2).rounded)
			Result.put_string (Title.title, a_title)
		end

feature {NONE} -- Implementation

	size_dimensions: STRING
		do
			Result := width.out + "x" + height.out
		end

feature {NONE} -- Constants

	Slide_command: EL_OS_COMMAND
		once
			create Result.make_with_name ("create_slide", "[
				convert $source_path -resize $size -background black -gravity center -extent $size $output_path
			]")
			Result.fill_variables (Slide)
		end

	Title_command: EL_OS_COMMAND
		once
			create Result.make_with_name ("create_title", "[
				convert -background black -fill white -size $size
				 	-font $italic_font -pointsize $italic_height -gravity Center caption:'$sub_title'
					-font $font -pointsize $font_height -annotate +0-$line_separation '$title'
					$output_path
			]")
			Result.fill_variables (Title)
		end

	Geometry_command: EL_OS_COMMAND
		once
			create Result.make ("identify $title_path")
		end

	Title: TUPLE [size, italic_font, italic_height, sub_title, font, font_height, line_separation, title, output_path: STRING]
		once
			create Result
		end

	Slide: TUPLE [source_path, size, output_path: STRING]
		once
			create Result
		end

end