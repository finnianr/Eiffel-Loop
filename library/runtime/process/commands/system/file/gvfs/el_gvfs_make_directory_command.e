note
	description: "GVFS command to create a directory"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-25 11:52:25 GMT (Saturday 25th March 2023)"
	revision: "1"

class
	EL_GVFS_MAKE_DIRECTORY_COMMAND

inherit
	EL_GVFS_URI_COMMAND

create
	make

feature {NONE} -- Constants

	Template: STRING = "gvfs-mkdir $uri"
end