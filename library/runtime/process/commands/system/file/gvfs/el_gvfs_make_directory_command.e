note
	description: "GVFS command to create a directory"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 9:14:24 GMT (Tuesday 9th July 2024)"
	revision: "2"

class
	EL_GVFS_MAKE_DIRECTORY_COMMAND

inherit
	EL_GVFS_URI_COMMAND

create
	make

feature {NONE} -- Constants

	Default_template: STRING = "gvfs-mkdir $uri"
end