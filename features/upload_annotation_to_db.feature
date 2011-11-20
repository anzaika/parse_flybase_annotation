Feature: Parsed annotation should be uploaded to the database
  Database name 'dmel_annotation', it has two collections:
  mrna and exons.
  Document structure in db is the same as in generated
  Mrna and Exon objects.

  Scenario: Upload annotation to database.
    Given the annotation:
      """
      585     CG11023-RA      chr2L   +       7528    9491    7679    9276    3       7528,8228,8667, 8116,8589,9491,
      585     CG11023-RB      chr2L   +       7528    9491    7679    9276    3       7528,8667, 8116,9491,
      586     CG2718-RC       chr2L   +       132059  134472  132482  133682  1       132059, 134472,
      586     CG2718-RB       chr2L   +       132059  134472  132482  133682  2       132059,132475,  132255,134472,
      """
    When I parse and upload annotation
    Then collection "mrnas" should have 4 elements
    And collection "exons" should have 6 elements
    And collection "mrnas" should have mrna:
      | CG11023-RA | 11023 | + | 2L | [[7680,8116],[8229,8589],[8668,9276]] |
    And collection "mrnas" should have mrna:
      | CG11023-RB | 11023 | + | 2L | [[7680,8116],[8668,9276]]             |
    And collection "mrnas" should have mrna:
      | CG2718-RC  | 2718  | + | 2L | [[132483,133682]]                     |
    And collection "mrnas" should have mrna:
      | CG2718-RB  | 2718  | + | 2L | [[132483,132255],[132476,133682]]     |
    And collection "exons" should have exon:
      | const | 7680   | 8116   | 2L | ["CG11023-RA", "CG11023-RB"] |
    And collection "exons" should have exon:
      | const | 8668   | 9276   | 2L | ["CG11023-RA", "CG11023-RB"] |
    And collection "exons" should have exon:
      | alt   | 8229   | 8589   | 2L | ["CG11023-RA"]               |
    And collection "exons" should have exon:
      | alt   | 132483 | 133682 | 2L | ["CG2718-RC"]               |
    And collection "exons" should have exon:
      | alt   | 132483 | 132255 | 2L | ["CG2718-RB"]               |
    And collection "exons" should have exon:
      | alt   | 132476 | 133682 | 2L | ["CG2718-RB"]               |

