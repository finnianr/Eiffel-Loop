note
	description: "Exception routines that make use of `EL_ZSTRING' templating feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_EXCEPTION_ROUTINES

feature -- Basic operations

	raise (exception: EXCEPTION; template: ZSTRING; inserts: TUPLE)
		local
			message: STRING_32
		do
			if inserts.is_empty then
				message := template
			else
				message := template #$ inserts
			end
			exception.set_description (message)
			exception.raise
		end

	raise_developer (template: ZSTRING; inserts: TUPLE)
		do
			raise (create {DEVELOPER_EXCEPTION}, template, inserts)
		end

	raise_panic (template: ZSTRING; inserts: TUPLE)
		do
			raise (create {EIFFEL_RUNTIME_PANIC}, template, inserts)
		end

	raise_routine (object: ANY; routine_name: STRING)
		do
			raise_developer (Template_error_in_routine, [object.generator, routine_name])
		end

feature {NONE} -- Constants

	Template_error_in_routine: ZSTRING
		once
			Result := "Error in routine: {%S}.%S"
		end
end