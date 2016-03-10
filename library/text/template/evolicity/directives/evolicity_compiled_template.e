note
	description: "Summary description for {EVOLICITY_COMPILED_TEMPLATE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-23 15:34:56 GMT (Saturday 23rd November 2013)"
	revision: "4"

class
	EVOLICITY_COMPILED_TEMPLATE

inherit
	EVOLICITY_COMPOUND_DIRECTIVE
		rename
			make as make_directive
		end

create
	make

feature {NONE} -- Initialization

	make (directives: ARRAY [EVOLICITY_DIRECTIVE]; a_modification_time: like modification_time; a_has_file_source: BOOLEAN)
		do
			make_from_array (directives)
			modification_time := a_modification_time
			has_file_source := a_has_file_source
		end

feature -- Access

	modification_time: DATE_TIME

feature -- Status query

	has_file_source: BOOLEAN

feature -- Status query

	set_has_file_source
		do
			has_file_source := True
		end

feature -- Element change

	set_modification_time (a_modification_time: like modification_time)
		do
			modification_time := a_modification_time
		end

end
