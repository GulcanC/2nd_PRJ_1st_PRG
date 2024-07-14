*&---------------------------------------------------------------------*
*& Report Z_POEC_INTEG_GCO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_poec_integ_gco.


INCLUDE Z_POEC_INTEG_GCO_top.
INCLUDE Z_POEC_INTEG_GCO_scr.
INCLUDE Z_POEC_INTEG_GCO_f01.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM prepare_data.

* FIRST INSERT DATA METHOD, IT WORKS GOOD
PERFORM insert_data.

* SECOND INSERT DATA METHOD, IT WORKS ALSO GOOD
 " PERFORM insert_data_2.