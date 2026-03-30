# README - Ejecución del ejercicio API con Karate

## Objetivo

Este proyecto automatiza el flujo del ejercicio API del taller sobre `https://petstore.swagger.io/v2`, cubriendo la gestión del recurso `user` con Karate.

El flujo implementado valida:

- Creación de usuario
- Consulta del usuario creado
- Actualización de datos del usuario
- Consulta del usuario actualizado
- Eliminación del usuario
- Verificación de eliminación

## Tecnologías utilizadas

- Java target: 17
- Maven Wrapper
- Karate: 1.5.2

## Prerrequisitos

1. Tener Java instalado y disponible en `PATH`.
2. Tener acceso a internet, ya que la suite consume la API pública de Petstore Swagger.
3. Ejecutar los comandos desde la raíz del proyecto.

## Estructura relevante

- `src/test/java/karate-config.js` — configuración global y paths del dominio `petstore`
- `src/test/java/template/petstore/PetstoreRunner.java` — runner del dominio
- `src/test/java/template/petstore/petstore-user-lifecycle.feature` — feature del flujo completo
- `src/test/resources/data/petstore/user-lifecycle/` — payloads de creación y actualización
- `src/test/resources/schemas/petstore/` — schemas de contrato para validación de respuestas

## Pasos de ejecución

### Windows

1. Abrir una terminal en la raíz del proyecto.
2. Ejecutar:

```powershell
.\mvnw.cmd test
```

### Linux o macOS

1. Abrir una terminal en la raíz del proyecto.
2. Ejecutar:

```bash
./mvnw test
```

## Ejecuciones opcionales

Ejecutar usando explícitamente el ambiente `qa`:

```powershell
.\mvnw.cmd test -Dkarate.env=qa
```

Ejecutar solo escenarios etiquetados como `@smoke`:

```powershell
.\mvnw.cmd test -Dkarate.options="--tags @smoke"
```

## Resultado esperado

La ejecución debe finalizar sin errores y generar reportes Karate y Surefire en la carpeta `target/`.

Ubicaciones útiles:

- `target/karate-reports/karate-summary.html`
- `target/surefire-reports/TEST-template.petstore.PetstoreRunner.xml`

## Consideraciones del ejercicio

- La solución se construyó apoyándose en un template base de Karate y en un flujo ASDD para acelerar la generación de artefactos.
- La automatización final es reproducible con Maven Wrapper y no requiere configuración de autenticación.
- La feature modela el flujo completo en un solo escenario secuencial. Esto es intencional: en Karate, los `Scenario` de un mismo feature no comparten estado entre sí, por lo que un flujo lifecycle donde cada paso depende del anterior (crear → consultar → actualizar → eliminar) debe ejecutarse como un único escenario.
- Las respuestas de la API se validan con schemas de contrato (`api-response.json`, `user-response.json`), lo que agrega verificación estructural además de la funcional.
