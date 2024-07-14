*&---------------------------------------------------------------------*
*& Include          Z_POEC_INTEG_GCO_F01
*&---------------------------------------------------------------------*

*&----------- FINAL PROJECT | PURCHASE ORDER CREATION | GULCAN COSKUN | 27/04/2023 --------------*

*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM get_data .
    " declare a local variable to get the file
    " lv_filename is empty, we declared p_file in the screen
    
      DATA : lv_fileName TYPE string.
      lv_fileName = p_file.
    
      CALL FUNCTION 'GUI_UPLOAD'
        EXPORTING
          filename                = lv_fileName
          filetype                = 'ASC'
        TABLES
    " here we will write the global table, first create a model for data_tab
          data_tab                = gt_file
        EXCEPTIONS
          file_open_error         = 1
          file_read_error         = 2
          no_batch                = 3
          gui_refuse_filetransfer = 4
          invalid_type            = 5
          no_authority            = 6
          unknown_error           = 7
          bad_data_format         = 8
          header_not_allowed      = 9
          separator_not_allowed   = 10
          header_too_long         = 11
          unknown_dp_error        = 12
          access_denied           = 13
          dp_out_of_memory        = 14
          disk_full               = 15
          dp_timeout              = 16
          OTHERS                  = 17.
      IF sy-subrc <> 0.
    
      ENDIF.
    
    
    
    ENDFORM.
    
    
*&---------------------------------------------------------------------*
*& Form prepare_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
    FORM prepare_data .
    
* USEFUL LINK | https://abapwithalexlee.wordpress.com/2013/06/27/translate-condense/
    
    " Translate can be used to convert text to a mask specified
    " Condense is like a combination, for example we have a value 10,000.00
    " TRANSLATE value USING ', '.
    " CONDENSE value NO-GAPS.
    " the syntax TRANSLATE will replace the comma as empty character. The output will be 10 000.00
    " After condense with no gaps, the output would be 10000.
    "  TRY CATCH to find error. Run time error : cx_sy_itab_line_not_found means the specified table row was not found.
    
    
      DATA : lv_date  TYPE string.
    
      LOOP AT gt_file ASSIGNING FIELD-SYMBOL(<fsl_file>).
        SPLIT <fsl_file>-line AT cl_abap_char_utilities=>horizontal_tab INTO TABLE DATA(lt_split_csv).
    "    IF  lines( lt_split_csv ) <> 12.
    "      CONTINUE.
    "    ENDIF.
    
        IF lt_split_csv IS NOT INITIAL.
          APPEND INITIAL LINE TO gt_data ASSIGNING FIELD-SYMBOL(<fsl_data>).
    
          IF <fsl_data> IS ASSIGNED.
    
            TRY.
                <fsl_data>-ebeln = lt_split_csv[ 1 ].
              CATCH cx_sy_itab_line_not_found.
                <fsl_data>-ebeln = ''.
            ENDTRY.
    
            TRY.
                <fsl_data>-bstyp = lt_split_csv[ 2 ].
              CATCH cx_sy_itab_line_not_found.
                <fsl_data>-bstyp = ''.
            ENDTRY.
    
    " normally my date is like date 31.08.2018, If I do not split date, it is shown like date 20.8..31.0, so I have to split it by using '.'
    
*******************************************************  FIRST WAY TO SPLIT DATE, It works good, it likes a concatination
    
    "        TRY.
    "            lv_date = lt_split_csv[ 3 ].
    "          CATCH cx_sy_itab_line_not_found.
    "            <fsl_data>-aedat = ''.
    "        ENDTRY.
    "
    "        SPLIT lv_date AT '.' INTO TABLE DATA(lt_date).
    "        lv_date = lt_date[ 3 ] && lt_date[ 2 ] && lt_date[ 1 ].
    "        <fsl_data>-aedat = lv_date.
    
    
