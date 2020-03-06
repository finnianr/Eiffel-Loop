note
	description: "Suspendable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-25 17:14:07 GMT (Tuesday 25th February 2020)"
	revision: "5"

deferred class
	EL_SUSPENDABLE

inherit
	EL_SINGLE_THREAD_ACCESS
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create can_resume.make
		end

feature -- Basic operations

	resume
			-- unblock thread
		do
			restrict_access
				 -- ensures thread is in wait condition before signaling
			end_restriction
			can_resume.signal
		end

	suspend
			-- block thread and wait for signal to resume
		do
			restrict_access
				internal_is_suspended := True
				on_suspension
				wait_until_signaled (can_resume)
				internal_is_suspended := False
			end_restriction
		end

feature -- Status query

	is_suspended: BOOLEAN
			--
		do
			restrict_access
				Result := internal_is_suspended
			end_restriction
		end

feature {NONE} -- Event handling

	on_suspension
			--
		do
		end

feature {NONE} -- Implementation

	internal_is_suspended: BOOLEAN

	can_resume: CONDITION_VARIABLE

end
