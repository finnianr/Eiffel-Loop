note
	description: "[
	 
	 lame command
		 usage: lame [options] <infile> [outfile]
		
		   <infile> and/or <outfile> can be "-", which means stdin/stdout.

		 OPTIONS:
		    -b bitrate      set the bitrate, default 128 kbps
		    -f              fast num_channels (lower quality)
		    -h              higher quality, but a little slower.  Recommended.
		    -m num_channels         (s)tereo, (j)oint, (m)ono
		                    default is (j) or (s) depending on bitrate
		    -V n            quality setting for VBR.  default n=4
		
		    --preset type   type must be "medium", "standard", "extreme", "insane",
		                    or a value for an average desired bitrate and depending
		                    on the value specified, appropriate quality settings will
		                    be used.
		                    "--preset help" gives more info on these
		
		    --priority type  sets the process priority
		                     0,1 = Low priority
		                     2   = normal priority
		                     3,4 = High priority
		
		    --longhelp      full list of options
			  --brief  		  print more useful information
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_WAV_TO_MP3_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	Program_path: EL_FILE_PATH
		once
			Result := Environment.Execution.command_path_abs ("lame")
		end

feature -- Basic operations

--		lame -h -b $bit_rate -m $mode --silent
--		--id3v2-only --tt "$title" --ta "$artist" --tl "$album" --tg "$genre" --ty $year --tc "$comment"
--		"$input_file_path" "$output_file_path"

	set_arguments (command: EL_WAV_TO_MP3_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			arguments.add_option ("h")
			arguments.add_option_argument ("b", command.bit_rate.out)
			arguments.add_option_argument ("m", command.mode)

			arguments.set_command_option_prefix ("--")
			arguments.add_option ("silent")
			arguments.add_option ("id3v2-only")

			arguments.add_option_argument ("tt", command.title)
			arguments.add_option_argument ("ta", command.artist)
			arguments.add_option_argument ("tl", command.album)
			arguments.add_option_argument ("tg", command.genre)
			arguments.add_option_argument ("ty", command.year.out)
			arguments.add_option_argument ("tc", command.comment)

			arguments.add_path (command.input_file_path)
			arguments.add_path (command.output_file_path)

		end
end
