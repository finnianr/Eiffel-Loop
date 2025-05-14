note
	description: "Zstring benchmark command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-12 13:41:29 GMT (Monday 12th May 2025)"
	revision: "14"

class
	ZSTRING_BENCHMARK_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_LIO

	SHARED_HEXAGRAM_STRINGS

	EL_SHARED_ZSTRING_CODEC

create
	make

feature {EL_COMMAND_LINE_APPLICATION} -- Initialization

	make (output_dir: DIR_PATH; template_path: FILE_PATH; a_trial_duration_ms: INTEGER; filter: ZSTRING)
		local
			h: like Hexagram; date: EL_DATE_TIME; output_path: FILE_PATH
		do
			trial_duration_ms := a_trial_duration_ms; routine_filter := filter
			h := Hexagram
			create date.make_now
			output_path := output_dir +  Output_name_template #$ [codec.id, date.formatted_out ("yyyy-[0]mm-[0]dd")]
			if filter.count > 0 then
				output_path.replace_extension (filter)
				output_path.add_extension ("html")
			end
			create benchmark_html.make (template_path, output_path.to_ntfs_compatible ('_'))
		end

feature -- Constants

	Description: STRING = "Benchmark ZSTRING in relation to STRING_32"

feature -- Basic operations

	execute
		do
			lio.put_labeled_string ("{ZSTRING}.codec", codec.name)
			lio.put_new_line
			lio.put_integer_field ("Benchmark duration per test", trial_duration_ms)
			lio.put_string (" ms")
			lio.put_new_line
			lio.put_new_line

			benchmark_html.extend (
				create {ZSTRING_BENCHMARK}.make (Current),
				create {STRING_32_BENCHMARK}.make (Current)
			)
			benchmark_html.extend (
				create {MIXED_ENCODING_ZSTRING_BENCHMARK}.make (Current),
				create {MIXED_ENCODING_STRING_32_BENCHMARK}.make (Current)
			)
			benchmark_html.serialize
		end

feature {STRING_BENCHMARK} -- Internal attributes

	benchmark_html: BENCHMARK_HTML

	trial_duration_ms: INTEGER

	routine_filter: ZSTRING

feature {NONE} -- Constants

	Output_name_template: ZSTRING
		once
			Result := "ZSTRING-benchmarks-latin-%S (%S).html"
		end

end