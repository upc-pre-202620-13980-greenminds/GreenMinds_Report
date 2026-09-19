workspace "EcoMind - IAM Component Diagrams" {

    model {
        user = person "EcoMind User" {
            description "Usuario que registra una cuenta, inicia sesión y accede a recursos protegidos."
        }

        ecoMind = softwareSystem "EcoMind" {
            description "Plataforma móvil de educación y participación ambiental."

            mobileApp = container "EcoMind Android Application" {
                description "Aplicación móvil desde la cual el usuario se registra, inicia sesión y consume recursos protegidos."
                technology "Kotlin / Android"
                tags "MobileApp"

                iamUi = component "IAM UI" {
                    description "Muestra las pantallas de registro, verificación, inicio de sesión y recuperación de contraseña."
                    technology "Jetpack Compose"
                    tags "Mobile UI"
                }

                iamViewModels = component "IAM ViewModels" {
                    description "Procesa las acciones de la interfaz y expone el estado de autenticación."
                    technology "Android ViewModel / StateFlow"
                    tags "Mobile Presentation"
                }

                iamUseCases = component "IAM Use Cases" {
                    description "Coordina el registro, la verificación, el inicio de sesión, la recuperación y el cierre de sesión."
                    technology "Kotlin"
                    tags "Mobile Application"
                }

                iamRepository = component "IAM Repository" {
                    description "Coordina las operaciones remotas de IAM y la administración local de la sesión."
                    technology "Kotlin"
                    tags "Mobile Application"
                }

                iamRemoteDataSource = component "IAM Remote Data Source" {
                    description "Consume los endpoints REST de IAM e incorpora el JWT en las solicitudes protegidas."
                    technology "Retrofit / OkHttp"
                    tags "Mobile Infrastructure"
                }

                secureTokenStorage = component "Secure Token Storage" {
                    description "Guarda el access token de forma protegida y lo elimina durante el cierre de sesión."
                    technology "Android Keystore-backed Storage"
                    tags "Mobile Infrastructure"
                }
            }

            iamApi = container "IAM API" {
                description "Administra cuentas, credenciales, autenticación, access tokens y recuperación de contraseña."
                technology "Java / Spring Boot"

                restControllers = component "REST Controllers" {
                    description "Expone las operaciones de registro, verificación, inicio de sesión, usuario autenticado, recuperación de contraseña y cierre de sesión."
                    technology "Spring REST"
                    tags "Interface"
                }

                authenticationSecurity = component "Authentication & JWT Security" {
                    description "Protege endpoints, verifica contraseñas, emite JWT y valida su firma y expiración."
                    technology "Spring Security / BCrypt / JJWT"
                    tags "Security"
                }

                applicationServices = component "Application Services" {
                    description "Coordina commands, queries y transacciones de los casos de uso de IAM."
                    technology "Spring Services"
                    tags "Application"
                }

                domainModel = component "Domain Model" {
                    description "Contiene las reglas de registro pendiente, verificación, cuentas, credenciales y recuperación de contraseña."
                    technology "Java / DDD"
                    tags "Domain"
                }

                persistenceAdapters = component "Persistence Adapters" {
                    description "Implementa los repositories de registros pendientes, cuentas, credenciales y tokens de recuperación."
                    technology "Spring Data JPA"
                    tags "Infrastructure"
                }

                emailServiceAdapter = component "Email Service Adapter" {
                    description "Envía correos de verificación y recuperación de contraseña mediante Resend."
                    technology "Resend API Client"
                    tags "Infrastructure"
                }

                usersContextClient = component "Users Context Client" {
                    description "Envía el command CreateProfile después de crear correctamente una cuenta."
                    technology "Internal Synchronous Client"
                    tags "Infrastructure"
                }
            }

            usersApi = container "Users Bounded Context" {
                description "Administra perfiles, preferencias, amistades, familias y roles sociales."
                technology "Java / Spring Boot"
                tags "BoundedContext"
            }

            iamDatabase = container "IAM Database" {
                description "Almacena registros pendientes, cuentas, credenciales y hashes de tokens de recuperación."
                technology "MySQL"
                tags "Database"
            }
        }

        resend = softwareSystem "Resend" {
            description "Servicio externo utilizado para enviar correos de verificación y recuperación."
            tags "ExternalSystem"
        }

        // Uso general

        user -> mobileApp "Uses"

        // Aplicación Android

        user -> iamUi "Uses"

        iamUi -> iamViewModels "Sends UI actions and observes state"

        iamViewModels -> iamUseCases "Invokes"

        iamUseCases -> iamRepository "Uses"

        iamRepository -> iamRemoteDataSource "Requests remote IAM operations"

        iamRepository -> secureTokenStorage "Stores and deletes the access token"

        iamRemoteDataSource -> secureTokenStorage "Reads the token for protected requests"

        iamRemoteDataSource -> iamApi "Consumes IAM endpoints" "HTTPS / JSON / Bearer JWT"

        // Entrada al IAM API

        mobileApp -> restControllers "Registration, verification, sign-in and password recovery" "HTTPS / JSON"

        mobileApp -> authenticationSecurity "Protected request + JWT" "HTTPS / Bearer JWT"

        // Componentes internos del IAM API

        authenticationSecurity -> restControllers "Forwards authenticated requests"

        restControllers -> applicationServices "Dispatches commands and queries"

        applicationServices -> authenticationSecurity "Verifies credentials and requests access tokens"

        applicationServices -> domainModel "Applies business rules"

        applicationServices -> persistenceAdapters "Loads and persists IAM data"

        applicationServices -> emailServiceAdapter "Requests email delivery"

        applicationServices -> usersContextClient "Requests profile creation"

        persistenceAdapters -> iamDatabase "Reads from and writes to" "JPA / JDBC"

        emailServiceAdapter -> resend "Sends verification and recovery emails" "HTTPS / JSON"

        usersContextClient -> usersApi "Sends CreateProfile command" "Internal synchronous call"
    }

    views {
        component iamApi "IamBackendComponentDiagram" {
            include mobileApp
            include restControllers
            include authenticationSecurity
            include applicationServices
            include domainModel
            include persistenceAdapters
            include emailServiceAdapter
            include usersContextClient
            include usersApi
            include iamDatabase
            include resend

            autoLayout tb
        }

        component mobileApp "IamAndroidComponentDiagram" {
            include user
            include iamUi
            include iamViewModels
            include iamUseCases
            include iamRepository
            include iamRemoteDataSource
            include secureTokenStorage
            include iamApi

            autoLayout lr
        }

        styles {
            element "Person" {
                shape Person
                background #08427b
                color #ffffff
            }

            element "MobileApp" {
                shape MobileDevicePortrait
                background #438dd5
                color #ffffff
            }

            element "Container" {
                background #438dd5
                color #ffffff
            }

            element "Interface" {
                shape Component
                background #7fb3e6
                color #000000
            }

            element "Application" {
                shape Component
                background #7fb3e6
                color #000000
            }

            element "Domain" {
                shape Component
                background #7fb3e6
                color #000000
            }

            element "Infrastructure" {
                shape Component
                background #7fb3e6
                color #000000
            }

            element "Security" {
                shape Component
                background #f4b183
                color #000000
            }

            element "Mobile UI" {
                shape Component
                background #4a90d9
                color #ffffff
            }

            element "Mobile Presentation" {
                shape Component
                background #6fa8dc
                color #000000
            }

            element "Mobile Application" {
                shape Component
                background #93c47d
                color #000000
            }

            element "Mobile Infrastructure" {
                shape Component
                background #8e7cc3
                color #ffffff
            }

            element "BoundedContext" {
                background #1f70bf
                color #ffffff
            }

            element "Database" {
                shape Cylinder
                background #438dd5
                color #ffffff
            }

            element "ExternalSystem" {
                background #999999
                color #ffffff
            }
        }
    }
}