Feature: Parse gene annotation
  Scenario: Parse annotation with only one mrna
    Given the annotation:
      """
      585     CG11023-RA      chr2L   +       7528    9491    7679    9276    3       7528,8228,8667, 8116,8589,9491,
      """
    When I parse annotation
    Then there should be 1 mrnas
    And there should be 3 exons
    And there should be mrna:
      | mrna_id    | CG11023-RA                            |
      | gene_id    | 11023                                 |
      | strand     | +                                     |
      | chromosome | 2L                                    |
      | exons      | [[7679,8116],[8228,8589],[8667,9276]] |
    And there should be exon:
      | chromosome | 2L              |
      | mrnas      | ["CG11023-RA"]  |
      | start      | 7679            |
      | stop       | 8116            |
      | splicing   | const           |
    And there should be exon:
      | chromosome | 2L              |
      | mrnas      | ["CG11023-RA"]  |
      | start      | 8228            |
      | stop       | 8589            |
      | splicing   | const           |
    And there should be exon:
      | chromosome | 2L              |
      | mrnas      | ["CG11023-RA"]  |
      | start      | 8667            |
      | stop       | 9276            |
      | splicing   | const           |
