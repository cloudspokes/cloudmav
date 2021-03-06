Feature: Blogs

	As a CodeMav user
	I want to sync with my blogs
	So that I can get points and people can see what blog posts I've written
	
	Background:
		Given I am logged in
		
  Scenario: Add Blog

    When I add a blog
    Then the blog should be added to my profile 
    And I should be awarded the "iBlog" badge
    And I should earned writer points for my blog
    And I should have posts

  Scenario: Peter adds a blog
  
    When I add a blog "http://feeds.feedburner.com/pseale"
    Then the blog should be added to my profile
    And I should have posts
  
  Scenario: Edit Blog
  
    Given I have a blog
    When I edit my blog
    Then my old posts should be deleted
    And I should have posts
    And I should earned writer points for my blog
    And I should have my new Blog posts
  
  Scenario: Delete Blog
  
    Given I have a blog
    When I delete my blog
    Then my old posts should be deleted
    And I should not have a blog
    And I should not have the "iBlog" badge
    And my old posts should be deleted
    And I should have 0 writing points
      
