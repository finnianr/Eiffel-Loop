note
	description: "GVFS command taking a single uri argument"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-25 10:21:52 GMT (Saturday 25th March 2023)"
	revision: "8"

deferred class
	EL_GVFS_URI_COMMAND

inherit
	EL_GVFS_OS_COMMAND [TUPLE [uri: STRING]]

feature -- Element change

	set_uri (uri: EL_URI)
		do
			put_uri (Var.uri, uri)
		end
end