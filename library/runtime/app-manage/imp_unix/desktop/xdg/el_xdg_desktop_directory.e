note
	description: "XDG desktop directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-23 10:21:55 GMT (Saturday 23rd November 2019)"
	revision: "8"

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
		#across $localized_names as $name loop
			#if $name.key = $en then
		Name=$name.item
			#else
		Name[$name.key]=$name.item
			#end
		#end
		Type=Application
		#across $localized_comments as $comment loop
			#if $comment.key = $en then
		Comment=$comment.item
			#else
		Comment[$comment.key]=$comment.item
			#end
		#end
		Icon=$icon_path
	]"

feature {NONE} -- Constants

	File_name_extension: STRING = "directory"

end
