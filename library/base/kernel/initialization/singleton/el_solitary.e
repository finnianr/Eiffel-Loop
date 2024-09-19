note
	description: "Object is a solitary globally shared instance, i.e. a singleton"
	notes: "[
		Use one of the following classes in a once routine to retrieve this object from `Singleton_table'
			
		* ${EL_SINGLETON}
		* ${EL_CONFORMING_SINGLETON}

		For example:

			feature {NONE} -- Constants

				Database: RBOX_DATABASE
					once
						Result := create {EL_CONFORMING_SINGLETON [RBOX_DATABASE]}
					end

		In this example the routine will return either ${RBOX_DATABASE} or ${RBOX_TEST_DATABASE}
		depending on which instance is found in `Singleton_table'.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-18 8:30:43 GMT (Wednesday 18th September 2024)"
	revision: "9"

deferred class
	EL_SOLITARY

inherit
	EL_SHARED_SINGLETONS

feature {NONE} -- Initialization

	make
		do
			put_singleton (Current)
		ensure
			globally_shareable: Singleton_table.has (Current)
		end

note
	descendants: "[
			EL_SOLITARY*
				${EL_LOCALIZED_APPLICATION*}
					${I18N_AUTOTEST_APP}
				${EL_BUILD_INFO*}
					${BUILD_INFO}
					${EIFFEL_LOOP_BUILD_INFO}
				${EL_APPLICATION_LIST}
				${EL_APPLICATION*}
				${EL_LOG_MANAGER}
					${EL_CRC_32_LOG_MANAGER}
				${EL_GLOBAL_LOGGING}
				${EL_APPLICATION_COMMAND_OPTIONS}
					${EROS_APPLICATION_COMMAND_OPTIONS}
				${EL_LOCALE_TABLE}
				${EL_DEFERRED_LOCALE_I*}
					${EL_LOCALE}
						${EL_DEFAULT_LOCALE}
					${EL_DEFERRED_LOCALE_IMP}
				${EL_THREAD_MANAGER}
				${AIA_CREDENTIAL_LIST}
					${AIA_STORABLE_CREDENTIAL_LIST}
				${EL_APPLICATION_CONFIGURATION*}
	]"
end