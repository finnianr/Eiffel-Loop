note
	description: "Summary description for {EL_COPY_FILE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-21 16:23:32 GMT (Thursday 21st March 2013)"
	revision: "2"

class
	EL_COPY_FILE_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	template: STRING =
		--
	"[
		#if $is_recursive then
			xcopy /I /E /Y "$source_path" "$destination_path\$source_last_step"
		#else
			copy "$source_path" "$destination_path"
		#end
	]"

end
