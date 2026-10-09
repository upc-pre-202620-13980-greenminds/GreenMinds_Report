workspace "EcoMind - Contenedores" "Backend único organizado en bounded contexts." {
    model {
        visitante = person "Visitante" "Explora la información de EcoMind antes de registrarse."
        estudiante = person "Estudiante" "Aprende, participa en retos y comparte sus logros."
        padre = person "Padre de Familia" "Acompaña el progreso de sus hijos y gestiona su grupo familiar."

        resend = softwareSystem "Resend" "Servicio de correo para verificación de cuentas y recuperación de contraseña." "Externo"
        tarjeta = softwareSystem "Pasarela de Tarjeta" "Servicio externo de procesamiento de pagos con tarjeta." "Externo"
        yape = softwareSystem "Yape" "Servicio externo de pagos móviles." "Externo"
        paypal = softwareSystem "PayPal" "Servicio externo de pagos en línea." "Externo"
        mapas = softwareSystem "Proveedor de mapas" "Servicio externo que proporciona los tiles del mapa." "Externo"

        ecoMind = softwareSystem "EcoMind" "Plataforma de educación y participación ambiental." {
            landing = container "Landing Page" "Presenta EcoMind y dirige al visitante al registro en la aplicación." "Sitio web estático"
            mobile = container "EcoMind Android Application" "Permite aprender, gestionar retos, interactuar con la comunidad y realizar compras." "Kotlin / Android"
            backend = container "Backend API" "Aplicación única que integra IAM, Users, Learning, Quests, Community, Gamification y Monetization como módulos del dominio." "Java / Spring Boot / REST API"

            iamDb = container "IAM Database" "Almacena cuentas, credenciales y datos de verificación y recuperación." "MySQL" "Database"
            usersDb = container "Users Database" "Almacena perfiles, familias, amistades y personalización." "MySQL" "Database"
            learningDb = container "Learning Database" "Almacena materiales educativos, categorías, favoritos y reseñas." "MySQL" "Database"
            questsDb = container "Quests Database" "Almacena retos, actividades, progreso y sesiones colaborativas." "MySQL" "Database"
            communityDb = container "Community Database" "Almacena publicaciones, eventos y metas comunitarias." "MySQL" "Database"
            gamificationDb = container "Gamification Database" "Almacena puntos, rachas, rankings y logros." "MySQL" "Database"
            monetizationDb = container "Monetization Database" "Almacena catálogo, gemas, compras y órdenes." "MySQL" "Database"
        }

        visitante -> landing "Explora la información de EcoMind" "HTTPS"
        landing -> mobile "Dirige al registro en la aplicación" "Enlace"
        estudiante -> mobile "Aprende y participa"
        padre -> mobile "Gestiona su familia y consulta el progreso"
        mobile -> backend "Consume los endpoints de la plataforma" "HTTPS / JSON / Bearer JWT"
        mobile -> mapas "Obtiene tiles para mostrar eventos en el mapa" "HTTPS"

        backend -> iamDb "Lee y escribe datos de identidad" "SQL / JDBC"
        backend -> usersDb "Lee y escribe datos de usuarios" "SQL / JDBC"
        backend -> learningDb "Lee y escribe datos de aprendizaje" "SQL / JDBC"
        backend -> questsDb "Lee y escribe datos de retos" "SQL / JDBC"
        backend -> communityDb "Lee y escribe datos de comunidad" "SQL / JDBC"
        backend -> gamificationDb "Lee y escribe datos de gamificación" "SQL / JDBC"
        backend -> monetizationDb "Lee y escribe datos de compras" "SQL / JDBC"
        backend -> resend "Envía correos de verificación y recuperación" "HTTPS / API"
        backend -> tarjeta "Procesa pagos con tarjeta" "HTTPS / API"
        backend -> yape "Procesa pagos móviles" "HTTPS / API"
        backend -> paypal "Procesa pagos en línea" "HTTPS / API"
    }

    views {
        container ecoMind "EcoMindContainers" {
            include *
            autoLayout tb 180 100
            title "EcoMind - Diagrama de contenedores"
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
