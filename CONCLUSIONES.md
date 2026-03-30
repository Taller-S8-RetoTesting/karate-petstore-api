# Conclusiones del ejercicio API con Karate

## Hallazgos principales

- La automatización cumple el flujo funcional esperado sobre la API pública de Petstore Swagger para el recurso `user`.
- La ejecución local fue satisfactoria con `./mvnw test`, sin fallos en la suite.
- El uso de un template preconstruido con ASDD redujo el tiempo de armado del proyecto, sobre todo en estructura, baseline técnico y organización de artefactos.
- La separación entre feature, runner, data y schemas dejó una base ordenada y fácil de reproducir.
- La implementación incluye validación de contrato con schemas reutilizables (`api-response.json`, `user-response.json`), lo que agrega verificación estructural a cada respuesta de la API.

## Transparencia sobre la construcción

- Este proyecto no fue construido desde cero de manera manual; se apoyó en un template de Karate ya preparado.
- También se aprovechó un flujo ASDD para convertir el requerimiento en spec y luego en automatización ejecutable.
- Lo valioso del proceso no fue solo la velocidad, sino poder mantener consistencia técnica mientras se reducía el trabajo repetitivo.

## Lo interesante del enfoque usado

- Se pudo pasar de un requerimiento funcional a una suite ejecutable con muy poca fricción.
- La estructura generada quedó alineada con buenas prácticas del repo: dominio definido, runner por dominio, data externa y schemas reutilizables.
- La combinación de template + ASDD acelera el arranque, pero igual exige revisar el resultado final para evitar inconsistencias entre el enunciado, la spec y la implementación.

## Observaciones honestas

- El flujo automatizado cubre crear, consultar, actualizar, eliminar y verificar eliminación, implementado como un único escenario secuencial.
- Esto no es un compromiso sino una decisión de diseño: en Karate, los `Scenario` dentro de un mismo feature **no comparten estado** entre sí. Un flujo lifecycle donde cada paso depende del anterior (el DELETE necesita que el CREATE haya ocurrido) debe vivir en un solo escenario. Separarlos requeriría mecanismos como `callonce` o features auxiliares, lo cual agregaría complejidad innecesaria.
- La spec original documentaba 6 bloques Gherkin separados como referencia; la implementación los consolidó correctamente en un escenario secuencial con secciones comentadas para mantener legibilidad.

## Conclusiones finales

- El ejercicio queda reproducible, ejecutable y entendible para una revisión técnica.
- El uso de ASDD fue una ventaja real de productividad, no una excusa para bajar la calidad; aun así, el resultado final siempre necesita criterio humano.
- Si hubiera una mejora inmediata, sería agregar escenarios aislados de negativos adicionales (por ejemplo, crear usuario con payload incompleto, consultar usuario inexistente) para ampliar la cobertura más allá del happy path del lifecycle.