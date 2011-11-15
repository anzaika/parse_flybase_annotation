Feature: Parse gene annotation
  A string from a typical flybase gene annotation looks like this:
  | unknown      | 585             |
  | mrna_id      | CG11023-RA      |
  | chromosome   | chr2L           |
  | strand       | +               |
  | mrna_start   | 7528            |
  | mrna_stop    | 9491            |
  | mrna_c_start | 7679            |
  | mrna_c_stop  | 9276            |
  | seg_count    | 3               |
  | seg_starts   | 7528,8228,8667, |
  | seg_stops    | 8116,8589,9491, |

  Scenario: Parse single annotation
    Given the annotation:
      """
      585     CG11023-RA      chr2L   +       7528    9491    7679    9276    3       7528,8228,8667, 8116,8589,9491,
      """
    When I parse annotation
    Then there should be 1 mrna
    And there should be 3 segments
    And there should be mrna:
      | mrna_id    | CG11023-RA                            |
      | strand     | +                                     |
      | chromosome | 2L                                    |
      | segments   | [[7679,8116],[8228,8589],[8667,9276]] |
    And there should be segment:
      | chromosome    | 2L              |
      | mrnas         | ["CG11023-RA"]  |
      | start         | 7679            |
      | stop          | 8116            |
      | splicing      | const           |
    And there should be segment:
      | chromosome    | 2L              |
      | mrnas         | ["CG11023-RA"]  |
      | start         | 8228            |
      | stop          | 8589            |
      | splicing      | const           |
    And there should be segment:
      | chromosome    | 2L              |
      | mrnas         | ["CG11023-RA"]  |
      | start         | 8667            |
      | stop          | 9276            |
      | splicing      | const           |
