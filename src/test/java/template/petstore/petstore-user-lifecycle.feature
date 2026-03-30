Feature: Petstore User Lifecycle
  Flujo completo de gestión de usuario: crear, consultar, actualizar, consultar cambios, eliminar y verificar eliminación.

  Background:
    * url petstore.baseUrl
    * def createPayload = read('classpath:data/petstore/user-lifecycle/create-user.json')
    * def updatePayload = read('classpath:data/petstore/user-lifecycle/update-user.json')
    * def username = createPayload.username
    * def userSchema = read('classpath:schemas/petstore/user-response.json')
    * def apiSchema = read('classpath:schemas/petstore/api-response.json')

  @smoke @regression
  Scenario: Ciclo de vida completo del usuario - crear, consultar, actualizar, eliminar

    # --- Crear usuario ---
    Given path petstore.paths.user
    And request createPayload
    When method post
    Then status 200
    And match response == apiSchema

    # --- Consultar usuario creado ---
    Given path petstore.paths.userByName + username
    When method get
    Then status 200
    And match response == userSchema
    And match response.username == createPayload.username
    And match response.firstName == createPayload.firstName
    And match response.lastName == createPayload.lastName
    And match response.email == createPayload.email

    # --- Actualizar usuario (firstName, lastName, email) ---
    Given path petstore.paths.userByName + username
    And request updatePayload
    When method put
    Then status 200
    And match response == apiSchema

    # --- Consultar usuario actualizado ---
    Given path petstore.paths.userByName + username
    When method get
    Then status 200
    And match response == userSchema
    And match response.firstName == updatePayload.firstName
    And match response.lastName == updatePayload.lastName
    And match response.email == updatePayload.email

    # --- Eliminar usuario ---
    Given path petstore.paths.userByName + username
    When method delete
    Then status 200
    And match response == apiSchema

    # --- Verificar eliminación (404) ---
    Given path petstore.paths.userByName + username
    When method get
    Then status 404