****************************************************   SECOND WAY TO SPLIT DATE, It works also good, in this method, we use module function 'CONVERSION_EXIT_SDATE_INPUT'
    
            CALL FUNCTION 'CONVERSION_EXIT_SDATE_INPUT'
              EXPORTING
                input  = lt_split_csv[ 3 ]
              IMPORTING
                output = lv_date.
    
            <fsl_data>-aedat = lv_date.
    
            TRY.
                <fsl_data>-ernam = lt_split_csv[ 4 ].
              CATCH cx_sy_itab_line_not_found.
                <fsl_data>-ernam = ''.
            ENDTRY.
    
            TRY.
                <fsl_data>-waers = lt_split_csv[ 5 ].
              CATCH cx_sy_itab_line_not_found.
                <fsl_data>-waers = ''.
            ENDTRY.
    
            TRY.
                <fsl_data>-ebelp = lt_split_csv[ 6 ].
              CATCH cx_sy_itab_line_not_found.
                <fsl_data>-ebelp = ''.
            ENDTRY.
    
            TRY.
                <fsl_data>-matnr = lt_split_csv[ 7 ].
              CATCH cx_sy_itab_line_not_found.
                <fsl_data>-matnr = ''.
            ENDTRY.
    
            TRY.
                <fsl_data>-werks = lt_split_csv[ 8 ].
              CATCH cx_sy_itab_line_not_found.
                <fsl_data>-werks = ''.
            ENDTRY.
    
    "        <fsl_data>-ebeln = lt_split_csv[ 1 ].
    "        <fsl_data>-bstyp = lt_split_csv[ 2 ].
    "        <fsl_data>-aedat = lt_split_csv[ 3 ].
    "        <fsl_data>-ernam = lt_split_csv[ 4 ].
    "        <fsl_data>-waers = lt_split_csv[ 5 ].
    "        <fsl_data>-ebelp = lt_split_csv[ 6 ].
    "        <fsl_data>-matnr = lt_split_csv[ 7 ].
    "        <fsl_data>-werks = lt_split_csv[ 8 ].
    
    
    "        REPLACE ALL OCCURRENCES OF '.' IN lv_menge WITH ''   AND   TRANSLATE lv_menge USING '. ' ARE THE SAME THING
    "        I can use both of these statments
    
            DATA(lv_menge) =  lt_split_csv[ 9 ] .
            REPLACE ALL OCCURRENCES OF ',' IN lv_menge WITH '.'.
            REPLACE ALL OCCURRENCES OF '.' IN lv_menge WITH ''.
            CONDENSE lv_menge NO-GAPS.
            <fsl_data>-menge = lv_menge.
    
            DATA(lv_netpr) = lt_split_csv[ 10 ] .
            TRANSLATE lv_netpr USING ',.'.
            TRANSLATE lv_netpr USING '. '.
            CONDENSE lv_netpr NO-GAPS.
            <fsl_data>-netpr = lv_netpr.
    
            DATA(lv_netwr) =  lt_split_csv[ 11 ] .
            TRANSLATE lv_netwr USING '. '.
            TRANSLATE lv_netwr USING ',.'.
            CONDENSE lv_netwr NO-GAPS.
            <fsl_data>-netwr = lv_netwr.
    
    "        <fsl_data>-meins = lt_split_csv[ 12 ].
    
            TRY.
                <fsl_data>-meins = lt_split_csv[ 12 ].
              CATCH cx_sy_itab_line_not_found.
                <fsl_data>-meins = ''.
            ENDTRY.
    
          ENDIF.
        ENDIF.
    
      ENDLOOP.
    
    ENDFORM.
    
    
    FORM insert_data .
    
      DELETE FROM zekko_gco.
      DELETE FROM zekpo_gco.
    
    " I created my tables ZEKKO_GCO and ZEKPO_GCO for header table and item table, now I have to declare my structure and my internal table
    
      DATA : ls_ekkogco TYPE zekko_gco,  "HEADER table
             lt_ekkogco TYPE STANDARD TABLE OF zekko_gco,
             ls_ekpogco TYPE zekpo_gco,   " ITEM TABLE
             lt_ekpogco TYPE STANDARD TABLE OF zekpo_gco,
             lv_ebeln   TYPE ekko-ebeln,
             lv_count   TYPE i.
    
    " data verification, use abap_boolean data type
    
      DATA : lv_error TYPE abap_boolean.
      lv_error = abap_false.
    
    
    " I have already used INSERT, so there are data in my tables, first clear tables by using "DELETE FROM" statement.
    
    
    
      LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fsl_ekko>).
        lv_error = abap_false.
    
    " Clear internal tables and structures.
    
        CLEAR : ls_ekkogco, lt_ekkogco.
    
        IF <fsl_ekko>-ebeln = lv_ebeln.
          CONTINUE.
        ENDIF.
    
        lv_ebeln            = <fsl_ekko>-ebeln.
        ls_ekkogco-ebeln    = <fsl_ekko>-ebeln .
        ls_ekkogco-bstyp    = <fsl_ekko>-bstyp .
        ls_ekkogco-aedat    = <fsl_ekko>-aedat .
        ls_ekkogco-ernam    = <fsl_ekko>-ernam .
        ls_ekkogco-waers    = <fsl_ekko>-waers.
        APPEND ls_ekkogco TO lt_ekkogco.
    
    
        LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fsl_ekpo>) WHERE ebeln = <fsl_ekko>-ebeln.
          lv_count = 0.
    
          LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fsl_ekko_ekpo>) WHERE ebeln = <fsl_ekpo>-ebeln.
            IF <fsl_ekpo>-ebelp = <fsl_ekko_ekpo>-ebelp.
              ADD 1 TO lv_count.
            ENDIF.
          ENDLOOP.
    
    
          IF lv_count > 1.
            lv_error = abap_true.
            EXIT.
          ENDIF.
    
          ls_ekpogco-ebeln = <fsl_ekpo>-ebeln .
          ls_ekpogco-ebelp = <fsl_ekpo>-ebelp .
          ls_ekpogco-matnr = <fsl_ekpo>-matnr .
          ls_ekpogco-werks = <fsl_ekpo>-werks .
          ls_ekpogco-menge = <fsl_ekpo>-menge .
          ls_ekpogco-netpr = <fsl_ekpo>-netpr .
          ls_ekpogco-netwr = <fsl_ekpo>-netwr .
          ls_ekpogco-meins = <fsl_ekpo>-meins .
          APPEND ls_ekpogco TO lt_ekpogco.
    
        ENDLOOP.
    
        IF lv_error = abap_false.
          WRITE : / ls_ekkogco-ebeln && ' -> '  && ' created ' .
    
    " If the check box is selected, show me all created data, ebeln
          IF p_test <> 'X'.
            INSERT zekpo_gco FROM TABLE lt_ekpogco ACCEPTING DUPLICATE KEYS.
            INSERT zekko_gco FROM TABLE lt_ekkogco ACCEPTING DUPLICATE KEYS.
          ENDIF.
        ELSEIF lv_error = abap_true.
          WRITE : / ls_ekkogco-ebeln && ' -> ' && ' not created ' COLOR 6.
        ENDIF.
      ENDLOOP.
    
    ENDFORM.