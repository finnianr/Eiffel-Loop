note
	description: "Unix copy command template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 15:32:59 GMT (Thursday 9th September 2021)"
	revision: "5"

deferred class
	EL_UNIX_CP_TEMPLATE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Template: STRING = "[
		cp
		#if $is_recursive then
			--recursive
		#end
		#if $timestamp_preserved_enabled then
			--preserve=timestamps
		#end
		#if $is_file_destination then
			--no-target-directory
		#end 
	 	$source_path $destination_path
	]"

end