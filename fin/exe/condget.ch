/***
*  @.. CONDGET
*/

#command @ <row>, <col> CONDGET <var>                     ;
                        [ PICTURE <pic> ]                                        ;
                        [ VALID <valid> ]                                        ;
                        [ WHEN <when> ]                                          ;
                        [ SEND <msg> ]                                           ;
                                                          ;
 => SetPos( <row>, <col> )                                ;
 ; AAdd(                                                  ;
         GetList,                                         ;
         CondGet                                          ;
         ( __GET(                                         ;
                  { | newVal |IIF( newVal == NIL,         ;
                                   <var>,                 ;
                                   <var> := newVal        ;
                                 )                        ;
                  },                                      ;
                  <"var">, NIL, <{ valid }>, <{ when }> ;
                  ;//<"var">, <pic>, <{ valid }>, <{ when }> ;
                )                                         ;
         )                                                ;
       )                                                  ;
 [ ; ATail( GetList ):<msg> ]


/***
*   @..SAY..CONDGET
*/

#command @ <row>, <col> SAY <sayxpr>                                    ;
                        [<sayClauses,...>]                              ;
                        CONDGET <var>                                       ;
                        [<getClauses,...>]                              ;
                                                                        ;
      => @ <row>, <col> SAY <sayxpr> [<sayClauses>]                     ;
       ; @ Row(), Col()+1 CONDGET <var> [<getClauses>]




// @..CONDGET COLOR

#command @ <row>, <col> CONDGET <var>                                       ;
                        [<clauses,...>]                                 ;
                        COLOR <color>                                   ;
                        [<moreClauses,...>]                             ;
                                                                        ;
      => @ <row>, <col> CONDGET <var>                                       ;
                        [<clauses>]                                     ;
                        SEND colorDisp(<color>)                         ;
                        [<moreClauses>]

