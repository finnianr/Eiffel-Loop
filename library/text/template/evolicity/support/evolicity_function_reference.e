note
	description: "Evolicity function reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-13 18:27:51 GMT (Thursday 13th March 2025)"
	revision: "8"

class
	EVOLICITY_FUNCTION_REFERENCE

inherit
	EVOLICITY_VARIABLE_REFERENCE
		rename
			make as make_sized
		redefine
			arguments
		end

create
	make

feature {NONE} -- Initialization

	make (other: EVOLICITY_VARIABLE_REFERENCE; a_arguments: like Default_arguments)
		do
			make_from_special (other.area)
			arguments := a_arguments
		end

feature -- Access

	arguments: like Default_arguments
		-- Arguments for eiffel context function with open arguments

end