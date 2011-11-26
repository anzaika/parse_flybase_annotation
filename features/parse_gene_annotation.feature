Feature: Parse gene annotation
  Note:
    Flybase has interbase annotation in its internal Chado database.
    But it does not explait that you need to shift one nucleotide towards 3'
    on the 5' end of any segment.
    So this shifting also needs to be implemented.
  Scenario: Parse annotation with only one mrna
    Given the annotation:
      """
      585     CG11023-RA      chr2L   +       7528    9491    7679    9276    3       7528,8228,8667, 8116,8589,9491,
      """
    When I parse annotation
    Then there should be 1 mrnas
    And there should be 3 exons
    And there should be mrnas:
      | CG11023-RA | 11023 | + | 2L | [[7680,8116],[8229,8589],[8668,9276]] |
    And there should be exons:
      | const | 7680 | 8116 | 2L | ["CG11023-RA"] |
      | const | 8229 | 8589 | 2L | ["CG11023-RA"] |
      | const | 8668 | 9276 | 2L | ["CG11023-RA"] |

  Scenario: Parse annotation with multiple mrnas
    Given the annotation:
      """
      585     CG11023-RA      chr2L   +       7528    9491    7679    9276    3       7528,8228,8667, 8116,8589,9491,
      585     CG11023-RB      chr2L   +       7528    9491    7679    9276    3       7528,8667, 8116,9491,
      """
    When I parse annotation
    Then there should be 2 mrnas
    And there should be 3 exons
    And there should be mrnas:
      | CG11023-RA | 11023 | + | 2L | [[7680,8116],[8229,8589],[8668,9276]] |
      | CG11023-RB | 11023 | + | 2L | [[7680,8116],[8668,9276]] |
    And there should be exons:
      | const | 7680 | 8116 | 2L | ["CG11023-RA", "CG11023-RB"] |
      | const | 8668 | 9276 | 2L | ["CG11023-RA", "CG11023-RB"] |
      | alt   | 8229 | 8589 | 2L | ["CG11023-RA"]               |

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
    And there should be mrnas:
      | CG11023-RA | 11023 | + | 2L | [[7680,8116],[8229,8589],[8668,9276]] |
      | CG11023-RB | 11023 | + | 2L | [[7680,8116],[8668,9276]]             |
      | CG2718-RC  | 2718  | + | 2L | [[132483,133682]]                     |
      | CG2718-RB  | 2718  | + | 2L | [[132483,132255],[132476,133682]]     |
    And there should be exons:
      | const | 7680   | 8116   | 2L | ["CG11023-RA", "CG11023-RB"] |
      | const | 8668   | 9276   | 2L | ["CG11023-RA", "CG11023-RB"] |
      | alt   | 8229   | 8589   | 2L | ["CG11023-RA"]               |
      | alt   | 132483 | 133682 | 2L | ["CG2718-RC"]               |
      | alt   | 132483 | 132255 | 2L | ["CG2718-RB"]               |
      | alt   | 132476 | 133682 | 2L | ["CG2718-RB"]               |

