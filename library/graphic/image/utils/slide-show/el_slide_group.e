note
	description: "Group of slides belonging to same theme folder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-02 15:23:49 GMT (Thursday 2nd June 2022)"
	revision: "4"

class
	EL_SLIDE_GROUP

inherit
	ANY

	EL_MODULE_LIO

	EL_SHARED_PROGRESS_LISTENER

create
	make

feature {NONE} -- Initialization

	make (a_name: like name; a_file_list: like file_list; a_parent: like parent)
		do
			name := a_name; file_list := a_file_list; parent := a_parent
			theme_name := file_list.first.parent.base
		end

feature -- Access

	file_list: EL_ARRAYED_LIST [FILE_PATH]

	name: ZSTRING

	theme_name: ZSTRING

feature -- Measurement

	image_count: INTEGER
		do
			Result := parent.title_duration_ratio + file_list.count
		end

feature -- Basic operations

feature {NONE} -- Internal attributes

	parent: EL_SLIDE_SHOW

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "~ %S ~"
		end

end