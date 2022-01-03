note
	description: "List of manifest items in OPF package"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	EL_OPF_MANIFEST_LIST

inherit
	EL_ARRAYED_LIST [EL_OPF_MANIFEST_ITEM]
		rename
			extend as extend_list
		end

create
	make

feature -- Element change

	extend (a_path: FILE_PATH)
		do
			extend_list (create {EL_OPF_MANIFEST_ITEM}.make (a_path, count + 1))
		end
end
