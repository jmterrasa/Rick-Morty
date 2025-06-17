# Rick & Morty App

Aplicación SwiftUI que consume la [Rick and Morty API](https://rickandmortyapi.com/) para mostrar personajes y detalles. Soporta búsqueda, paginación, favoritos y vista en detalle animada.

## Funcionalidades

- MVVM
- Coordinator
- PoP (Protocol Oriented Programming)
- Concurrency
- Búsqueda por nombre con debounce
- Paginación al hacer scroll
- Prefetching
- Gestión de favoritos con persistencia local (SwiftData)
- FavoritesView usa List con .onDelete para swipe y eliminación.
- Caché de imágenes para mejor rendimiento
- Localización de textos con SwiftGen + YAML

## Unit Tests

- "MockCharacterFetcher" y "MockURLProtocol" que conforma a "CharacterFetchable".
- Se simulan respuestas JSON y errores.

## Estructura

RickAndMortyApp/
├── Models/              # Modelos decodificables de la API
├── Networking/          # Servicios y protocolo para fetch
├── ViewModels/          # Lógica de presentación
├── Views/               # SwiftUI Views (List, Detail, Row…)
├── Resources/           # Archivos YAML, imágenes, etc.
├── Extensions/          # Utilidades varias
└── SupportingFiles/     # Entrada principal y config SwiftData

## Dependencias

- SwiftUI
- SwiftData
- SwiftGen (para L10n)
- async/await
- URLCache personalizado para CachedImageView

## Cómo

1. Clona el repositorio.
2. Asegúrate de tener Xcode 15+.
3. Ejecuta "swiftgen" en la raíz del proyecto en el terminal.
4. Ejecuta el proyecto en simulador o dispositivo real.

## Localización

Toda la interfaz soporta localización usando "SwiftGen". Para añadir nuevas traducciones, edita el archivo "strings.yml" y vuelve a ejecutar "swiftgen".

## Autor

Jaime Jesús Martínez Terrasa

---
