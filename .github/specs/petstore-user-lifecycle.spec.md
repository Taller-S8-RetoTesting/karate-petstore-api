# Spec: petstore-user-lifecycle

| Campo       | Valor                                      |
|-------------|--------------------------------------------|
| **status**  | `IMPLEMENTED`                              |
| **dominio** | `petstore`                                 |
| **feature** | `petstore-user-lifecycle`                  |
| **API**     | `https://petstore.swagger.io/v2`           |
| **recurso** | `/user`                                    |
| **auth**    | No requerida (API pública)                 |
| **env**     | `qa` (default)                             |

---

## Descripción

CRUD completo del recurso `/user` en Petstore v2: crear, consultar, actualizar, consultar actualización, eliminar y verificar eliminación. El flujo es secuencial — cada escenario depende del anterior.

---

## Endpoints involucrados

| Método   | Path               | Descripción               |
|----------|--------------------|---------------------------|
| `POST`   | `/user`            | Crear usuario             |
| `GET`    | `/user/{username}` | Consultar usuario         |
| `PUT`    | `/user/{username}` | Actualizar usuario        |
| `DELETE` | `/user/{username}` | Eliminar usuario          |

---

## karate-config.js — cambios requeridos

Agregar al objeto `config` las propiedades de URL base y paths del dominio `petstore`:

```javascript
config.baseUrl = config.baseUrl; // ya existente, se reutiliza si aplica

config.petstore = {
  baseUrl: 'https://petstore.swagger.io/v2',
  paths: {
    user:         '/user',
    userByName:   '/user/'
  }
};
```

En el feature, los paths se consumen como `petstore.baseUrl + petstore.paths.user` y `petstore.baseUrl + petstore.paths.userByName + username`. **Nunca hardcodear URLs en el .feature.**

---

## Escenarios

### 1. Crear usuario

| Campo       | Valor                                                              |
|-------------|--------------------------------------------------------------------|
| **tags**    | `@smoke @regression`                                               |
| **método**  | `POST`                                                             |
| **path**    | `petstore.paths.user`                                              |
| **payload** | `data/petstore/user-lifecycle/create-user.json`                    |
| **status**  | `200`                                                              |

```gherkin
@smoke @regression
Scenario: Crear usuario con datos de prueba controlados
  Given url petstore.baseUrl
  And path petstore.paths.user
  And request read('classpath:data/petstore/user-lifecycle/create-user.json')
  When method post
  Then status 200
  And match response.code == 200
  And match response.type == 'unknown'
  And match response.message == '#string'
```

---

### 2. Consultar usuario creado

| Campo       | Valor                                                              |
|-------------|--------------------------------------------------------------------|
| **tags**    | `@smoke @regression`                                               |
| **método**  | `GET`                                                              |
| **path**    | `petstore.paths.userByName + username`                             |
| **status**  | `200`                                                              |

```gherkin
@smoke @regression
Scenario: Consultar usuario recién creado y validar persistencia
  Given url petstore.baseUrl
  And path petstore.paths.userByName + username
  When method get
  Then status 200
  And match response.username == createPayload.username
  And match response.firstName == createPayload.firstName
  And match response.lastName == createPayload.lastName
  And match response.email == createPayload.email
```

> `createPayload` se lee del mismo data file `create-user.json` para comparar los valores esperados.

---

### 3. Actualizar usuario

| Campo       | Valor                                                              |
|-------------|--------------------------------------------------------------------|
| **tags**    | `@regression`                                                      |
| **método**  | `PUT`                                                              |
| **path**    | `petstore.paths.userByName + username`                             |
| **payload** | `data/petstore/user-lifecycle/update-user.json`                    |
| **status**  | `200`                                                              |

```gherkin
@regression
Scenario: Actualizar firstName, lastName y email del usuario
  Given url petstore.baseUrl
  And path petstore.paths.userByName + username
  And request read('classpath:data/petstore/user-lifecycle/update-user.json')
  When method put
  Then status 200
  And match response.code == 200
```

---

### 4. Consultar usuario actualizado

| Campo       | Valor                                                              |
|-------------|--------------------------------------------------------------------|
| **tags**    | `@regression`                                                      |
| **método**  | `GET`                                                              |
| **path**    | `petstore.paths.userByName + username`                             |
| **status**  | `200`                                                              |

```gherkin
@regression
Scenario: Consultar usuario y validar campos actualizados
  Given url petstore.baseUrl
  And path petstore.paths.userByName + username
  When method get
  Then status 200
  And match response.firstName == updatePayload.firstName
  And match response.lastName == updatePayload.lastName
  And match response.email == updatePayload.email
```

> `updatePayload` se lee del data file `update-user.json` para comparar valores esperados.

---

### 5. Eliminar usuario

| Campo       | Valor                                                              |
|-------------|--------------------------------------------------------------------|
| **tags**    | `@regression`                                                      |
| **método**  | `DELETE`                                                           |
| **path**    | `petstore.paths.userByName + username`                             |
| **status**  | `200`                                                              |

