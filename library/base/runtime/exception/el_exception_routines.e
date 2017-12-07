note
	description: "Exception routines that make use of `EL_ZSTRING' templating feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-05 11:41:06 GMT (Tuesday 5th December 2017)"
	revision: "4"

class
	EL_EXCEPTION_ROUTINES

inherit
	EXCEPTION_MANAGER_FACTORY

create
	make

feature {NONE} -- Initialization

	make
		do
			manager := Exception_manager
		end

feature -- Access

	last_out: STRING
		do
			if attached {EXCEPTION} last_exception as last then
				Result := last.out
			else
				create Result.make_empty
			end
		end

	last_signal_code: INTEGER
		-- Result >= 0 if `last_exception' was a signal failure
		do
			if attached {OPERATING_SYSTEM_SIGNAL_FAILURE} last_exception as os then
				Result := os.signal_code
			else
				Result := Result.one.opposite
			end
		end

	last_trace: STRING_32
		do
			if attached {EXCEPTION} last_exception as last then
				Result := last.trace
			else
				create Result.make_empty
			end
		end

	last_exception: EXCEPTION
		do
			Result := manager.last_exception
		end

	manager: like exception_manager

feature -- Status query

	received_broken_pipe_signal: BOOLEAN
		do
			if attached {ROUTINE_FAILURE} last_exception as routine
				and then attached {IO_FAILURE} routine.original as exception
			then
				Result := exception.message.same_string ("Broken pipe")
			end
		end

	received_termination_signal: BOOLEAN
		do
			Result := Termination_signals.has (last_signal_code)
		end

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

	Termination_signals: ARRAY [INTEGER]
		once
			Result := << Unix.Sigint, Unix.Sigterm >>
		end

	Unix: UNIX_SIGNALS
		once
			create Result
		end

end
