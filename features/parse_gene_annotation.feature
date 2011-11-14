Feature: Parse gene annotation
  A string from a typical flybase gene annotation
  looks like this:
    | unknown    | 585             |
    | gene_id    | CG11023-RA      |
    | chromosome | chr2L           |
    | strand     | +               |
    | mrna_start | 7528            |
    | mrna_stop  | 9491            |
    | unkwnown   | 7679            |
    | mrna_id    | 9276            |
    | seg_count  | 3               |
    | seg_starts | 7528,8228,8667, |
    | seg_stops  | 8116,8589,9491, |
  There can be several records with the same mrna_id

