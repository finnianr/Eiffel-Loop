note
	description: "Exception routines that make use of [$source EL_ZSTRING] templating feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-05 12:42:51 GMT (Tuesday 5th May 2020)"
	revision: "13"

class
	EL_EXCEPTION_ROUTINES

inherit
	ANY

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_UNIX_SIGNALS

	EL_MODULE_ZSTRING

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
			Result := manager.last_exception
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
			if attached {EXCEPTION} last_exception as l_last then
				Result := l_last.trace
			else
				create Result.make_empty
			end
		end

	last_trace_lines: EL_SPLIT_STRING_LIST [STRING_32]
		do
			create Result.make (last_trace, "%N")
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

feature -- Basic operations

	put_last_trace (log: EL_LOGGABLE)
		local
			lines: like last_trace_lines
		do
			lines := last_trace_lines
			from lines.start until lines.after loop
				log.put_line (lines.item (False))
				lines.forth
			end
		end

	raise (exception: EXCEPTION; a_template: READABLE_STRING_GENERAL; inserts: TUPLE)
		local
			message: STRING_32; template: ZSTRING
		do
			if inserts.is_empty then
				create message.make_from_string_general (a_template)
			else
				template := Zstring.as_zstring (a_template)
				message := template #$ inserts
			end
			exception.set_description (message)
			exception.raise
		end

	raise_developer (a_template: READABLE_STRING_GENERAL; inserts: TUPLE)
		local
			template: ZSTRING
		do
			template := Zstring.as_zstring (a_template)
			raise (create {DEVELOPER_EXCEPTION}, template, inserts)
		end

	raise_panic (a_template: READABLE_STRING_GENERAL; inserts: TUPLE)
		local
			template: ZSTRING
		do
			template := Zstring.as_zstring (a_template)
			raise (create {EIFFEL_RUNTIME_PANIC}, template, inserts)
		end

	raise_routine (object: ANY; routine_name: STRING)
		do
			raise_developer (Template_error_in_routine, [object.generator, routine_name])
		end

	write_last_trace (object: ANY)
		local
			trace_path: EL_FILE_PATH
		do
			trace_path := object.generator + "-exception.01.txt"
			if attached open (trace_path.next_version_path, Write) as file then
				file.put_string_32 (last_trace); close
			end
		ensure then
			files_closed: all_closed
		end

feature {NONE} -- Internal attributes

	internal_exceptions: EXCEPTIONS

feature {NONE} -- Constants

	Template_error_in_routine: ZSTRING
		once
			Result := "Error in routine: {%S}.%S"
		end

end
