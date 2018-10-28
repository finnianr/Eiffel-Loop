note
	description: "Kindle book package serializeable as Open Packaging Format (OPF)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 17:21:52 GMT (Sunday 28th October 2018)"
	revision: "1"

class
	EL_BOOK_PACKAGE

inherit
	EL_SERIALIZEABLE_BOOK_INDEXING

create
	make

feature {NONE} -- Implementation

	new_file_name: ZSTRING
		do
			Result := "book-package.opf"
		end

feature {NONE} -- Constants

	Template: STRING = "[
		<?xml version="1.0" encoding="utf-8"?>
		<package xmlns="http://www.idpf.org/2007/opf" version="2.0" unique-identifier="$info.uuid">
			<metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
				<dc:title>$info.title</dc:title>
				<dc:language>$info.language</dc:language>
				<dc:creator>$info.creator</dc:creator>
				<dc:publisher>$info.publisher</dc:publisher>
				<dc:subject>$info.subject_heading</dc:subject>
				<dc:date>$info.publication_date</dc:date>
				<dc:description>$info.description</dc:description>
				
				<meta name="cover" content="cover-image" />
			</metadata>
			<manifest>
				<item id="cover-image" media-type="image/png" href="cover.png"/>
			</manifest>
		</package>
	]"

end
