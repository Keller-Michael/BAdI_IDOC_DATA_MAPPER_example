CLASS...

* | [--->] CONTROL                        TYPE        EDIDC
* | [--->] DATA                           TYPE        TAB_EDIDD
* | [<-->] HAVE_TO_CHANGE                 TYPE        CHAR1
* | [<-->] PROTOCOL                       TYPE        IDOCSTATMP
* | [<-->] MAPPING_TAB                    TYPE        TAB_ICHANG
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD if_ex_idoc_data_mapper~process.
    " see documentation of interface IF_EX_IDOC_DATA_MAPPER
    CONSTANTS error_indicator TYPE char1 VALUE 'E'.
    
    IF zcl_idoc_data_mapper=>is_idoc_relevant( control ) = abap_false.
      RETURN.
    ENDIF.

    DATA(mapper) = zcl_idoc_data_mapper=>get_instance( ).
    IF mapper IS NOT BOUND.
      have_to_change = error_indicator.
      protocol-stamid = 'Z_MSGS'.
      protocol-stamno = '000'.
      RETURN.
    ENDIF.

    TRY.
        mapper->map_idoc_data(
                  EXPORTING
                    idoc_control     = control
                    idoc_data        = data
                  CHANGING
                    change_indicator = have_to_change
                    protocol         = protocol
                    mapping          = mapping_tab ).

      CATCH zcx_idoc_data_mapping.
        have_to_change = error_indicator.
        protocol-stamid = 'Z_MSGS'.
        protocol-stamno = '001'.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
