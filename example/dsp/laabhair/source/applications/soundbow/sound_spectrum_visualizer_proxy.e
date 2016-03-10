indexing
	description: "[
		RPC proxy to the Flash sound spectrum visualizer object
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	SOUND_SPECTRUM_VISUALIZER_PROXY

inherit
	EL_FLASH_OBJECT_PROXY
	
create
	make

feature -- Basic operations

	ping_microtone_colors (tone_index_and_color_intensity_array: ARRAY [ARRAY [NUMERIC]]) is
			-- Send XML message to call Flash procedure with arguments:

			-- 		sound_visualizer.ping_microtone_colors (tone_index_and_color_intensity_array)

			--		 <flash-procedure-call>
			--				<object-name>sound_visualizer</object-name>
			--				<procedure-name>ping_microtone_colors</procedure-name>
			--				<arguments>
			--					<Array>
			--						<Array>
			--							<Number>$tone_index</Number>
			--							<Number>$color_intensity</Number>
			--						</Array>
			--						<Array>
			--							<Number>$tone_index</Number>
			--							<Number>$color_intensity</Number>
			--						</Array>
			--						..
			--					</Array>
			--				</arguments>
			--		 </flash-procedure-call>
				 			
		do
			prepare_call ("ping_microtone_colors")
			put_numeric_rows_and_cols_arg (tone_index_and_color_intensity_array)
			request_call
		end

feature {NONE} -- Implementation
		
	object_name: STRING is "sound_visualizer"

end


