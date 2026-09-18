workspace "EcoMind - Quests Component Diagram" {

    model {
        user = person "EcoMind User" {
            description "Usuario que consulta, inicia y completa misiones."
        }

        ecoMind = softwareSystem "EcoMind" {
            description "Plataforma de educación y participación ambiental."

            mobileApp = container "EcoMind Android Application" "Aplicación móvil para consultar, iniciar y completar misiones." "Kotlin / Android" {
                questsUi = component "Quests UI" "Displays the quest catalog, details, progress, minigames and collaborative quests." "Jetpack Compose"

                questsViewModels = component "Quests ViewModels" "Receives UI actions and exposes immutable screen states." "Android ViewModel / StateFlow"
                
                questsUseCases = component "Quests Use Cases" "Coordinates quest discovery, enrollment, progress and completion flows." "Kotlin"
                
                questsRepository = component "Quests Repository Implementation" "Coordinates remote and local quest data sources." "Kotlin"
                
                questsMappers = component "Quest Data Mappers" "Transforms network DTOs and cached entities into domain models." "Kotlin"
                
                questsRemoteDataSource = component "Quests Remote Data Source" "Consumes the Quests REST API." "Kotlin / HTTPS"
            
                questsCache = component "Quests Local Cache" "Stores active quests and progress required for mobile use." "Room"
            }

            questsApi = container "Quests API" {
                description "Administra el catálogo, ejecución y progreso de las misiones."
                technology "Java / Spring Boot"

                restControllers = component "REST Controllers" {
                    description "Expone endpoints de catálogo, progreso, minijuegos, colaboración y planes familiares."
                    technology "Spring REST"
                    tags "Interface"
                }

                applicationServices = component "Application Services" {
                    description "Coordina commands, queries, versionado, ejecución y planes familiares."
                    technology "Spring Services"
                    tags "Application"
                }

                dailyQuestLifecycle = component "Daily Quest Lifecycle Service" {
                    description "Genera las misiones diarias y expira las ejecuciones anteriores."
                    technology "Spring Scheduler"
                    tags "Application"
                }

                eventHandlers = component "Event Handlers" {
                    description "Procesa finalizaciones de misiones, minijuegos, sesiones colaborativas y planes familiares."
                    technology "Spring Event Handlers"
                    tags "Application"
                }

                domainModel = component "Domain Model" {
                    description "Contiene misiones versionadas, actividades, ejecuciones, minijuegos, sesiones colaborativas y planes familiares."
                    technology "Java / DDD"
                    tags "Domain"
                }

                persistenceAdapters = component "Persistence Adapters" {
                    description "Implementa los repositories de catálogo, progreso, colaboración y planes familiares."
                    technology "Spring Data JPA"
                    tags "Infrastructure"
                }

                usersServiceClient = component "Users Service Client" {
                    description "Consulta usuarios, amistades, familias y roles necesarios para validar la participación."
                    technology "HTTP Client"
                    tags "Infrastructure"
                }

                questEventPublisher = component "Quest Event Publisher" {
                    description "Publica los eventos de finalización dirigidos a Gamification."
                    technology "Message Broker Client"
                    tags "Infrastructure"
                }
            }

            usersApi = container "Users Bounded Context" {
                description "Administra perfiles, preferencias, amistades, familias y roles sociales."
                technology "Java / Spring Boot"
                tags "BoundedContext"
            }

            gamificationApi = container "Gamification Bounded Context" {
                description "Asigna ecopoints, actualiza rankings, rachas y logros."
                technology "Java / Spring Boot"
                tags "BoundedContext"
            }

            questsDatabase = container "Quests Database" {
                description "Almacena misiones versionadas, actividades, ejecuciones, minijuegos, sesiones y planes familiares."
                technology "MySQL"
                tags "Database"
            }
        }

        user -> mobileApp "Uses"
    

        mobileApp -> restControllers "Uses Quests capabilities" "HTTPS / JSON"

        restControllers -> applicationServices "Dispatches commands and queries"

        applicationServices -> domainModel "Uses domain rules"

        applicationServices -> persistenceAdapters "Loads and persists domain objects"

        applicationServices -> usersServiceClient "Validates users, friendships and families"

        usersServiceClient -> usersApi "Queries user information" "HTTPS / JSON"

        dailyQuestLifecycle -> domainModel "Controls the daily quest lifecycle"

        dailyQuestLifecycle -> persistenceAdapters "Loads and persists daily quests"

        applicationServices -> eventHandlers "Produces completion events"

        eventHandlers -> questEventPublisher "Publishes integration events"

        persistenceAdapters -> questsDatabase "Reads from and writes to" "JPA / JDBC"
        
        user -> questsUi "Uses"

        questsUi -> questsViewModels "Sends UI actions and observes state"
        
        questsViewModels -> questsUseCases "Invokes"
        
        questEventPublisher -> gamificationApi "Publishes completion events" "Spring Application Events"
        
        questsUseCases -> questsRepository "Uses repository contract"
        
        questsRepository -> questsMappers "Uses for data transformation"

        questsRepository -> questsRemoteDataSource "Requests remote quest data"
        
        questsRepository -> questsCache "Reads and stores local quest data"
        
        questsRemoteDataSource -> questsApi "Uses" "HTTPS / JSON"
    }

    views {
        component questsApi "QuestsBackendComponentDiagram" {
            include mobileApp
            include restControllers
            include applicationServices
            include dailyQuestLifecycle
            include eventHandlers
            include domainModel
            include persistenceAdapters
            include usersServiceClient
            include questEventPublisher
            include usersApi
            include gamificationApi
            include questsDatabase

            autoLayout tb
        }
        
        component mobileApp "QuestsMobileComponentDiagram" {
            include user
            include questsUi
            include questsViewModels
            include questsUseCases
            include questsRepository
            include questsMappers
            include questsRemoteDataSource
            include questsCache
            include questsApi
        
            autoLayout lr
        }   

        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }

            element "Container" {
                background #438dd5
                color #ffffff
            }

            element "Interface" {
                background #7fb3e6
                color #000000
            }

            element "Application" {
                background #7fb3e6
                color #000000
            }

            element "Domain" {
                background #7fb3e6
                color #000000
            }

            element "Infrastructure" {
                background #7fb3e6
                color #000000
            }

            element "BoundedContext" {
                background #1f70bf
                color #ffffff
            }

            element "Database" {
                shape cylinder
                background #438dd5
                color #ffffff
            }

            element "MessageBroker" {
                shape pipe
                background #d35400
                color #ffffff
            }
            element "Mobile UI" {
                background #4A90D9
                color #ffffff
                shape Component
            }
            
            element "Mobile Presentation" {
                background #6FA8DC
                color #000000
                shape Component
            }
            
            element "Mobile Application" {
                background #93C47D
                color #000000
                shape Component
            }
            
            element "Mobile Infrastructure" {
                background #8E7CC3
                color #ffffff
                shape Component
            }
        }
    }
}