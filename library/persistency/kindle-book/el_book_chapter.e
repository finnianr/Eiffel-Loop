note
	description: "Book chapter generated from Thunderbird email"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-03 10:21:40 GMT (Saturday 3rd November 2018)"
	revision: "5"

class
	EL_BOOK_CHAPTER

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			template as Html_template
		export
			{NONE} all
			{ANY} serialize, output_path
		end

	EL_THUNDERBIRD_CONSTANTS

	EL_MODULE_XML

	EL_MODULE_ZSTRING

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_title: ZSTRING; a_number: NATURAL; modification_date: DATE_TIME; a_text: EL_ZSTRING output_dir: EL_DIR_PATH)
		local
			h_tag: like XML.tag; base_name: ZSTRING
		do
			create image_list.make (5)
			create section_table.make_equal (5)
			title := a_title; number := a_number; text := a_text

			if number = 0 then
				base_name := title.as_lower + ".html"
			else
				title.prepend (Template.chapter_prefix #$ [number])
				base_name := Template.file_name #$ [number]
			end
			make_from_file (output_dir + base_name)

			if not a_text.has_substring ("<h1>") then
				a_text.prepend (Template.h1_line #$ [title])
			end

			if not output_path.exists or else modification_date > output_path.modification_date_time then
				is_modified := True
			end

			h_tag := XML.tag ("h2")
			text.edit (h_tag.open, h_tag.closed, agent edit_heading_2)
			text.edit (Src_attribute, character_string ('"'), agent on_src_attribute)
		end

feature -- Access

	number: NATURAL

	text: ZSTRING

	title: ZSTRING

	image_list: EL_ARRAYED_LIST [EL_FILE_PATH]

feature -- Status query

	is_modified: BOOLEAN

feature {NONE} -- Implementation

 	edit_heading_2 (start_index, end_index: INTEGER; substring: ZSTRING)
 		local
 			key, h2_text: ZSTRING
 		do
			key := Template.section_key #$ [number, section_table.count + 1]
			h2_text := substring.substring (start_index, end_index)
			on_heading_2 (key, h2_text)

			h2_text.prepend_character (' ')
			h2_text.prepend (key)
			substring.replace_substring (h2_text, start_index, end_index)
			section_table.extend (h2_text, key)

 			substring.insert_string (Anchor_template #$ [Section_prefix + key], 1)
 		end

 	on_heading_2 (section_key, h2_text: ZSTRING)
 		-- used for redefining href links within document to use template
 		-- "chapter-%S.html%%#sect_%S"
 		do
 		end

 	on_src_attribute (start_index, end_index: INTEGER; substring: ZSTRING)
 		local
 			image_path: EL_FILE_PATH
 		do
 			image_path := new_image_path (substring.substring (start_index, end_index))
			substring.replace_substring (image_path.to_string, start_index, end_index)
 			image_list.extend (image_path)
 		end

 	new_image_path (src_text: ZSTRING): ZSTRING
 		do
 			Result := src_text
 		end

feature {NONE} -- Evolicity fields

	get_navigation_class: ZSTRING
		do
			if number = 0 then
				Result := title.as_lower
			else
				Result := "chapter"
			end
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["file_name",			agent: ZSTRING do Result := output_path.base end],
				["navigation_class", agent get_navigation_class],
				["number",				agent: NATURAL_32_REF do Result := number.to_reference end],
				["section_table", 	agent: like section_table do Result := section_table end],
				["title",				agent: ZSTRING do Result := title end],
				["text",					agent: ZSTRING do Result := text end]
			>>)
		end

feature {NONE} -- Internal attributes

	section_table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		-- section id list

feature {NONE} -- Constants

	Template: TUPLE [file_name, chapter_prefix, h1_line, section_key: ZSTRING]
		once
			create Result
			Result.file_name := "chapter-%S.html"
			Result.chapter_prefix := "Chapter %S - "
			Result.h1_line := "    <h1>%S</h1>%N"
			Result.section_key := "%S.%S"
		end

	Src_attribute: ZSTRING
		once
			Result := "src=%""
		end

	Section_prefix: ZSTRING
		once
			Result := "sect_"
		end

	Html_template: ZSTRING
		once
			Result := "[
				<!DOCTYPE html>
				<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
				<head>
					<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
					<title>$title</title>
					<link rel="stylesheet" href="style.css" type="text/css"/>
				</head>
				<html>
				    <body>
				$text
				    </body>
				</html>
			]"
		end

end
