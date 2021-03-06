Feature: Talks
  
  As a user
  I want to add talks to CodeMav
  So others can know what I present
   
  Scenario: Add a talk
  
    Given I am logged in
    When I add a talk
    Then the talk should be added
    And I should have 10 speaker points
    
  Scenario: Edit a talk
  
    Given I am logged in
    And I have a talk
    When I edit the talk
    Then the talk should be updated

  Scenario: Add links to talk
  
    Given I am logged in
    And I have a talk
    When I add links to a talk
    Then the talk should have links