```gherkin
@regression
Scenario: Eliminar usuario por username
  Given url petstore.baseUrl
  And path petstore.paths.userByName + username
  When method delete
  Then status 200
  And match response.code == 200
```

---

### 6. Verificar eliminación

| Campo       | Valor                                                              |
|-------------|--------------------------------------------------------------------|
| **tags**    | `@negative @regression`                                            |
| **método**  | `GET`                                                              |
| **path**    | `petstore.paths.userByName + username`                             |
| **status**  | `404`                                                              |

```gherkin
@negative @regression
Scenario: Verificar que GET al usuario eliminado retorna 404
  Given url petstore.baseUrl
  And path petstore.paths.userByName + username
  When method get
  Then status 404
```

---

## Artefactos a crear

### Feature y Runner

| Archivo                                                         | Tipo    |
|-----------------------------------------------------------------|---------|
| `src/test/java/template/petstore/petstore-user-lifecycle.feature` | Feature |
| `src/test/java/template/petstore/PetstoreRunner.java`           | Runner  |

### Data files

| Archivo                                                                | Descripción                                |
|------------------------------------------------------------------------|--------------------------------------------|
| `src/test/resources/data/petstore/user-lifecycle/create-user.json`     | Payload para POST /user                    |
| `src/test/resources/data/petstore/user-lifecycle/update-user.json`     | Payload para PUT /user/{username}          |

#### create-user.json — estructura esperada

```json
{
  "id": 0,
  "username": "karate_testuser",
  "firstName": "Karate",
  "lastName": "Tester",
  "email": "karate.tester@example.com",
  "password": "Test1234",
  "phone": "1234567890",
  "userStatus": 1
}
```

#### update-user.json — estructura esperada

```json
{
  "id": 0,
  "username": "karate_testuser",
  "firstName": "KarateUpdated",
  "lastName": "TesterUpdated",
  "email": "karate.updated@example.com",
  "password": "Test1234",
  "phone": "1234567890",
  "userStatus": 1
}
```

> El `username` debe coincidir en ambos archivos para mantener la trazabilidad del flujo.

### Schemas (opcionales reutilizables)

| Archivo                                                          | Descripción                                 |
|------------------------------------------------------------------|---------------------------------------------|
| `src/test/resources/schemas/petstore/user-response.json`         | Schema de respuesta GET /user/{username}    |
| `src/test/resources/schemas/petstore/api-response.json`          | Schema de respuesta genérica (code/type/message) |

#### user-response.json — estructura esperada

```json
{
  "id": "#number",
  "username": "#string",
  "firstName": "#string",
  "lastName": "#string",
  "email": "#string",
  "password": "#string",
  "phone": "#string",
  "userStatus": "#number"
}
```

#### api-response.json — estructura esperada

```json
{
  "code": "#number",
  "type": "#string",
  "message": "#string"
}
```

### karate-config.js

| Archivo                          | Cambio                                          |
|----------------------------------|-------------------------------------------------|
| `src/test/java/karate-config.js` | Agregar objeto `petstore` con `baseUrl` y `paths` |

---

## Runner esperado

```java
package template.petstore;

import com.intuit.karate.junit5.Karate;

class PetstoreRunner {

    @Karate.Test
    Karate runDomain() {
        return Karate.run().relativeTo(getClass())
                .tags("~@wip");
    }
}
```

---

## Notas de implementación

- **Flujo secuencial**: los escenarios se ejecutan en orden dentro de un único feature file. Usar `Background` para leer data files y configurar variables compartidas (`username`, payloads).
- **Auth**: no requerida. No invocar helpers de auth para este dominio.
- **Payloads**: siempre desde archivos JSON en `data/`, nunca inline.
- **Paths**: consumidos desde `karate-config.js` → `petstore.baseUrl` y `petstore.paths.*`.
- **Schemas**: validaciones de contrato opcionales con `match response == read('classpath:schemas/petstore/...')` si se desea reforzar `@contract`.
- **Helpers existentes**: reutilizar `common.js` si se necesitan utilidades (`notBlank`, etc.).

---

## Definition of Ready

- [x] Dominio identificado: `petstore`
- [x] Flujo identificado: user lifecycle (CRUD completo)
- [x] Criterios felices: crear, consultar, actualizar, consultar actualización, eliminar
- [x] Criterios de error: verificar 404 post-eliminación
- [x] Auth conocida: no requerida (API pública)
- [x] Datos y restricciones descritos: payloads controlados desde JSON files
- [x] Tags asignados por escenario
- [x] Artefactos listados: feature, runner, data files, schemas, config changes

---

## Ejecución esperada

```bash
# Todos los tests del dominio
./mvnw test -Dtest=PetstoreRunner

# Solo smoke
./mvnw test -Dtest=PetstoreRunner -Dkarate.options="--tags @smoke"

# Solo regression
./mvnw test -Dtest=PetstoreRunner -Dkarate.options="--tags @regression"

# Solo negativos
./mvnw test -Dtest=PetstoreRunner -Dkarate.options="--tags @negative"
```
