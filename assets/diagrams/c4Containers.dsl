workspace "EcoMind - Contenedores" "Backend único organizado en bounded contexts." {
    model {
        visitante = person "Visitante" "Explora la información de EcoMind antes de registrarse."
        estudiante = person "Estudiante" "Aprende, participa en retos y comparte sus logros."
        padre = person "Padre de Familia" "Acompaña el progreso de sus hijos y gestiona su grupo familiar."

        resend = softwareSystem "Resend" "Servicio de correo para verificación de cuentas y recuperación de contraseña." "Externo"
        tarjeta = softwareSystem "Pasarela de Tarjeta" "Servicio externo de procesamiento de pagos con tarjeta." "Externo"
        yape = softwareSystem "Yape" "Plataforma externa de pagos móviles." "Externo"
        paypal = softwareSystem "PayPal" "Servicio externo de pagos en línea." "Externo"
        mapas = softwareSystem "Leaflet" "Servicio externo que proporciona los tiles del mapa." "Externo"

        ecoMind = softwareSystem "EcoMind" "Plataforma de educación y participación ambiental." {
            landing = container "Landing Page" "Presenta EcoMind y dirige al visitante al registro en la aplicación." "Sitio web estático"
            mobile = container "EcoMind Android Application" "Permite aprender, gestionar retos, interactuar con la comunidad y realizar compras." "Kotlin / Android"
            backend = container "Backend API" "Aplicación única que integra IAM, Users, Learning, Quests, Community, Gamification y Monetization como módulos del dominio." "Java / Spring Boot / REST API"
            db = container "EcoMind Database" "Almacena los datos de todos los módulos del Backend API." "PostgreSQL" "Database"
        }

        visitante -> landing "Explora la información de EcoMind" "HTTPS"
        landing -> mobile "Dirige al registro en la aplicación" "Enlace"
        estudiante -> mobile "Aprende y participa"
        padre -> mobile "Gestiona su familia y consulta el progreso"
        mobile -> backend "Consume los endpoints de la plataforma" "HTTPS / JSON / Bearer JWT"
        mobile -> mapas "Obtiene tiles para mostrar eventos en el mapa" "HTTPS"

        backend -> db "Lee y escribe los datos de los módulos" "SQL / JDBC"
        backend -> resend "Envía correos de verificación y recuperación" "HTTPS / API"
        backend -> tarjeta "Procesa pagos con tarjeta" "HTTPS / API"
        backend -> yape "Procesa pagos móviles" "HTTPS / API"
        backend -> paypal "Procesa pagos en línea" "HTTPS / API"

        deploymentEnvironment "Produccion" {
            deploymentNode "Dispositivo Android" "Dispositivo del usuario" "Android" {
                containerInstance mobile
            }
            deploymentNode "GitHub Pages" "Publicación del sitio estático" "GitHub Pages" {
                containerInstance landing
            }
            deploymentNode "Render" "Plataforma de despliegue del backend" "Render" {
                deploymentNode "Servicio web" "Servicio web del Backend API" "Java 21 / Spring Boot" {
                    containerInstance backend
                }
            }
            deploymentNode "Servidor de base de datos" "Base de datos de EcoMind" "PostgreSQL" {
                containerInstance db
            }
        }
    }

    views {
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