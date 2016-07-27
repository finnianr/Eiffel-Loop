note
	description: "Summary description for {EL_COPY_FILE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-16 13:29:50 GMT (Thursday 16th June 2016)"
	revision: "4"

class
	EL_COPY_FILE_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	Template: STRING = "[
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