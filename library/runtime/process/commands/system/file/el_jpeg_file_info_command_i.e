note
	description: "Command to parse JPEG metadata fields from output of **exiv2** command"
	tests: "Class [$source JPEG_FILE_INFO_COMMAND_TEST_SET]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-11 17:01:55 GMT (Thursday 11th May 2023)"
	revision: "12"

deferred class
	EL_JPEG_FILE_INFO_COMMAND_I

inherit
	EL_FILE_PATH_OPERAND_COMMAND_I
		rename
			eiffel_naming as camel_case_naming
		export
			{NONE} all
		undefine
			do_command, new_command_parts
		redefine
			camel_case_naming, new_representations, reset, set_file_path, set_has_error
		end

	EL_CAPTURED_OS_COMMAND_I
		rename
			eiffel_naming as camel_case_naming
		undefine
			camel_case_naming, getter_function_table, new_representations, reset, set_has_error,
			Transient_fields
		end

	EL_SETTABLE_FROM_ZSTRING

	EL_MODULE_FILE; EL_MODULE_TUPLE

feature -- Exiv2 fields

	device_make: STRING

	model: STRING

	orientation: STRING

	resolution_unit: STRING

	software: STRING

feature -- Exiv2 measurements

	date_time: INTEGER

	date_time_original: INTEGER

	image_height: INTEGER
		do
			Result := image_length
		end

	image_width: INTEGER

	image_length: INTEGER

	pixel_x_dimension: INTEGER

	pixel_y_dimension: INTEGER

	x_resolution: INTEGER

	y_resolution: INTEGER

feature -- Status query

	has_date_time: BOOLEAN
		do
			Result := date_time.to_boolean
		end

	has_meta_data: BOOLEAN

feature -- Factory

	new_date_time: EL_DATE_TIME
		do
			create Result.make_from_epoch (date_time)
		end

feature -- Element change

	set_file_path (a_file_path: like file_path)
			--
		do
			Precursor (a_file_path)
			execute
		end

feature {NONE} -- Implementation

	camel_case_naming: EL_NAME_TRANSLATER
		do
			Result := camel_case_translater ({EL_CASE}.lower)
		end

	do_with_lines (line_list: like new_output_lines)
			--
		local
			line, value, field_name, qualifier: ZSTRING
			found: BOOLEAN; value_column, count: INTEGER
		do
			across line_list as list loop
				line := list.item
				if line.starts_with (Name.exif) then
					line.remove_head (Name.exif.count + 1)
					value_column := 56; found := False
					across Name_part_list as part until found loop
						qualifier := part.item
						if line.starts_with (qualifier) then
							if qualifier = Name.thumbnail then
								line.remove (qualifier.count + 1) -- Remove dot
								value_column := value_column - 1
							else
								line.remove_head (qualifier.count + 1)
								value_column := value_column - qualifier.count - 1
							end
							field_name := line.substring_to (' ', default_pointer)
							if field_name ~ Name.make then
								field_name.prepend_ascii ("Device")
							end
							if field_table.has_imported (field_name) then
								value := line.substring_end (value_column)
								value.right_adjust
								field_table.found_item.set_from_string (Current, value)

--								Nokio 300 phone may have bad Exif.Photo.MakerNote that causes infinite loop in UTF-8 parsing
--								Forcing `Mixed_utf_8_latin_1' encoding causes UTF-8 validity check, defaulting to Latin-1 string
								if field_name ~ Name.model and then is_bad_make_model then
									line_list.set_encoding (Mixed_utf_8_latin_1)
								end
							end
							found := True
						end
					end
					count := count + 1
				end
			end
			has_meta_data := count.to_boolean
			if date_time = 0 then
				date_time := date_time_original
			end
			if image_width = 0 then
				image_width := pixel_x_dimension
			end
			if image_length = 0 then
				image_length := pixel_y_dimension
			end
		end

	is_bad_make_model: BOOLEAN
		do
			Result := Nokia_300.make ~ device_make and then Nokia_300.model ~ model
		end

	reset
		do
			has_meta_data := False

			date_time := 0; date_time_original := 0
			image_width := 0; image_length := 0
			x_resolution := 0; y_resolution := 0
			pixel_x_dimension := 0; pixel_y_dimension := 0

			create device_make.make_empty
			create model.make_empty
			create orientation.make_empty
			create resolution_unit.make_empty
			create software.make_empty
		end

	set_has_error (return_code: INTEGER)
		-- exiv2 has a non-standard way of indicating an error
		do
			has_error := File.byte_count (temporary_error_file_path) > 0
		end

feature {NONE} -- Reflection hints

	new_representations: like Default_representations
		do
			create Result.make (<<
				["date_time", Date_representation],
				["date_time_original", Date_representation]
			>>)
		end

feature {NONE} -- Constants

	Date_representation: EL_DATE_TIME_REPRESENTATION
		once
			create Result.make ("yyyy:[0]mm:[0]dd [0]hh:[0]mi:[0]ss")
		end

	Name: TUPLE [exif, date_time_original, image, make, model, photo, thumbnail: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "Exif, DateTimeOriginal, Image, Make, Model, Photo, Thumbnail")
		end

	Nokia_300: TUPLE [make, model: STRING]
		once
			create Result
			Tuple.fill (Result, "Nokia, 300")
		end

	Name_part_list: EL_ZSTRING_LIST
		once
			create Result.make_from_tuple (Name)
		end

note
	notes: "[
		Exiv2 Data Example

			Exif.Image.ImageWidth                        Long        1  3264
			Exif.Image.ImageLength                       Long        1  2448
			Exif.Image.Make                              Ascii       8  samsung
			Exif.Photo.DateTimeOriginal                  Ascii      20  2023:01:14 14:44:57
			Exif.Thumbnail.ImageWidth                    Long        1  512
			Exif.Thumbnail.ImageLength                   Long        1  384
	]"

end