indexing
	description: "[
		RPC proxy to the Flash application root object: _root
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	FLASH_ROOT_PROXY

inherit
	EL_FLASH_OBJECT_PROXY
	
create
	make

feature -- Basic operations

	create_sound_visualizer (base_frequency, num_octaves, num_microtones_per_color_transition: INTEGER) is
			-- Creates the sound visulizer in Flash

			-- 		_root.create_sound_visualizer (num_octaves, num_microtones_per_color_transition)

			--		 <flash-procedure-call>
			--				<object-name>sound_visualizer</object-name>
			--				<procedure-name>ping_microtone_colors</procedure-name>
			--				<arguments>
			--					<Number>$base_frequency</Number>
			--					<Number>$num_octaves</Number>
			--					<Number>$num_microtones_per_color_transition</Number>
			--				</arguments>
			--		 </flash-procedure-call>
		do
			prepare_call ("create_sound_visualizer")
			put_integer_arg (base_frequency)
			put_integer_arg (num_octaves)
			put_integer_arg (num_microtones_per_color_transition)
			request_call
		end

feature {NONE} --

	object_name: STRING is "_root"

end

