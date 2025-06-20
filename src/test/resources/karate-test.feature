@REQ_HU-01 @karate @marvel
Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def random = java.util.UUID.randomUUID().toString()

  @id:1 @ListCharactersSuccess
  Scenario: T-API-HU-01-CA01-Character Verify 200, array empty
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters'
    When method get
    Then status 200
    And match response == '#[]'

  @id:2 @GetCharacterById
  Scenario: T-API-HU-01-CA02-Character add Character and get by (Id)
    * def name = 'Iron Man ' + random.substring(0, 5)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters'
    And request
    """
    {
      "name": "#(name)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    When method post
    Then status 201
    * def characterId = response.id

    Given url `http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters/${characterId}`
    When method get
    Then status 200

  @id:3 @GetCharacterByIdNotExists
  Scenario: T-API-HU-01-CA03-Character id not found
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters/4500'
    When method get
    Then status 404
    And match response.error == "Character not found"

  @id:4 @CreateCharacter
  Scenario: T-API-HU-01-CA04-Character add character Iron Man
    * def name = 'Iron Man ' + random.substring(0, 5)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters'
    And request
    """
    {
      "name": "#(name)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    When method post
    Then status 201

  @id:5 @CreateCharacterWithNameAlreadyExists
  Scenario: T-API-HU-01-CA05-Character add character exitsts
    * def name = 'Iron Man ' + random.substring(0, 5)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters'
    And request
    """
    {
      "name": "#(name)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    When method post
    Then status 201

    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters'
    And request
    """
    {
      "name": "#(name)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    When method post
    Then status 400
    And match response.error == "Character name already exists"

  @id:6 @CreateCharacterMissingParameters
  Scenario: T-API-HU-01-CA06-Character Add character without requiaired params
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters'
    And request
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    When method post
    Then status 400
    And match response.name == "Name is required"
    And match response.description == "Description is required"
    And match response.alterego == "Alterego is required"
    And match response.powers == "Powers are required"

  @id:7 @UpdateCharacter
  Scenario: T-API-HU-01-CA07-Character Save character
    * def name = 'Iron Man ' + random.substring(0, 5)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters'
    And request
    """
    {
      "name": "#(name)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    When method post
    Then status 201
    * def characterId = response.id

    Given url `http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters/${characterId}`
    And request
    """
    {
      "name": "Iron Man Avengers Updated",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """
    When method put
    Then status 200
    And match response.name == "Iron Man Avengers Updated"

  @id:8 @UpdateCharacterNotExists
  Scenario: T-API-HU-01-CA08-Character Update character thats not exists
    * def name = 'Iron Man ' + random.substring(0, 5)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters/83919'
    And request
    """
    {
      "name": "Iron Man Avengers Updated",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """
    When method put
    Then status 404
    And match response.error == "Character not found"

  @id:9 @DeleteCharacter
  Scenario: T-API-HU-01-CA09-Character add and delete character
    * def name = 'Iron Man ' + random.substring(0, 5)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters'
    And request
    """
    {
      "name": "#(name)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    When method post
    Then status 201
    * def characterId = response.id

    Given url `http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters/${characterId}`
    When method delete
    Then status 204

  @id:10 @DeleteCharacterNotExists
  Scenario: T-API-HU-01-CA10-Character Delete Character that not exists
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juanzamb/api/characters/231232'
    When method delete
    Then status 404
    And match response.error == "Character not found"