note
	description: "Object to create book NCX (navigation control file)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 17:21:52 GMT (Sunday 28th October 2018)"
	revision: "2"

class
	EL_BOOK_NAVIGATION_CONTROL_FILE

inherit
	EL_SERIALIZEABLE_BOOK_INDEXING
		redefine
			make_default, getter_function_table
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create next_number
		end

feature {NONE} -- Implementation

	new_file_name: ZSTRING
		do
			Result := "book-navigation.ncx"
		end

feature {NONE} -- Internal attributes

	next_number: INTEGER_REF

feature {NONE} -- Evolicity

	get_next_number: INTEGER_REF
		do
			next_number.set_item (next_number.item + 1)
			Result := next_number
		end

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor + ["next_number", agent get_next_number]
		end

feature {NONE} -- Constants

	Template: STRING = "[
		<?xml version="1.0" encoding="UTF-8"?>
		<!DOCTYPE ncx PUBLIC "-//NISO//DTD ncx 2005-1//EN" "http://www.daisy.org/z3986/2005/ncx-2005-1.dtd">
		
		<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1" xml:lang="$info.language">
			<head>
				<meta name="dtb:uid" content="$info.uuid"/>
				<meta name="dtb:depth" content="2"/>
				<meta name="dtb:totalPageCount" content="0"/>
				<meta name="dtb:maxPageNumber" content="0"/>
			</head>
			<docTitle><text>$info.title</text></docTitle>
			<docAuthor><text>$info.author</text></docAuthor>
			
			<navMap>
				<navPoint class="toc" id="toc" playOrder="$next_number">
					<navLabel>
						<text>Table of Contents</text>
					</navLabel>
					<content src="book-toc.html"/>
				</navPoint>
			#foreach $chapter in $chapter_list loop
				<navPoint class="$chapter.navigation_class" id="ch_$chapter.number" playOrder="$next_number">
					<navLabel>
						<text>$chapter.title</text>
					</navLabel>
					<content src="$chapter.file_name"/>
				#if not $chapter.section_table.is_empty then
					#across $chapter.section_table as $section loop
					<navPoint class="section" id="sect_$section.key" playOrder="$next_number">
						<navLabel>
						 <text>$section.item</text>
						</navLabel>
						<content src="$chapter.file_name#sect_$section.key"/>
					</navPoint>
					#end
				#end
				</navPoint>
			#end
			</navMap>
		</ncx>
	]"

end
