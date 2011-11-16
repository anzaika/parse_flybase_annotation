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
      | CG11023-RA | 11023 | + | 2L | [[7679,8116],[8228,8589],[8667,9276]] |
    And there should be exon:
      | const | 7679 | 8116 | 2L | ["CG11023-RA"] |
    And there should be exon:
      | const | 8667 | 9276 | 2L | ["CG11023-RA"] |
    And there should be exon:
      | const | 8228 | 8589 | 2L | ["CG11023-RA"] |

  Scenario: Parse annotation with multiple mrnas
    Given the annotation:
      """
      585     CG11023-RA      chr2L   +       7528    9491    7679    9276    3       7528,8228,8667, 8116,8589,9491,
      585     CG11023-RB      chr2L   +       7528    9491    7679    9276    3       7528,8667, 8116,9491,
      """
    When I parse annotation
    Then there should be 2 mrnas
    And there should be 3 exons
    And there should be mrna:
      | CG11023-RA | 11023 | + | 2L | [[7679,8116],[8228,8589],[8667,9276]] |
    And there should be mrna:
      | CG11023-RB | 11023 | + | 2L | [[7679,8116],[8667,9276]] |
    And there should be exon:
      | const | 7679 | 8116 | 2L | ["CG11023-RA", "CG11023-RB"] |
    And there should be exon:
      | const | 8667 | 9276 | 2L | ["CG11023-RA", "CG11023-RB"] |
    And there should be exon:
      | alt   | 8228 | 8589 | 2L | ["CG11023-RA"]               |

  Scenario: Parse annotation with multiple mrnas and multiple gene_ids
    Given the annotation:
      """
      585     CG11023-RA      chr2L   +       7528    9491    7679    9276    3       7528,8228,8667, 8116,8589,9491,
      585     CG11023-RB      chr2L   +       7528    9491    7679    9276    3       7528,8667, 8116,9491,
      586     CG2718-RC       chr2L   +       132059  134472  132482  133682  1       132059, 134472,
      586     CG2718-RB       chr2L   +       132059  134472  132482  133682  2       132059,132475,  132255,134472,
      """
    When I parse annotation
    Then there should be 4 mrnas
    And there should be 6 exons
    And there should be mrna:
      | CG11023-RA | 11023 | + | 2L | [[7679,8116],[8228,8589],[8667,9276]] |
    And there should be mrna:
      | CG11023-RB | 11023 | + | 2L | [[7679,8116],[8667,9276]]             |
    And there should be mrna:
      | CG2718-RC  | 2718  | + | 2L | [[132482,133682]]                     |
    And there should be mrna:
      | CG2718-RB  | 2718  | + | 2L | [[132482,132255],[132475,133682]]     |
    And there should be exon:
      | const | 7679   | 8116   | 2L | ["CG11023-RA", "CG11023-RB"] |
    And there should be exon:
      | const | 8667   | 9276   | 2L | ["CG11023-RA", "CG11023-RB"] |
    And there should be exon:
      | alt   | 8228   | 8589   | 2L | ["CG11023-RA"]               |
    And there should be exon:
      | alt   | 132482 | 133682 | 2L | ["CG2718-RC"]               |
    And there should be exon:
      | alt   | 132482 | 132255 | 2L | ["CG2718-RB"]               |
    And there should be exon:
      | alt   | 132475 | 133682 | 2L | ["CG2718-RB"]               |

