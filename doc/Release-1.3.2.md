# Eiffel-Loop (1.3.2) released 17th March 2016

FEATURES AND IMPROVEMENTS

* Production ready `ZSTRING` class
* Reimplementation of parsing and pattern module for increased efficiency
* Caching of Evolicity templates as intermediate byte-code for faster reloading (200% +)
* Addition of convenience routine fill_with_field_setters to class `EL_EIF_OBJ_BUILDER_CONTEXT`. This allows the automatic mapping of Eiffel integer and string class attributes to XML elements using class `EL_BUILDABLE_FROM_XML`. For an example see class `RBOX_IRADIO_ENTRY` in project *el_rhythmbox**.
* Addition of convenience routines that use routine *field_table_with_condition* in class `EVOLICITY_EIFFEL_CONTEXT` to automatically add Eiffel integer and string attributes to an Evolicity variable context as an iterable list. In conjunction with class `EVOLICITY_SERIALIZEABLE`, it can be used to serialize data as XML as in this example from class `RBOX_IRADIO_ENTRY` in project *el_rhythmbox**:

```` eiffel
Template: STRING
    --
 once
    Result := "[
    <entry type="iradio">
    #across $non_empty_string_fields as $field loop
       <$field.key>$field.item</$field.key>
    #end
       <location>$location_uri</location>
       <date>0</date>
       <mimetype>application/octet-stream</mimetype>
    </entry>
    ]"
 end
````

* Overhaul of `EL_OUTPUT_MEDIUM` class hierarchy with many improvements and bug fixes
* Refactored `ZSTRING_BENCHMARK_APP`

And many other improvements and bug fixes

\* See project [Eiffel-Loop/example/manage-mp3](https://github.com/finnianr/Eiffel-Loop/tree/master/example/manage-mp3)
