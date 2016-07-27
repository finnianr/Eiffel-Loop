note
	description: "Summary description for {EL_COPY_FILE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-17 10:08:35 GMT (Tuesday 17th May 2016)"
	revision: "4"

class
	EL_COPY_FILE_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	template: STRING =
		--
	"[
		#if $is_recursive then
			xcopy /I /E /Y $source_path $xcopy_destination_path
		#else
			copy $source_path $destination_path
		#end
	]"

end