note
	description: "XDG desktop directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-13 16:58:24 GMT (Sunday 13th March 2022)"
	revision: "9"

class
	EL_XDG_DESKTOP_DIRECTORY

inherit
	EL_XDG_DESKTOP_MENU_ITEM

create
	make

feature {NONE} -- Evolicity reflection

	Template: STRING = "[
		[Desktop Entry]
		Encoding=UTF-8
		Type=Directory
		#across $locale_table as $table loop
			#if $table.key = $en then
		Name=$table.item.name
			#else
		Name[$table.key]=$table.item.name
			#end
		#end
		Type=Application
		#across $locale_table as $table loop
			#if $table.key = $en then
		Comment=$table.item.comment
			#else
		Comment[$table.key]=$table.item.comment
			#end
		#end
		Icon=$icon_path
	]"

feature {NONE} -- Constants

	File_name_extension: STRING = "directory"

end