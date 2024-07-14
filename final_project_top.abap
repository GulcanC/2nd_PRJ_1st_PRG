*&---------------------------------------------------------------------*
*& Include          Z_POEC_INTEG_GCO_TOP
*&---------------------------------------------------------------------*

*& GULCAN COSKUN | FINAL PROJECT | 27/04/2023
*&---------------------------------------------------------------------*

*globales (table, variable structure, classe) : gt_xxx gv_xxx, gs_xxx, gcl_xxx
*locales (table) variable structure, classe) : lt_xxx lv_xxx, ls_xxx, lcl_xxx.
*Pour les fields symbols <fsg_xxx> et <fsl_xxx>

* Create your table header ZEKKO_GCO by using SE11
* Left side is the name of the fields, right side is type of the element

*MANDT  MANDANT
*EBELN  EBELN
*BSTYP  EBSTYP
*AEDAT  ERDAT
*ERNAM  ERNAM
*WAERS  WAERS


* Create your table item ZEKKO_GCO by using SE11
* Left side is the name of the fields, right side is type of the element

*MANDT  MANDT
*EBELN  EBELN
*EBELP  EBELP
*MATNR  MATNR
*WERKS  WERKS_D
*MENGE  BSTMG
*NETPR  BPREI
*NETWR  BWERT
*MEINS  BSTME

************************************************************************************************* FIRST PART
TABLES: ZEKKO_GCO, ZEKPO_GCO.

TYPES: BEGIN OF ts_table,
         line TYPE string,
       END OF ts_table,
       tt_table TYPE STANDARD TABLE OF ts_table WITH EMPTY KEY.

 DATA : gt_file TYPE STANDARD TABLE OF ts_table.



* create model for purchasing order
TYPES : BEGIN OF ty_ekko_ekpo,

          ebeln TYPE ekko-ebeln,         " doc. d'achat | EKKO
          bstyp TYPE ekko-bstyp ,        " Cat. doc  | EKKO
          aedat TYPE ekko-aedat,         " cree le  | EKKO
          ernam TYPE ekko-ernam ,        " creer par | EKKO
          waers TYPE ekko-waers,         " devise | EKKO
          ebelp TYPE ekpo-ebelp,         " poste  | EKPO
          matnr TYPE ekpo-matnr ,        " numéro d'article  | EKPO
          werks TYPE ekpo-werks ,        " divison, plant  | EKPO
          menge TYPE ekpo-menge ,        " qté commande  | EKPO
          netpr TYPE ekpo-netpr,         " Net price  | EKPO
          netwr TYPE ekpo-netwr ,        " Valeur nette  | EKPO
          meins TYPE ekpo-meins,         " Unité d'achat  | EKPO
        END OF ty_ekko_ekpo.


DATA : gt_data TYPE TABLE OF ty_ekko_ekpo.