workspace "EcoMind - Contenedores" "Backend único organizado en bounded contexts." {
    model {
        visitante = person "Visitante" "Explora la información de EcoMind antes de registrarse."
        estudiante = person "Estudiante" "Aprende, participa en retos y comparte sus logros."
        padre = person "Padre de Familia" "Acompaña el progreso de sus hijos y gestiona su grupo familiar."

        correo = softwareSystem "Azure Communication Services Email" "Servicio de correo para verificación de cuentas y recuperación de contraseña." "Externo"
        tarjeta = softwareSystem "Pasarela de Tarjeta" "Servicio externo de procesamiento de pagos con tarjeta." "Externo"
        yape = softwareSystem "Yape" "Plataforma externa de pagos móviles." "Externo"
        paypal = softwareSystem "PayPal" "Servicio externo de pagos en línea." "Externo"
        mapas = softwareSystem "OpenStreetMap" "Servicio externo que proporciona los tiles del mapa." "Externo"

        ecoMind = softwareSystem "EcoMind" "Plataforma móvil de educación ambiental gamificada para estudiantes y familias." "MainSystem" {
            landing = container "Landing Page" "Presenta EcoMind y dirige al visitante al registro en la aplicación." "Sitio web estático"
            mobile = container "EcoMind Android Application" "Permite aprender, gestionar retos, interactuar con la comunidad y realizar compras." "Kotlin / Android"
            flutter = container "EcoMind Flutter Application" "Permite aprender, gestionar retos, interactuar con la comunidad y realizar compras." "Flutter / Dart"
            backend = container "Backend API" "Aplicación única que integra IAM, Users, Learning, Quests, Community, Gamification y Monetization como módulos del dominio." "Java / Spring Boot / REST API"
            db = container "EcoMind Database" "Almacena los datos de todos los módulos del Backend API." "PostgreSQL" "Database"
        }

        estudiante -> ecoMind "Usa la plataforma"
        padre -> ecoMind "Usa la plataforma"
        visitante -> ecoMind "Explora información de EcoMind"
        ecoMind -> mapas "Obtiene tiles del mapa para eventos comunitarios cercanos"
        ecoMind -> correo "Envía correos de verificación y recuperación"
        ecoMind -> tarjeta "Procesa pagos con tarjeta"
        ecoMind -> yape "Procesa pagos con Yape"
        ecoMind -> paypal "Procesa pagos con PayPal"

        visitante -> landing "Explora la información de EcoMind" "HTTPS"
        landing -> mobile "Dirige al registro en la aplicación" "Enlace"
        estudiante -> mobile "Aprende y participa"
        padre -> mobile "Gestiona su familia y consulta el progreso"
        landing -> flutter "Dirige al registro en la aplicación" "Enlace"
        estudiante -> flutter "Aprende y participa"
        padre -> flutter "Gestiona su familia y consulta el progreso"
        flutter -> backend "Consume los endpoints de la plataforma" "HTTPS / JSON / Bearer JWT"
        mobile -> backend "Consume los endpoints de la plataforma" "HTTPS / JSON / Bearer JWT"
        mobile -> mapas "Obtiene tiles para mostrar eventos en el mapa" "HTTPS"

        backend -> db "Lee y escribe los datos de los módulos" "SQL / JDBC"
        backend -> correo "Envía correos de verificación y recuperación" "HTTPS / API"
        backend -> tarjeta "Procesa pagos con tarjeta" "HTTPS / API"
        backend -> yape "Procesa pagos móviles" "HTTPS / API"
        backend -> paypal "Procesa pagos en línea" "HTTPS / API"

        deploymentEnvironment "Produccion" {
            deploymentNode "Dispositivo Android" "Dispositivo del usuario" "Android" {
                containerInstance mobile
            }
            deploymentNode "Dispositivo móvil Flutter" "Dispositivo del usuario" "Flutter" {
                containerInstance flutter
            }
            deploymentNode "GitHub Pages" "Publicación del sitio estático" "GitHub Pages" {
                containerInstance landing
            }
            deploymentNode "Azure" "Infraestructura de EcoMind" "Microsoft Azure" {
                deploymentNode "West US 2" "Servicios de aplicación y datos" "Azure" {
                    deploymentNode "Azure Container Apps" "Servicio web del Backend API" "Azure Container Apps" {
                        apiInstance = containerInstance backend
                    }
                    deploymentNode "Azure Database for PostgreSQL" "Base de datos privada de EcoMind" "Flexible Server" {
                        containerInstance db
                    }
                    vault = infrastructureNode "Azure Key Vault" "Configuración de secretos" "Azure Key Vault"
                    logs = infrastructureNode "Log Analytics" "Registros de la aplicación" "Azure Monitor"
                }
                deploymentNode "East US 2" "Registro de imágenes" "Azure" {
                    registry = infrastructureNode "Azure Container Registry" "Imágenes del Backend API" "Azure Container Registry"
                }
                deploymentNode "Europa" "Correo transaccional" "Azure" {
                    softwareSystemInstance correo
                }
            }
            registry -> apiInstance "Suministra la imagen" "AcrPull"
            vault -> apiInstance "Configura secretos" "ARM"
            apiInstance -> logs "Envía registros"
        }
    }

    views {
        systemContext ecoMind "EcoMindContext" {
            include *
            autoLayout lr 180 100
            title "System Context View: EcoMind"
        }

        container ecoMind "EcoMindContainers" {
            include *
            autoLayout tb 180 100
            title "EcoMind - Diagrama de contenedores"
        }

        deployment ecoMind "Produccion" "EcoMindDeployment" {
            include *
            autoLayout lr 180 100
            title "EcoMind - Diagrama de despliegue"
        }

        styles {
            element "Element" {
                color #ffffff
            }
            element "Person" {
                shape Person
                background #6b21a8
            }
            element "Software System" {
                background #334155
            }
            element "MainSystem" {
                background #be185d
            }
            element "Container" {
                background #947600
            }
            element "Database" {
                shape Cylinder
                background #b91c1c
            }
            element "Externo" {
                background #be185d
            }
        }
    }
}