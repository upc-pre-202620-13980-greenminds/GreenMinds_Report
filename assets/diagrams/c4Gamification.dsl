workspace "EcoMind - Gamification Component Diagrams" "Gamification components aligned with Quests and Monetization." {
    !impliedRelationships false
    model {
        user = person "EcoMind User" "Consulta progreso, logros y rankings; solicita compartir un logro."
        ecoMind = softwareSystem "EcoMind" "Plataforma de educación y participación ambiental." {
            mobileApp = container "EcoMind Android Application" "Consulta el progreso y los reconocimientos del usuario." "Kotlin / Android" {
                ui = component "Gamification UI" "Displays rankings, achievement filters, celebration and optional sharing." "Jetpack Compose"
                vm = component "Gamification ViewModels" "Manages filters, sharing choice, retryable draft and publication state." "ViewModel / StateFlow"
                useCases = component "Gamification Use Cases" "Queries rankings and awards; reads shared community posts; requests voluntary sharing." "Kotlin"
                weeklyRanking = component "Weekly Ranking Calculator" "Filters period transactions and calculates weekly positions (TS-007)." "Kotlin"
                mobileRepo = component "Gamification Repository Implementation" "Coordinates remote queries and maps results." "Kotlin"
                mappers = component "Gamification Data Mappers" "Transforms network DTOs into mobile models." "Kotlin"
                remote = component "Gamification Remote Data Source" "Consumes Gamification REST resources." "Retrofit / HTTPS"
                communityGateway = component "Community Feature Gateway" "Reads and filters shared achievement posts owned by Community (HU-038)." "Kotlin / Community API"
            }
            backend = container "EcoMind API" "Backend que contiene los bounded contexts de EcoMind." "Java / Spring Boot" {
                group "Gamification" {
                    rest = component "REST Controllers" "Expone progreso, logros, rankings y solicitudes de compartir." "Spring REST" "Interface"
                    consumers = component "Event Handlers" "Procesa finalizaciones, participación y respuestas de integración." "Spring Event Listeners / Adapters" "Interface"
                    services = component "Application Services" "Coordina recompensas, rachas, logros y solicitudes de compartir." "Spring Services" "Application"
                    daily = component "Daily Streak Lifecycle Service" "Evalúa el cierre diario de las rachas activas." "Spring Scheduler" "Application"
                    domain = component "Domain Model" "Define progreso, recompensas, logros, rachas y sus reglas." "Java / DDD" "Domain"
                    persistence = component "Persistence Adapters" "Implementa los repositorios de progreso, recompensas, logros y solicitudes." "Spring Data JPA" "Infrastructure"
                    clients = component "Context Service Clients" "Adapta consultas y operaciones de los contextos colaboradores." "Java / ACL" "Infrastructure"
                    publisher = component "Event Publisher" "Entrega recompensas, avisos de logro y solicitudes de protección y publicación." "Spring Events / Transactional Outbox" "Infrastructure"
                }
                quests = component "Quests Bounded Context" "Valida misiones y comunica sus finalizaciones." "Java / Spring Boot" "BoundedContext"
                users = component "Users Bounded Context" "Administra perfiles, amistades, familias y roles." "Java / Spring Boot" "BoundedContext"
                community = component "Community Bounded Context" "Administra comunidades, participación y publicaciones." "Java / Spring Boot" "BoundedContext"
                monetization = component "Monetization Bounded Context" "Administra gemas, cosméticos, multiplicadores y protectores." "Java / Spring Boot" "BoundedContext"
            }
            database = container "Gamification Database" "Almacena progreso, recompensas, logros, solicitudes y outbox." "MySQL / Logical schema" "Database"
        }
        user -> ui "Uses"
        ui -> vm "Sends actions and observes state"
        vm -> useCases "Invokes"
        useCases -> weeklyRanking "Calculates weekly positions"
        useCases -> mobileRepo "Uses repository contract"
        useCases -> communityGateway "Queries shared achievements" "Kotlin call"
        communityGateway -> backend "Uses Community publications API" "HTTPS / JSON"
        mobileRepo -> mappers "Maps data"
        mobileRepo -> remote "Queries or requests sharing"
        remote -> backend "Uses Gamification API" "HTTPS / JSON"
        mobileApp -> rest "Uses" "HTTPS / JSON"
        mobileApp -> community "Reads shared achievement posts" "HTTPS / JSON" {
            tags "IntegrationDetail"
        }
        rest -> services "Dispatches commands and queries"
        quests -> consumers "Publishes completion events" "Spring Application Events"
        community -> consumers "Reports participation; proposed correlated publication reply" {
            tags "IntegrationDetail"
        }
        monetization -> consumers "Confirms protection or unavailability" {
            tags "IntegrationDetail"
        }
        consumers -> services "Invokes commands"
        daily -> services "Evaluates daily streaks"
        services -> domain "Uses domain rules"
        services -> persistence "Loads and persists"
        services -> clients "Uses context contracts"
        services -> publisher "Publishes integration events"
        clients -> users "Queries users, friendships and families"
        clients -> quests "Queries base rewards and attempts" {
            tags "IntegrationDetail"
        }
        clients -> community "Checks membership and sharing access" {
            tags "IntegrationDetail"
        }
        clients -> monetization "Queries active XP factor; grants cosmetic reward" {
            tags "IntegrationDetail"
        }
        publisher -> monetization "Sends rewards and protection requests"
        publisher -> clients "Delivers queued cosmetic grant" {
            tags "IntegrationDetail"
        }
        publisher -> community "Sends award notices and sharing requests"
        persistence -> database "Reads and writes" "JPA / JDBC"
        publisher -> database "Persists pending messages" "JPA / JDBC" {
            tags "IntegrationDetail"
        }
    }
    views {
        component mobileApp "GamificationMobileComponentDiagram" "Gamification - Android components" {
            include user ui vm useCases weeklyRanking mobileRepo mappers remote communityGateway backend
            autoLayout lr
        }
        component backend "GamificationBackendComponentDiagram" "Gamification - Backend component overview" {
            include mobileApp rest consumers services daily domain persistence clients publisher quests users community monetization database
            // The overview shows the main dependencies. All exchanges remain in the model.
            exclude "relationship.tag==IntegrationDetail"
            autoLayout tb
        }
        styles {
            element "Element" {
                fontSize 22
            }
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Component" {
                background #ffffff
                color #000000
            }
            element "Interface" {
                background #7fb3e6
            }
            element "Application" {
                background #7fb3e6
            }
            element "Domain" {
                background #7fb3e6
            }
            element "Infrastructure" {
                background #7fb3e6
            }
            element "BoundedContext" {
                background #1f70bf
                color #ffffff
            }
            element "Database" {
                shape cylinder
            }
            element "Group" {
                color #438dd5
            }
        }
    }
}
