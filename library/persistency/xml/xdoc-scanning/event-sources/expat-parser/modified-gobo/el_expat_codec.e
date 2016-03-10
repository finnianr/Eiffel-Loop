note
	description: "[
		typedef struct {
		  int map[256];
		  void *data;
		  int (*convert)(void *data, const char *s);
		  void (*release)(void *data);
		} XML_Encoding;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-03 8:10:30 GMT (Friday 3rd July 2015)"
	revision: "5"

deferred class
	EL_EXPAT_CODEC

inherit
	EL_C_CALLABLE
		rename
			make as make_callable
		redefine
			set_gc_protected_callbacks_target
		end

	EL_EXPAT_API
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make (encoding_info_struct_ptr: POINTER)
		do
			make_callable
			create encoding_info.share_from_pointer (encoding_info_struct_ptr, exml_XML_encoding_size)
			fill_encoding_info_map
			protect_c_callbacks
		end

feature -- Element change

	set_gc_protected_callbacks_target (target: EL_GC_PROTECTED_OBJECT)
		do
			exml_set_encoding_info_callback_object (encoding_info.item, target.item)
			exml_set_encoding_info_convert_callback (encoding_info.item, $on_convert)
			exml_set_encoding_info_release_callback (encoding_info.item, $on_release)
		end

feature {NONE} -- Call backs

	frozen on_convert (str_ptr: POINTER): INTEGER
		do
		end

	frozen on_release
		do
			unprotect_c_callbacks
		end

feature {NONE} -- Implementation

	fill_encoding_info_map
		local
			l_unicodes: SPECIAL [CHARACTER_32]
			i: INTEGER
		do
			l_unicodes := unicodes
			from i := 0 until i > 255 loop
				encoding_info.put_natural_32 (l_unicodes.item (i).natural_32_code, i)
				i := i + 1
			end
		end

	unicodes: SPECIAL [CHARACTER_32]
		deferred
		ensure
			valid_range: Result.lower = 0 and Result.upper = 255
		end

	encoding_info: MANAGED_POINTER

end
