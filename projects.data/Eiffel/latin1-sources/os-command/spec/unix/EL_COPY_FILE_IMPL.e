indexing
	description: "Summary description for {EL_COPY_FILE_IMPL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_COPY_FILE_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	template: STRING is
		--
	"[
		cp
		
		#if $is_timestamp_preserved then
			--preserve=timestamps
		#end
		
		#if $is_destination_a_normal_file then
			--no-target-directory
		#end 
	
	 	"$source_path" "$destination_path"
	]"

end

