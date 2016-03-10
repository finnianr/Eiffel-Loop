note
	description: "Summary description for {EL_WAV_TO_MP3_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-08 11:41:03 GMT (Friday 8th November 2013)"
	revision: "3"

class
	EL_WAV_TO_MP3_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	Template: STRING
		once
			Result := "[
				lame --id3v2-only --tt "Title" --silent -h -b $bit_rate -m $mode "$input_file_path" "$output_file_path"
			]"
		end
		-- usage: lame [options] <infile> [outfile]
		--
		--   <infile> and/or <outfile> can be "-", which means stdin/stdout.

		-- OPTIONS:
		--    -b bitrate      set the bitrate, default 128 kbps
		--    -f              fast num_channels (lower quality)
		--    -h              higher quality, but a little slower.  Recommended.
		--    -m num_channels         (s)tereo, (j)oint, (m)ono
		--                    default is (j) or (s) depending on bitrate
		--    -V n            quality setting for VBR.  default n=4
		--
		--    --preset type   type must be "medium", "standard", "extreme", "insane",
		--                    or a value for an average desired bitrate and depending
		--                    on the value specified, appropriate quality settings will
		--                    be used.
		--                    "--preset help" gives more info on these
		--
		--    --priority type  sets the process priority
		--                     0,1 = Low priority
		--                     2   = normal priority
		--                     3,4 = High priority
		--
		--    --longhelp      full list of options
		--	  --brief  		  print more useful information

end
