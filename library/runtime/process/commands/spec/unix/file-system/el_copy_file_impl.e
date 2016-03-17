note
	description: "Summary description for {EL_COPY_FILE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-15 12:17:25 GMT (Tuesday 15th September 2015)"
	revision: "4"

class
	EL_COPY_FILE_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	template: STRING = "[
		cp
		#if $is_recursive then
			--recursive
		#end
		#if $is_timestamp_preserved then
			--preserve=timestamps
		#end
		#if $is_destination_a_normal_file then
			--no-target-directory
		#end 
	 	$source_path $destination_path
	]"

end
