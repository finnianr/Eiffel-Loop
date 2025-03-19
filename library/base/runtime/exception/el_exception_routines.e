note
	description: "Exception routines that make use of ${EL_ZSTRING} templating feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-15 11:41:52 GMT (Saturday 15th March 2025)"
	revision: "25"

class
	EL_EXCEPTION_ROUTINES

inherit
	ANY

	EL_STRING_GENERAL_ROUTINES

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_UNIX_SIGNALS

create
	make

feature {NONE} -- Initialization

	make
		do
			create internal_exceptions
			manager := internal_exceptions.Exception_manager
		end

feature -- Access

	general, last: EXCEPTIONS
		do
			Result := internal_exceptions
		end

	last_exception: EXCEPTION
		do
			if attached last_cause as cause then
				Result := cause
			else
				Result := manager.last_exception
			end
		end

	last_out: STRING
		do
			if attached {EXCEPTION} last_exception as l_last then
				Result := l_last.out
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
			if attached last_exception as l_last then
				Result := l_last.trace
			else
				create Result.make_empty
			end
		end

	last_trace_splitter: EL_SPLIT_ON_CHARACTER [STRING_32]
		do
			create Result.make (last_trace, '%N')
		end

	manager: EXCEPTION_MANAGER

feature -- Status query

	is_termination_signal: BOOLEAN
		do
			Result := Unix_signals.is_termination (last_signal_code)
		end

feature -- Status setting

	catch (code: INTEGER)
		do
			general.catch (code)
		end

feature -- Element change

	set_last_cause (a_last_cause: detachable EXCEPTION)
		do
			last_cause := a_last_cause
		end

feature -- Basic operations

	put_last_trace (log: EL_LOGGABLE)
		do
			across last_trace_splitter as line loop
				log.put_line (line.item)
			end
		end

	raise (exception: EXCEPTION; a_template: READABLE_STRING_GENERAL; inserts: TUPLE)
		local
			message: ZSTRING
		do
			if inserts.is_empty then
				message := as_zstring (a_template)
			else
				message := as_zstring (a_template) #$ inserts
			end
			exception.set_description (message.to_general)
			exception.raise
		end

	raise_developer (a_template: READABLE_STRING_GENERAL; inserts: TUPLE)
		local
			template: ZSTRING
		do
			template := as_zstring (a_template)
			raise (create {DEVELOPER_EXCEPTION}, template, inserts)
		end

	raise_panic (a_template: READABLE_STRING_GENERAL; inserts: TUPLE)
		local
			template: ZSTRING
		do
			template := as_zstring (a_template)
			raise (create {EIFFEL_RUNTIME_PANIC}, template, inserts)
		end

	raise_routine (object: ANY; routine_name: STRING)
		do
			raise_developer (Template_error_in_routine, [object.generator, routine_name])
		end

	write_last_trace (object: ANY)
		local
			trace_path: FILE_PATH
		do
			trace_path := object.generator + "-exception.01.txt"
			if attached open (trace_path.next_version_path, Write) as file then
				file.put_string_32 (last_trace)
				file.close
			end
		end

feature {NONE} -- Internal attributes

	last_cause: detachable EXCEPTION

	internal_exceptions: EXCEPTIONS

feature {NONE} -- Constants

	Template_error_in_routine: ZSTRING
		once
			Result := "Error in routine: {%S}.%S"
		end

end