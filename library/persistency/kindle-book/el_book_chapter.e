note
	description: "Book chapter generated from Thunderbird email"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-26 9:40:01 GMT (Friday 26th October 2018)"
	revision: "3"

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

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_title: ZSTRING; a_number: NATURAL; modification_date: DATE_TIME; a_text: EL_ZSTRING output_dir: EL_DIR_PATH)
		local
			h_tag: like XML.tag; base_name: ZSTRING
		do
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
		end

feature -- Access

	number: NATURAL

	text: ZSTRING

	title: ZSTRING

feature -- Status query

	is_modified: BOOLEAN

feature {NONE} -- Implementation

 	edit_heading_2 (start_index, end_index: INTEGER; substring: ZSTRING)
 		local
 			key, h2_text: ZSTRING
 		do
			key := Template.section_key #$ [number, section_table.count + 1]
			h2_text := substring.substring (start_index, end_index)
			h2_text.prepend_character (' ')
			h2_text.prepend (key)
			substring.replace_substring (h2_text, start_index, end_index)
			section_table.extend (h2_text, key)

 			substring.insert_string (Anchor_template #$ [Section_prefix + key], 1)
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
				</head>
				<html>
				    <body>
				$text
				    </body>
				</html>
			]"
		end

end