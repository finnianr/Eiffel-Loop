note
	description: "List of manifest items in OPF package"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-06 13:44:52 GMT (Tuesday 6th November 2018)"
	revision: "1"

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

	extend (a_path: EL_FILE_PATH)
		do
			extend_list (create {EL_OPF_MANIFEST_ITEM}.make (a_path, count + 1))
		end
end
