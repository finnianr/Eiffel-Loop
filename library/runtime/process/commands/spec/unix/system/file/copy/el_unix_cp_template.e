note
	description: "Unix copy command template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-20 7:53:01 GMT (Monday 20th June 2016)"
	revision: "5"

deferred class
	EL_UNIX_CP_TEMPLATE

feature {NONE} -- Constants

	Template: STRING = "[
		cp
		#if $is_recursive then
			--recursive
		#end
		#if $is_timestamp_preserved then
			--preserve=timestamps
		#end
		#if $is_file_destination then
			--no-target-directory
		#end 
	 	$source_path $destination_path
	]"

end