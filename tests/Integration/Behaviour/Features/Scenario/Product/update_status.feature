# ./vendor/bin/behat -c tests/Integration/Behaviour/behat.yml -s product --tags update-status
@restore-products-before-feature
@clear-cache-before-feature
@update-status
Feature: Update product status from BO (Back Office)
  As an employee I must be able to update product status (enable/disable)

  Background:
    Given language "language1" with locale "en-US" exists
    And category "home" in default language named "Home" exists
    And category "home" is the default one

  Scenario: I update standard product status
    Given I add product "product1" with following information:
      | name[en-US] | Values list poster nr. 1 (paper) |
      | type        | standard                         |
    And product product1 type should be standard
    And product "product1" should be disabled
    And product "product1" should not be indexed
    When I enable product "product1"
    Then product "product1" should be enabled
    And product "product1" should be indexed
    When I disable product "product1"
    Then product "product1" should be disabled
    And product "product1" should not be indexed

  Scenario: I update virtual product status
    And I add product "product2" with following information:
      | name[en-US] | Values list poster nr. 2 (virtual) |
      | type        | virtual                            |
    And product product2 type should be virtual
    And product "product2" should be disabled
    When I enable product "product2"
    Then product "product2" should be enabled
    And product "product2" should be indexed
    When I disable product "product2"
    Then product "product2" should be disabled
    And product "product2" should not be indexed

  Scenario: I update combination product status
    And I add product "product3" with following information:
      | name[en-US] | T-Shirt with listed values |
      | type        | combinations               |
    And product "product3" has following combinations:
      | reference | quantity | attributes         |
      | whiteS    | 100      | Size:S;Color:White |
      | whiteM    | 150      | Size:M;Color:White |
      | blackM    | 130      | Size:M;Color:Black |
    And product product3 type should be combinations
    And product "product3" should be disabled
    When I enable product "product3"
    Then product "product3" should be enabled
    And product "product3" should be indexed
    When I disable product "product3"
    Then product "product3" should be disabled
    And product "product3" should not be indexed

  Scenario: I disable product which is already disabled
    Given product "product1" should be disabled
    When I disable product "product1"
    Then product "product1" should be disabled
    And product "product1" should not be indexed

  Scenario: I enable product which is already enabled
    Given product "product1" should be disabled
    When I enable product "product1"
    Then product "product1" should be enabled
    And product "product1" should be indexed
    When I enable product "product1"
    Then product "product1" should be enabled
    And product "product1" should be indexed

  Scenario: I can not publish a product without a name
    When I add product "product4" with following information:
      | type        | standard       |
    Then product "product4" should be disabled
    And product "product4" type should be standard
    And product "product4" localized "name" should be:
      | locale | value |
      | en-US  |       |
    And product "product4" should be assigned to following categories:
      | id reference | name[en-US] | is default |
      | home         | Home        | true       |
    When I enable product "product4"
    Then I should get an error that product online data are invalid
    And product "product4" should be disabled
    When I update product "product4" basic information with following values:
      | name[en-US] | photo of funny mug |
    Then product "product4" localized "name" should be:
      | locale     | value              |
      | en-US      | photo of funny mug |
    When I enable product "product4"
    And product "product4" should be enabled
