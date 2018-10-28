note
	description: "Book html contents table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 17:21:52 GMT (Sunday 28th October 2018)"
	revision: "2"

class
	EL_BOOK_HTML_CONTENTS_TABLE

inherit
	EL_SERIALIZEABLE_BOOK_INDEXING

create
	make

feature {NONE} -- Implementation

	new_file_name: ZSTRING
		do
			Result := "book-toc.html"
		end

feature {NONE} -- Constants

	Template: STRING = "[
		<!DOCTYPE html>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>$info.title</title>
				<meta author="$info.author"/>
				<style>
					ol {
						list-style-type: none;
					}
				</style>
			</head>
			<body>
				<h1 id="toc">Table of Contents</h1>
				<ol>
				#foreach $chapter in $chapter_list loop
					<li><a href="$chapter.file_name">$chapter.title</a></li>
					#if not $chapter.section_table.is_empty then
					<ol>
						#across $chapter.section_table as $section loop
						<li><a href="$chapter.file_name#sect_$section.key">$section.item</a></li>
						#end
					</ol>
					#end
				#end
				</ol>
			</body>
		</html>
	]"
end
