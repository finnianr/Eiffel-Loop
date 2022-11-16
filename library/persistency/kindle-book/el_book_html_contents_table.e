note
	description: "Book html contents table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_BOOK_HTML_CONTENTS_TABLE

inherit
	EL_SERIALIZEABLE_BOOK_INDEXING

create
	make

feature {NONE} -- Implementation

	new_file_name: ZSTRING
		do
			Result := path.book_toc
		end

feature {NONE} -- Constants

	Template: STRING = "[
		<!DOCTYPE html>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>$info.title</title>
				<meta author="$info.author"/>
				<link rel="stylesheet" href="style/toc.css" type="text/css"/>
			</head>
			<body>
				<h1 id="toc">Table of Contents</h1>
				<ol>
				#foreach $chapter in $chapter_list loop
					<li><a href="$chapter.file_name">$chapter.title</a></li>
					#if not $chapter.section_table.is_empty then
					<ol class="section">
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