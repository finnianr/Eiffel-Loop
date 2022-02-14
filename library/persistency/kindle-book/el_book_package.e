note
	description: "Kindle book package serializeable as Open Packaging Format (OPF)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 12:23:39 GMT (Monday 14th February 2022)"
	revision: "6"

class
	EL_BOOK_PACKAGE

inherit
	EL_SERIALIZEABLE_BOOK_INDEXING
		redefine
			make, getter_function_table
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_book: like book)
		do
			Precursor (a_book)
			manifest_list := new_manifest_list
		end

feature {NONE} -- Implementation

	image_dir: DIR_PATH
		do
			Result := book.output_dir #+ "image"
		end

	spine_list: like manifest_list.query_if
		do
			Result := manifest_list.query_if (agent {EL_OPF_MANIFEST_ITEM}.is_html_type)
		end

feature {NONE} -- Factory

	new_file_name: ZSTRING
		do
			Result := "book-package.opf"
		end

	new_manifest_list: EL_OPF_MANIFEST_LIST
		do
			create Result.make (50)
			across create {EL_FILE_PATH_LIST}.make_from_tuple (path) as name loop
				Result.extend (name.item)
			end
			across book.chapter_list as chapter loop
				Result.extend (chapter.item.output_path.base)
			end
			across book.image_path_set.to_array as image_path loop
				Result.extend (image_path.item)
			end
		ensure then
			valid_manifest: Result.count >= 3
				and then Result.i_th (1).href_path ~ path.cover
				and then Result.i_th (2).href_path ~ path.ncx
				and then Result.i_th (3).href_path ~ path.book_toc
		end

feature {NONE} -- Internal attributes

	manifest_list: like new_manifest_list

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["manifest_list",	agent: ITERABLE [EL_OPF_MANIFEST_ITEM] do Result := manifest_list end] +
				["spine_list",	agent: ITERABLE [EL_OPF_MANIFEST_ITEM] do Result := spine_list end]
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
				
				<meta name="cover" content="item_1"/>
			</metadata>
			<manifest>
				#foreach $item in $manifest_list loop
				<item id="item_$item.id" media-type="$item.media_type" href="$item.href"/>
				#end
			</manifest>
			<spine toc="item_2">
				#foreach $item in $spine_list loop
				<itemref idref="item_$item.id"/>
				#end
			</spine>
			<guide>
				<reference type="toc" title="Table of Contents" href="book-toc.html"></reference>
				<reference type="text" title="Introduction" href="introduction.html"></reference>
			</guide>
		</package>
	]"

end