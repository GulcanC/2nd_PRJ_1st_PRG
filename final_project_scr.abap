*&---------------------------------------------------------------------*
*& Include          Z_POEC_INTEG_GCO_SCR

*&------ GULCAN COSKUN | FINAL PROJECT | 24/04/2023 -------------------*
*&---------------------------------------------------------------------*

* First declare parameters for the local file to select the file from PC

SELECTION-SCREEN BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-001.
  PARAMETERS : p_file TYPE localfile,
               p_test AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK b0.

* To choose a file, there is no small search place, now put this place to choose a file
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

 " IF p_rad1 IS NOT INITIAL.
    CALL FUNCTION 'F4_FILENAME'
      EXPORTING
        program_name  = syst-cprog
        dynpro_number = syst-dynnr
        field_name    = 'P_FILE'
      IMPORTING
        file_name     = p_file.
 " ENDIF.