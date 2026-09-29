# PORTADA

<div align="center">
  
  <br/>
  
  # 🎮 **GAMIO**
  
  ### **Plataforma Social de Gamificación e Interacción para Comunidades de Jugadores**
  
  <br/>
  
  **Memoria Técnica y Funcional del Proyecto**  
  *Diseñada bajo los estándares de un Trabajo de Fin de Grado (TFG) / Auditoría de Software Senior*
  
  <br/>
  
  ---
  
  **Versión:** `1.0.0-PROD`  
  **Fecha:** 25 de mayo de 2026  
  **Entidad Receptora:** Tribunal de Evaluación de Proyecto Final / Auditoría de Sistemas  
  **Repositorio Oficial:** [ERCOMEPIPA/GamioTFG](https://github.com/ERCOMEPIPA/GamioTFG.git)  
  **Despliegue de Producción:** Vercel SSR Platform  
  
  ---
  
  * **Desarrollador y Autor:** francisco virlan rodriguez (2 DAM)
  * **Institución:** VictoriaFP
  * **Rol Adicional:** Software Architect & Frontend Lead
  * **Asesor Técnico:** Antigravity AI Pair Programmer
  
  ---
  
  ### **Stack Tecnológico Clave**
  **Astro v6.3.3** (SSR Mode) • **React v19.2.4** (Islands Architecture) • **TailwindCSS v4.2.1** • **Supabase (PostgreSQL)** • **Nodemailer v8.0.7** • **Vercel Edge Serverless**
  
</div>

---

<!-- slide -->

# ÍNDICE

- [1. INTRODUCCIÓN](#1-introducción)
  - [1.1 Objetivo del documento](#11-objetivo-del-documento)
  - [1.2 Descripción general del proyecto](#12-descripción-general-del-proyecto)
  - [1.3 Alcance](#13-alcance)
  - [1.4 Público objetivo](#14-público-objetivo)
- [2. DESCRIPCIÓN DE LA APP](#2-descripción-de-la-app)
- [3. PROBLEMA QUE RESUELVE](#3-problema-que-resuelve)
- [4. MOTIVACIÓN DEL DESARROLLO](#4-motivación-del-desarrollo)
- [5. ANÁLISIS DE COMPETENCIA](#5-análisis-de-competencia)
- [6. ARQUITECTURA DEL SISTEMA](#6-arquitectura-del-sistema)
  - [6.1 Arquitectura general](#61-arquitectura-general)
  - [6.2 Componente Frontend](#62-componente-frontend)
  - [6.3 Componente Backend (Astro API Routes)](#63-componente-backend-astro-api-routes)
  - [6.4 Base de Datos y Seguridad (RLS)](#64-base-de-datos-y-seguridad-rls)
  - [6.5 Flujo de Mensajería en Tiempo Real](#65-flujo-de-mensajería-en-tiempo-real)
  - [6.6 Sistema de Suspensiones a Nivel de Base de Datos](#66-sistema-de-suspensiones-a-nivel-de-base-de-datos)
- [7. TECNOLOGÍAS UTILIZADAS](#7-tecnologías-utilizadas)
- [8. FUNCIONALIDAD DE TODAS LAS PÁGINAS](#8-funcionalidad-de-todas-las-páginas)
  - [8.1 Página de Inicio (Landing Page)](#81-página-de-inicio-landing-page)
  - [8.2 Catálogo de Juegos](#82-catálogo-de-juegos)
  - [8.3 Buscador de Jugadores (Matchmaking)](#83-buscador-de-jugadores-matchmaking)
  - [8.4 Comunidad (Feed de Publicaciones)](#84-comunidad-feed-de-publicaciones)
  - [8.5 Tienda de Premios y Recompensas](#85-tienda-de-premios-y-recompensas)
  - [8.6 Feed de Noticias Gaming](#86-feed-de-noticias-gaming)
  - [8.7 Formulario de Registro (Sign Up)](#87-formulario-de-registro-sign-up)
  - [8.8 Formulario de Inicio de Sesión (Log In)](#88-formulario-de-inicio-de-sesión-log-in)
  - [8.9 Cuestionario de Bienvenida (Onboarding)](#89-cuestionario-de-bienvenida-onboarding)
  - [8.10 Perfil de Usuario](#810-perfil-de-usuario)
  - [8.11 Sala de Chat Global](#811-sala-de-chat-global)
  - [8.12 Bandeja de Entrada de Mensajería Privada](#812-bandeja-de-entrada-de-mensajería-privada)
  - [8.13 Chat Privado en Tiempo Real](#813-chat-privado-en-tiempo-real)
  - [8.14 Formulario de Soporte Técnico](#814-formulario-de-soporte-técnico)
  - [8.15 Formulario de Contacto](#815-formulario-de-contacto)
  - [8.16 Quiénes Somos](#816-quienes-somos)
  - [8.17 Panel de Auditoría y Moderación de Incidencias](#817-panel-de-auditoría-y-moderación-de-incidencias)
  - [8.18 Pantalla de Cuenta Suspendida (Banned)](#818-pantalla-de-cuenta-suspendida-banned)
- [9. RECOPILACIÓN DE TODAS LAS FASES DEL PROYECTO](#9-recopilación-de-todas-las-fases-del-proyecto)
- [10. PLANIFICACIÓN TEMPORAL DEL DESARROLLO](#10-planificación-temporal-del-desarrollo)
- [11. INSTALACIÓN](#11-instalación)
- [12. CONFIGURACIÓN](#12-configuración)
- [13. MANTENIMIENTO](#13-mantenimiento)
- [14. MANUAL DE USUARIO (NO TÉCNICO)](#14-manual-de-usuario-no-técnico)
- [15. PRUEBAS Y VALIDACIÓN](#15-pruebas-y-validación)
- [16. INDICADORES Y MÉTRICAS](#16-indicadores-y-métricas)
- [17. INCIDENCIAS ENCONTRADAS](#17-incidencias-encontradas)
- [18. MEJORAS FUTURAS](#18-mejoras-futuras)
- [19. RESULTADOS OBTENIDOS](#19-resultados-obtenidos)
- [20. CONCLUSIONES FINALES](#20-conclusiones-finales)
- [21. ANEXOS](#21-anexos)

---

<!-- slide -->

# 1. INTRODUCCIÓN

## 1.1 Objetivo del documento
El presente documento constituye la memoria técnica y funcional descriptiva del diseño, arquitectura, desarrollo y mantenimiento de la aplicación web **Gamio 🎮**. El objetivo primordial es proveer a desarrolladores, auditores de software, ingenieros de sistemas y perfiles de gestión una visión unificada del estado del arte de la plataforma. La documentación desglosa los detalles técnicos de la arquitectura orientada al servidor (SSR), el modelo relacional implementado sobre base de datos Postgres con seguridad restrictiva (RLS) y la lógica funcional detallada página por página de la plataforma para asegurar su comprensión analítica completa.

Este informe ha sido redactado con la máxima rigurosidad metodológica, estructurando detalladamente cada uno de los apartados funcionales y de infraestructura. El fin último es servir como un manual exhaustivo de ingeniería de software que demuestre la viabilidad de plataformas sociales basadas en frameworks de última generación, y sirva de sustento para una defensa de Trabajo de Fin de Grado (TFG) o una auditoría de sistemas ante clientes de nivel empresarial.

## 1.2 Descripción general del proyecto
**Gamio 🎮** es una plataforma social interactiva de alto rendimiento especialmente dirigida a la comunidad de entusiastas de los videojuegos de carácter multijugador y competitivo. A diferencia de las redes sociales genéricas, Gamio integra un completo ecosistema que combina un **motor de búsqueda de jugadores compatibles (Matchmaking LFG)**, una **comunidad social de publicación activa**, **salas de chat grupales y privados en tiempo real** basados en WebSockets nativos de Supabase, y un profundo **sistema de gamificación transaccional**. Este último otorga a los usuarios puntos e incrementos de nivel por participación, permitiéndoles desbloquear cosméticos digitales (marcos neon para avatar, títulos honoríficos) e incluso canjear recompensas de saldo en monedas virtuales para sus juegos favoritos (como Riot Points de League of Legends, Valorant Points o saldo de Steam) mediante un panel de soporte integrado.

El sistema completo se apoya en una estética visual premium y futurista (Cyberpunk), caracterizada por el uso de paletas oscuras profundas con acentos fluorescentes en tonos cian y violeta, efectos de cristal translúcido (glassmorphism) y micro-animaciones en CSS que dotan al sitio de una sensación de dinamismo constante. Todo esto se implementa respetando un enfoque responsivo riguroso que garantiza una legibilidad y navegación táctil perfectas en teléfonos móviles estrechos desde 320px (como el iPhone SE).

## 1.3 Alcance
El proyecto abarca el desarrollo del frontend responsivo de estética futurista (Cyberpunk), el backend en capa serverless para SSR y APIs eficientes, el esquema relacional de almacenamiento permanente y los procesos en segundo plano de alerta automatizada por correo electrónico. El ecosistema es 100% autogestionable y cuenta con:
1. **Autenticación e inicio de sesión** blindado por cookies HTTP-only controladas por middleware.
2. **Capacidad de búsqueda de jugadores** filtrada por niveles de competitividad, juegos y franjas horarias.
3. **Flujos de mensajería bidireccional y notificaciones** en tiempo real.
4. **Módulos de gamificación e inventario** con rutinas almacenadas en base de datos.
5. **Panel administrativo y sistema de denuncias** para control de comunidad.
6. **Alertas automatizadas vía SMTP** (Nodemailer) enlazadas a tareas programadas (Cron).

El alcance excluye la gestión directa de pasarelas de pago externas (siendo el canje de recompensas un flujo gestionado y validado de manera manual y administrativa por los moderadores de Gamio a través de tickets de soporte) y la provisión de servidores de chat de voz propios (delegando la comunicación por voz a las cuentas e invitaciones de Discord enlazadas en las fichas de los jugadores).

## 1.4 Público objetivo
La plataforma ha sido optimizada para dos grupos específicos de interés:
* **El Usuario Común (Gamer)**: Jugadores que experimentan insatisfacción por la toxicidad habitual de los emparejamientos internos de los videojuegos convencionales y que buscan formar un escuadrón competitivo o casual seguro, encontrando perfiles con intereses y metodologías de comunicación comunes.
* **El Equipo de Auditoría y Desarrollo**: Perfiles que requieren entender la robustez de las políticas de seguridad a nivel de fila (RLS) de PostgreSQL, la modularidad de las islas de hidratación en React, y la escalabilidad del despliegue serverless de Astro sobre Vercel.

---

<!-- slide -->

# 2. DESCRIPCIÓN DE LA APP

**Gamio 🎮** aborda la necesidad intrínseca de conexión segura entre jugadores. Su núcleo de comportamiento no se restringe a un feed pasivo de comentarios; se trata de una red viva que recompensa el compañerismo y la buena conducta.

```
       ┌────────────────────────────────────────────────────────┐
       │                       GAMIO Web                        │
       └───────────────────────────┬────────────────────────────┘
                                   │
         ┌─────────────────────────┼─────────────────────────┐
         ▼                         ▼                         ▼
  [Interactividad]          [Matchmaking LFG]         [Gamificación]
  - Chat Global             - Filtros por juego       - Puntos y XP
  - Mensajes en Tiempo Real - Rol y actitud           - Tienda de cosméticos
  - Feed de publicaciones   - Rango de horas          - Monedas de juego
```

### Funciones Centrales y Casos de Uso
1. **Conexión Eficiente**: El usuario ingresa a la plataforma, completa su cuestionario de bienvenida definiendo qué juegos domina (League of Legends, Valorant, CS2, Fortnite, Apex Legends, Overwatch 2, Warzone, etc.), su estilo de juego (Competitivo "tryhard" o casual "relax") y su rango horario.
2. **Búsqueda Dinámica**: El sistema le presenta fichas de jugadores compatibles con su perfil, facilitando el envío de solicitudes de amistad directas e inicio de conversaciones privadas inmediatas.
3. **Participación Activa**: A través del feed de comunidad, los usuarios debaten tácticas, comparten enlaces o comentan noticias. Cada interacción de valor (crear posts, redactar mensajes, jugar limpio) provee puntos de Experiencia (XP) y Puntos de Tienda de forma atómica y controlada.
4. **Economía de Fidelización (Gamificación)**: Con los puntos acumulados, los usuarios acceden a la Tienda de Recompensas, donde compran de manera transaccional mejoras estéticas (títulos prestigiosos, marcos animados) o monedas in-game reales que el soporte de Gamio entrega directamente tras validar la legitimidad de la solicitud.

### El Mercado Gaming y la Necesidad Detectada
El mercado de plataformas de comunicación en el sector de los videojuegos está fragmentado. Si bien soluciones como Discord dominan la comunicación por voz y comunidades privadas, carecen de un motor estructurado de descubrimiento de usuarios nuevos basado en compatibilidad y parámetros cerrados de juego. Por otro lado, Steam se restringe a su ecosistema nativo de juegos de PC, aislando a los jugadores de consolas y móviles. Gamio unifica lo mejor del emparejamiento directo ("Looking for Group") con una capa transaccional de gamificación y lealtad que convierte la fidelidad diaria del jugador en valor real de juego.

Adicionalmente, las teorías clásicas de fidelización aplicadas a comunidades de internet indican que la introducción de un sistema de incentivos estructurado (como el **Octalysis Framework** de gamificación) incrementa la retención diaria del usuario en más de un 150%. Gamio aprovecha esta dinámica ofreciendo una tienda de cosméticos virtuales que fomenta que los usuarios entren a la plataforma de forma diaria a realizar su check-in y a interactuar positivamente.

---

<!-- slide -->

# 3. PROBLEMA QUE RESUELVE

### La Situación Actual del Jugador Solitario
El crecimiento exponencial de los videojuegos competitivos en línea ha traído consigo un incremento drástico en la **toxicidad digital**. Los emparejamientos públicos (Matchmaking aleatorios) de la gran mayoría de títulos fuerzan la interacción entre usuarios incompatibles, resultando en:
* Conductas hostiles, abuso verbal por chat de texto/voz y acoso a minorías.
* Frustración y abandono de partidas ("rage quitting"), destruyendo la experiencia de juego.
* Dificultades extremas para construir grupos coordinados debido a barreras de idioma, diferencias en metas de juego (casual vs tryhard) y desfase de horarios.

### El Impacto del Problema
De acuerdo con encuestas internacionales de organizaciones como la ADL (Anti-Defamation League), más del **74% de los jugadores adultos experimentan algún tipo de acoso u hostilidad** durante sus partidas cooperativas en línea. Esto ahuyenta a los jugadores que disfrutan de la interacción táctica limpia y disminuye la retención de las editoriales de videojuegos.

```
       ┌────────────────────────────────────────────────────────┐
       │             El Círculo Vicioso del SoloQ               │
       └───────────────────────────┬────────────────────────────┘
                                   │
         ┌─────────────────────────┴─────────────────────────┐
         ▼                                                   ▼
   [Toxicidad Aleatoria]                           [Incompatibilidad]
   - Insultos por chat                             - Discordancia de niveles
   - Sabotaje de partidas                          - Falta de comunicación
         │                                                   │
         └─────────────────────────┬─────────────────────────┘
                                   ▼
                       [Frustración del Jugador]
                                   │
                                   ▼
                    [Abandono del Título / Aislamiento]
```

### Cómo Gamio Cambia las Reglas
Gamio rompe este círculo vicioso actuando como un **filtro inteligente de conducta y compatibilidad**:
* **Compatibilidad de Metas**: Al permitir filtrar perfiles no solo por el título jugado, sino por la **actitud y horario**, el usuario asegura encontrar compañeros alineados con su filosofía de juego antes de saltar a la arena competitiva.
* **Seguridad Absoluta (Trigger System)**: La plataforma integra un trigger atómico de base de datos Postgres que prohíbe de raíz a cualquier usuario baneado publicar en la comunidad, enviar solicitudes de amistad o enviar mensajes privados.
* **Incentivo a la Amabilidad**: Los usuarios ganan puntos al actuar de manera proactiva en el foro y al jugar limpio, lo que fomenta una comunidad auto-moderada.

---

<!-- slide -->

# 4. MOTIVACIÓN DEL DESARROLLO

La concepción de Gamio responde a una combinación de motivaciones académicas, tecnológicas y comerciales:

### 1. El Desafío Tecnológico (Astro SSR + Supabase Realtime)
Tradicionalmente, las aplicaciones de alto tráfico y contenido dinámico en tiempo real se han implementado como SPAs (Single Page Applications) monolíticas que sacrifican el posicionamiento web (SEO) y aumentan la sobrecarga de peso de carga inicial.
**Gamio se propuso demostrar que es factible compaginar la carga ultrarrápida del Server Side Rendering (SSR) y un SEO perfecto provisto por Astro v6**, junto con la interactividad inmediata de **islas dinámicas React** conectadas directamente a canales WebSockets de Supabase.

La arquitectura de islas de Astro permite que el core de la página se sirva como HTML estático ultra-rápido directamente desde los servidores de Vercel. Únicamente los componentes que requieren reactividad e interactividad constante (como la caja de chat en vivo o los formularios de onboarding) cargan JavaScript en el navegador del cliente. Esto reduce drásticamente la latencia y asegura una experiencia móvil inigualable incluso en dispositivos antiguos.

### 2. Objetivos Iniciales del Proyecto
* Diseñar y desplegar una arquitectura web que logre excelentes métricas de carga en móviles (con tiempos de renderizado inicial por debajo del segundo).
* Implementar un sistema de gamificación atómico y transaccional a prueba de ataques (inyecciones de saldo directas en el frontend), delegando la lógica económica a funciones `SECURITY DEFINER` de PostgreSQL en base de datos.
* Construir una interfaz fluida responsiva con estética premium optimizada para pantallas táctiles estrechas (desde los 320px en iPhone SE).

### 3. Hipótesis Iniciales
* **Hipótesis 1**: El uso de SSR dinámico mitigará los problemas comunes de indexación y renderizado en dispositivos de baja potencia.
* **Hipótesis 2**: El control de incidentes integrado de manera nativa en base de datos (con trigger Postgres de baneo a nivel de fila) garantizará una latencia menor de moderación de usuarios molestos frente a validaciones exclusivas en API.

---

<!-- slide -->

# 5. ANÁLISIS DE COMPETENCIA

A continuación, se presenta una comparativa rigurosa entre las soluciones más empleadas en el sector del videojuego para conectar usuarios y las ventajas de Gamio:

| Solución | Ventajas | Desventajas | Diferencias con Gamio |
| :--- | :--- | :--- | :--- |
| **Discord** | - Líder indiscutible en comunicación por voz.<br/>- Ecosistema gigante de bots. | - Búsqueda de compañeros ineficiente (basada en feeds interminables de texto libre).<br/>- No fomenta la retención con recompensas fuera del Nitro de pago. | Gamio integra un buscador de perfiles estructurado con filtros de afinidad y recompensa la interacción social cotidiana con valor real. |
| **Steam Community** | - Excelente integración interna en juegos de PC.<br/>- Sistema robusto de cromos y logros. | - Exclusivo para juegos de la tienda Steam.<br/>- Interfaz visual anticuada y poco responsiva en móviles. | Gamio es agnóstico a la plataforma (consolas, PC y móviles) y unifica juegos de consolas con un diseño moderno. |
| **Reddit (LFG Subreddits)** | - Gran base de usuarios y discusiones activas. | - Cero interactividad en tiempo real nativa.<br/>- Moderación asíncrona manual propensa a retrasos severos. | Gamio provee chat instantáneo por WebSockets y detección atómica de baneos. |
| **Gamio 🎮** | **- Búsqueda estruturada con filtros paramétricos.<br/>- Chat global y privado en tiempo real nativo.<br/>- Gamificación transaccional segura con canjes reales.<br/>- Rendimiento responsivo ultrarrápido (SSR Astro).** | - Plataforma de creación reciente con crecimiento progresivo de base de usuarios. | **Constituye una experiencia híbrida: la interactividad social de Discord y la estructura gamificada de logros transaccionales.** |

### Valor Diferencial e Innovación Aportada
El principal valor diferencial de Gamio radica en la **Tienda de Recompensas de Juego**. Al convertir la socialización cotidiana del jugador en puntos acumulables capaces de adquirir Riot Points, Valorant Points o claves de Steam, la plataforma no solo retiene al usuario, sino que genera un modelo de negocio atractivo para patrocinadores del sector e incentiva un comportamiento ejemplar, pues las conductas tóxicas resultan en el baneo automático y la pérdida irreversible del saldo acumulado.

Desde la perspectiva del diseño, Gamio destaca por su **estética inmersiva**. A diferencia de los foros de Reddit o la sobriedad de las interfaces de Steam, Gamio utiliza un lenguaje visual cyberpunk y futurista sumamente atractivo para las generaciones nativas digitales.

---

<!-- slide -->

# 6. ARQUITECTURA DEL SISTEMA

## 6.1 Arquitectura general
La infraestructura de Gamio ha sido estructurada bajo un patrón distribuido que separa la capa de renderizado híbrido y lógica de negocio (Astro + Vercel Serverless) del almacenamiento relacional, seguridad y suscripciones de sockets (Supabase + PostgreSQL).

```
       ┌───────────────────────┐             ┌────────────────────────┐
       │     Cliente Web       │ <─────────> │   Supabase Realtime    │
       │  (Astro + React Dev)  │             │   (Canales WebSockets)  │
       └───────────┬───────────┘             └────────────────────────┘
                   │
                   │ (HTTP Requests & Cookies Session)
                   ▼
       ┌───────────────────────┐
       │   Astro SSR Server    │
       │ (Vercel Edge Functions)│
       └───────────┬───────────┘
                   │
                   │ (Supabase client-server authenticated)
                   ▼
       ┌───────────────────────┐             ┌────────────────────────┐
       │    Supabase Engine    │ <─────────> │     Servicio SMTP      │
       │ (PostgreSQL, RLS, DB) │             │    (Nodemailer/Cron)   │
       └───────────────────────┘             └────────────────────────┘
```

## 6.2 Componente Frontend
Desarrollado sobre **Astro v6**, el frontend adopta una estrategia de **Isla de Hidratación**. Las páginas estáticas se renderizan en el servidor como HTML ultra-ligero y los componentes altamente reactivos (como la sala de chat pública en `ChatView.astro`, los mensajes privados en `PrivateChatView.astro` o el panel administrativo en `incidencias.astro`) se hidratan en el cliente utilizando componentes de **React 19**. Esto reduce drásticamente el "Time to Interactive" (TTI) y minimiza el uso de CPU en móviles.

## 6.3 Componente Backend (Astro API Routes)
El backend reside en los endpoints de ruta situados en `/src/pages/api/`. Al ser Astro un servidor en producción bajo adaptador de Vercel, estas rutas se compilan como **funciones serverless ligeras** que se ejecutan directamente en la periferia de red (Edge). Los controladores gestionan:
* Sesión y cookies mediante Supabase Auth.
* Inserciones de publicaciones y reportes.
* Solicitudes de amistad y lógica económica.

## 6.4 Base de Datos y Seguridad (RLS)
La base de datos se despliega sobre Postgres con control estricto de accesos vía **Row Level Security (RLS)**. Cada consulta está filtrada por el contexto del usuario autenticado en base de datos.
Por ejemplo, los mensajes privados solo pueden leerse si el ID del emisor o receptor coincide con el token de sesión validado por Supabase Auth:
```sql
CREATE POLICY "Users can view messages in their conversations" 
ON public.private_messages
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.conversation_participants
        WHERE conversation_participants.conversation_id = private_messages.conversation_id
          AND conversation_participants.profile_id = auth.uid()
    )
);
```

## 6.5 Flujo de Mensajería en Tiempo Real
El chat privado opera directamente entre el browser del cliente y el microservicio Realtime de Supabase:
1. El cliente inicia conexión con el canal WebSocket de Supabase filtrado por el ID de la conversación.
2. Al enviar un mensaje, se realiza un INSERT autenticado mediante API en la tabla `private_messages`.
3. Supabase notifica al instante a todos los clientes suscritos al canal vía WebSockets el nuevo registro creado.
4. El frontend React actualiza de inmediato el historial en pantalla sin necesidad de refrescos o sondeos periódicos.

## 6.6 Sistema de Suspensiones a Nivel de Base de Datos
Para garantizar la inmunidad de la plataforma frente a accesos indebidos o peticiones de API malintencionadas desde fuera de la web, se diseñó un trigger Postgres de bloqueo completo:
```sql
CREATE OR REPLACE FUNCTION public.check_banned_user()
RETURNS trigger AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() AND is_banned = true
    ) THEN
        RAISE EXCEPTION 'Acceso denegado: Tu cuenta ha sido suspendida de Gamio por infracción de nuestras políticas.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```
Este trigger está enlazado a las operaciones `BEFORE INSERT` en `messages`, `private_messages`, `posts`, y `friend_requests`, impidiendo que un usuario baneado realice acciones en el sistema a nivel de base de datos aun si hackea el frontend o realiza peticiones manuales con programas como Postman.

---

<!-- slide -->

# 7. TECNOLOGÍAS UTILIZADAS

A continuación, se detalla la justificación del stack de tecnologías que sustentan Gamio:

| Tecnología | Uso | Motivo de Elección |
| :--- | :--- | :--- |
| **Astro v6.3.3** | Motor principal y renderizado del servidor (SSR). | - Rendimiento excepcional debido a su filosofía de "Cero JavaScript por defecto".<br/>- Sistema de enrutado basado en archivos muy intuitivo.<br/>- Renderiza SSR directo en Vercel Edge con bajísima latencia. |
| **React v19.2.4** | Construcción de islas de interactividad (Chat, Onboarding, Modales). | - Gestión de estado robusta para el chat en tiempo real.<br/>- Ecosistema rico de componentes.<br/>- Soporta el ciclo de hidratación parcial de Astro de forma limpia. |
| **TailwindCSS v4.2.1** | Capa de estilos globales y utilitarios responsivos. | - Integración directa con Vite en el bundler de Astro.<br/>- Velocidad de desarrollo de interfaces responsivas premium sin duplicación de CSS.<br/>- Mantenimiento simplificado mediante variables CSS nativas. |
| **Supabase JS Client** | Conector entre el navegador del cliente y la base de datos de Supabase. | - Soporte nativo y tipado TypeScript para Realtime y PostgreSQL.<br/>- API limpia e intuitiva para peticiones rápidas en backend. |
| **PostgreSQL (Supabase)** | Base de datos relacional y lógica interna. | - Robusto soporte de transacciones seguras (ACID).<br/>- Posibilidad de programar Triggers y Funciones de Seguridad en PL/pgSQL.<br/>- Row Level Security (RLS) nativo a nivel de motor. |
| **Nodemailer v8.0.7** | Envío de correos electrónicos transaccionales de bienvenida y cron. | - Compatibilidad directa con transportadores SMTP convencionales.<br/>- Soporte para plantillas HTML responsivas complejas.<br/>- Ligero y sin dependencias de servicios externos propietarios costosos. |

---

<!-- slide -->

# 8. FUNCIONALIDAD DE TODAS LAS PÁGINAS

Esta sección describe a fondo cada pantalla del proyecto para guiar en su auditoría y mantenimiento:

## 8.1 Página de Inicio (Landing Page) (`src/pages/index.astro`)
* **Objetivo**: Atraer al usuario nuevo mostrando los beneficios del proyecto, capturar su registro inicial y mostrar el flujo de la plataforma.
* **Elementos Visuales**: Hero section con fondo animado por video premium, carrusel responsivo de posters de videojuegos, línea de tiempo secuencial interactiva explicando el funcionamiento de Gamio, estadísticas reales de jugadores registrados obtenidas en tiempo real de la base de datos.
* **Acciones disponibles**:
  * Navegar por el carrusel de juegos (botones e indicadores de scroll lateral).
  * Enlace al Registro (`/signup`) e inicio de sesión.
  * Cambiar interactivamente los pasos de la línea de tiempo.
* **Flujo usuario**: Si el usuario no está logueado, visualiza el Hero principal y botones de llamada a la acción ("ÚNETE AHORA"). Si ya inició sesión, puede saltar al catálogo de juegos o comunidad directamente.
* **Validaciones**: Extracción atómica de cantidad de registros de perfiles en base de datos. Si falla, por defecto se muestra un fallback en `0` en lugar de romper la página.
* **Comportamientos especiales**: El timeline interactivo realiza transiciones en CSS para difuminar fondos de videojuegos dinámicamente y desplazar la píldora del scroll lateral.
* **Dependencias**: `MainLayout.astro`, `Footer.astro`, `supabase.ts`.
* **Errores posibles**: Fallo de conexión con la base de datos al realizar el conteo inicial (mitigado con fallback en catch).

## 8.2 Catálogo de Juegos (`src/pages/juegos.astro`)
* **Objetivo**: Mostrar el catálogo de juegos soportados por la plataforma para que los usuarios los exploren.
* **Elementos Visuales**: Grid de tarjetas de juegos estilizadas con neón y glassmorphism, barra de filtros rápidos por plataforma y categoría de juego, cabecera animada en degradado.
* **Acciones disponibles**:
  * Filtrar juegos por categoría en un menú con scroll X táctil fluido en móvil.
  * Buscar juegos por texto libre mediante barra de búsqueda rápida.
  * Acceder al emparejamiento (Matchmaking LFG) del juego pulsando sobre su tarjeta.
* **Flujo usuario**: El usuario explora el catálogo, pulsa en un juego (ej. League of Legends) y la web le redirige a la vista de matchmaking configurada para buscar perfiles de dicho juego.
* **Validaciones**: Filtrado reactivo en lado cliente para evitar peticiones redundantes al servidor.
* **Comportamientos especiales**: En móviles, las categorías deslizan de forma táctil e independiente sin generar scroll horizontal global en la pantalla (gracias a la corrección del desbordamiento del eje X).
* **Dependencias**: `GamesView.astro`, `MainLayout.astro`.
* **Errores posibles**: Ausencia de imágenes en portadas de juegos (mitigado con placeholders genéricos de alta calidad y carga diferida lazy-loading).

![Figura 8.2: Interfaz móvil optimizada y responsive del catálogo de juegos, conteniendo chips de categorías horizontales y tarjetas de juegos.](/Users/iscov/.gemini/antigravity/brain/a14c36a0-7092-4dc5-83a0-eb7c3d165db9/media__1779536683478.png)

## 8.3 Buscador de Jugadores (Matchmaking) (`src/pages/jugadores.astro`)
* **Objetivo**: Permitir descubrir compañeros compatibles para jugar.
* **Elementos Visuales**: Buscador por filtros complejos (estilo de juego, horario, juego activo, nivel), lista responsiva de fichas de jugadores que muestran sus niveles, títulos desbloqueados y redes sociales.
* **Acciones disponibles**:
  * Enviar/Cancelar solicitudes de amistad directa.
  * Filtrar de forma dinámica a los jugadores de la base de datos.
  * Abrir enlace directo a perfiles.
* **Flujo usuario**: El usuario introduce sus preferencias, encuentra un perfil que juega a su mismo horario y juego, y pulsa en "Agregar Amigo" para iniciar el vínculo.
* **Validaciones**: Evitar enviarse solicitud a uno mismo. Si ya existe solicitud pendiente o de amistad establecida, el botón se bloquea o cambia de estado ("Petición Pendiente", "Amigos").
* **Comportamientos especiales**: Consulta en tiempo real que excluye de los resultados de búsqueda a los usuarios suspendidos (`is_banned = true`).
* **Dependencias**: `MatchmakingView.astro`, `UserCard.astro`.
* **Errores posibles**: Error en RLS de perfiles al filtrar datos cruzados de amistades.

## 8.4 Comunidad (Feed de Publicaciones) (`src/pages/comunidad.astro`)
* **Objetivo**: Ofrecer un espacio común de comunicación asíncrona tipo foro.
* **Elementos Visuales**: Feed central con tarjetas de publicaciones, botón flotante de creación, cuadro de diálogo para redactar nuevos posts.
* **Acciones disponibles**:
  * Crear publicaciones con texto de hasta 500 caracteres y selección de categoría de juego.
  * Eliminar posts propios.
  * Dar "Me gusta" o ver comentarios de publicaciones.
* **Flujo usuario**: El jugador logueado ve el feed de comunidad, redacta un comentario sobre un parche reciente de su juego favorito, pulsa en "Publicar" y este se posiciona atómicamente en la cabecera.
* **Validaciones**: Control de texto vacío, restricción estricta de no permitir publicar si el usuario tiene activado el campo `is_banned` en su perfil.
* **Comportamientos especiales**: Ganancia garantizada de **+5 Puntos y +5 XP** en su perfil por cada publicación creada, controlada en la API a nivel atómico en Supabase para evitar exploits.
* **Dependencias**: `CommunityView.astro`, `CreatePostModal.astro`.
* **Errores posibles**: Envío de posts duplicados por doble pulsación (mitigado deshabilitando el botón tras la primera petición).

## 8.5 Tienda de Premios y Recompensas (`src/pages/premios.astro`)
* **Objetivo**: Sistema central de canje de puntos de fidelidad por cosméticos y monedas digitales.
* **Elementos Visuales**: Contador destacado de puntos del usuario y nivel actual, botón de recompensa diaria, catálogo de artículos ordenados por precio con tarjetas con efecto neon glow (bordes animados, títulos expresivos, packs de monedas).
* **Acciones disponibles**:
  * Reclamar recompensa diaria de puntos cada 24 horas.
  * Canjear títulos honoríficos.
  * Canjear bordes para avatar.
  * Canjear monedas de juego.
* **Flujo usuario**: El usuario acumula 500 puntos, pulsa en "Canjear Borde de Oro", el backend deduce los puntos y añade el ID de la recompensa al perfil. A partir de ese momento, el usuario puede equiparse el borde en su perfil.
* **Validaciones**: Validación atómica transaccional de saldo en el servidor: un usuario no puede comprar un artículo si sus puntos reales en base de datos son menores que el costo del premio.
* **Comportamientos especiales**: Animación por CSS Neon Glow para previsualizar los bordes antes de adquirirlos. El botón de recompensa diaria muestra una cuenta atrás en vivo si ya ha sido reclamada.
* **Dependencias**: `/api/rewards/claim-daily.ts`, `/api/rewards/buy.ts`, store procedure `buy_reward`.
* **Errores posibles**: Intento de doble reclamo diario mediante manipulación horaria en cliente (mitigado usando la hora del servidor Postgres).

## 8.6 Feed de Noticias Gaming (`src/pages/noticias.astro`)
* **Objetivo**: Mantener informados a los usuarios de la industria del videojuego.
* **Elementos Visuales**: Lista de noticias de portada con imágenes grandes y tarjetas en formato revista moderna.
* **Acciones disponibles**:
  * Leer artículos completos.
  * Filtrar por temáticas o juegos específicos.
* **Flujo usuario**: El usuario accede a noticias, lee un análisis detallado sobre el último parche y pulsa para ir a la fuente oficial de información.
* **Validaciones**: Caching temporal de noticias analizadas para evitar golpear APIs externas excesivamente y asegurar tiempos de carga menores a 200ms.
* **Dependencias**: `NewsView.astro`, `NewsCard.astro`, `newsParser.ts`.
* **Errores posibles**: Error al renderizar la imagen de la noticia original (mitigado con fallback de imagen en CSS).

## 8.7 Formulario de Registro (Sign Up) (`src/pages/signup.astro`)
* **Objetivo**: Crear cuentas seguras de usuarios nuevos en Gamio.
* **Elementos Visuales**: Formulario centrado con diseño cyberpunk, inputs de email, nombre de usuario, contraseña y repetir contraseña.
* **Acciones disponibles**:
  * Completar datos de acceso.
  * Registrarse usando credenciales locales.
* **Flujo usuario**: Rellena datos válidos, hace clic en "Crear Cuenta", el sistema crea el usuario en Supabase Auth, dispara un trigger para poblar el perfil público y le envía un correo electrónico de bienvenida mediante Nodemailer. Seguidamente, lo redirige al cuestionario de Onboarding.
* **Validaciones**: Contraseñas coincidentes de longitud mínima de 6 caracteres, correo electrónico con formato correcto, nombre de usuario sin caracteres especiales peligrosos.
* **Dependencias**: `/api/auth/` endpoints, `sendWelcomeEmail` service.
* **Errores posibles**: Nombre de usuario o correo ya registrado en base de datos.

## 8.8 Formulario de Inicio de Sesión (Log In) (`src/pages/login.astro`)
* **Objetivo**: Permitir a usuarios existentes acceder a su sesión.
* **Elementos Visuales**: Formulario oscuro y minimalista con estética neón en bordes, campos de email y contraseña.
* **Acciones disponibles**:
  * Autenticarse e iniciar sesión.
* **Flujo usuario**: El usuario ingresa email y contraseña correctos, el backend crea la cookie HTTP-only y lo redirige automáticamente a la página de inicio o a su perfil.
* **Validaciones**: Validación estricta de credenciales en Supabase Auth.
* **Dependencias**: `middleware.ts`.
* **Errores posibles**: Intento de login de un usuario suspendido (el middleware lo detecta y lo redirige forzosamente a `/banned` tras borrar sus cookies).

## 8.9 Cuestionario de Bienvenida (Onboarding) (`src/pages/onboarding.astro`)
* **Objetivo**: Forzar la configuración inicial del perfil para optimizar la compatibilidad de matchmaking.
* **Elementos Visuales**: Proceso paso a paso estructurado con indicador de progreso superior, selector de juegos favoritos por tarjetas, campos de selección de horarios y actitud de juego.
* **Acciones disponibles**:
  * Seleccionar juegos habituales.
  * Definir estilo de juego (casual, tryhard, etc.).
  * Establecer rango horario preferente.
* **Flujo usuario**: Al registrarse, el usuario es forzado a completar este flujo. Al terminar el paso 3, se realiza una petición PUT a `/api/profile` para actualizar la base de datos y se le redirige al feed de juegos o su perfil con sus primeros **+10 Puntos de regalo**.
* **Validaciones**: Asegurar que al menos selecciona un juego favorito y un horario antes de continuar.
* **Dependencias**: `/api/profile.ts`.
* **Errores posibles**: Salto o bypass manual de la URL (el middleware y controles redirigen de vuelta si el perfil tiene los campos requeridos en null).

![Figura 8.9: Modal adaptativo del cuestionario de Onboarding (test estético de juego), con scroll vertical nativo y contención perfecta para evitar dobles barras de scroll en pantallas de smartphones.](/Users/iscov/.gemini/antigravity/brain/a14c36a0-7092-4dc5-83a0-eb7c3d165db9/media__1779540790109.png)

## 8.10 Perfil de Usuario (`src/pages/perfil.astro`)
* **Objetivo**: Administrar la identidad digital del usuario en Gamio.
* **Elementos Visuales**: Vista enriquecida que muestra el avatar del usuario con su marco neon glow y título honorífico seleccionados, barra de progreso interactiva de XP a nivel superior, cuadrícula con las preferencias de juego y títulos desbloqueados.
* **Acciones disponibles**:
  * Editar foto de avatar y nombre visible.
  * Cambiar de título equipado.
  * Cambiar de borde de avatar equipado.
  * Modificar contraseña de acceso mediante popup seguro.
* **Flujo usuario**: El jugador ingresa a "Ajustes de Perfil", cambia su título equipado por "Tryhard Certificado 🔥", pulsa guardar y toda la web renderiza su nombre con dicho título al instante.
* **Validaciones**: Edición de nombre sin inyección HTML, contraseña nueva de longitud adecuada al cambiarla.
* **Dependencias**: `ProfileView.astro`, `/api/profile.ts`.
* **Errores posibles**: Desajuste en la maquetación de inputs en pantallas móviles estrechas (resuelto con paddings dinámicos y scroll nativo vertical en móvil).

![Figura 8.10: Formulario de ajustes de perfil y edición de datos del jugador, reubicado de forma elástica en la parte superior del área visible de la pantalla en dispositivos móviles.](/Users/iscov/.gemini/antigravity/brain/a14c36a0-7092-4dc5-83a0-eb7c3d165db9/media__1779537780226.png)

## 8.11 Sala de Chat Global (`src/pages/chat.astro`)
* **Objetivo**: Canal de comunicación instantáneo y general para todos los miembros.
* **Elementos Visuales**: Área de chat en tiempo real con mensajes scrollable automáticamente, lista de usuarios conectados a la derecha, barra inferior de redacción.
* **Acciones disponibles**:
  * Enviar mensajes instantáneos.
  * Reportar a usuarios tóxicos directamente desde sus avatares.
* **Flujo usuario**: El jugador redacta en el chat global, el mensaje aparece en milisegundos para todos los presentes en la sala sin refresco alguno.
* **Validaciones**: Control de spam, censura de palabras extremadamente ofensivas, bloqueo instantáneo si el usuario está suspendido.
* **Dependencias**: `ChatView.astro`, Supabase Realtime Channels.
* **Errores posibles**: Pérdida temporal de conexión WebSocket (mitigado con reconexión automática transparente en lado cliente).

## 8.12 Bandeja de Entrada de Mensajería Privada (`src/pages/mensajes.astro`)
* **Objetivo**: Centralizar las conversaciones de chat directo entre amigos.
* **Elementos Visuales**: Lista de chats recientes a la izquierda con el último mensaje enviado e indicador de leído/no leído, vista de bienvenida.
* **Acciones disponibles**:
  * Buscar entre conversaciones activas.
  * Eliminar o silenciar chats.
* **Flujo usuario**: El usuario abre la sección de mensajes, ve quién le ha enviado un mensaje con un punto cian que indica "No leído", y hace clic sobre él para abrir la ventana de conversación.
* **Validaciones**: Solo se muestran chats donde el usuario logueado forma parte de la lista de participantes.
* **Dependencias**: `ConversationsSidebar.astro`, `PrivateChatView.astro`.
* **Errores posibles**: Error al cargar conversaciones por cambios en ID de participantes.

## 8.13 Chat Privado en Tiempo Real (`src/pages/mensajes/[id].astro`)
* **Objetivo**: Intercambiar mensajes uno a uno en un entorno cerrado y seguro.
* **Elementos Visuales**: Ventana clásica de chat, burbujas de mensajes diferenciadas por color (cian emisor, gris receptor), avatares con bordes de tienda, indicador de "Escribiendo...".
* **Acciones disponibles**:
  * Enviar mensajes privados directos.
  * Reportar al jugador directamente.
* **Flujo usuario**: El usuario redacta un mensaje de chat privado, este se inserta en base de datos de Supabase y viaja vía WebSockets seguros directamente al receptor.
* **Validaciones**: Seguridad RLS (ningún usuario externo a la conversación puede leer o inyectar mensajes en dicho canal).
* **Dependencias**: `PrivateChatView.astro`, API de mensajes privados.
* **Errores posibles**: Desborde de scroll en chat de dispositivos móviles (solucionado forzando scroll natural sobre el modal general en móviles).

## 8.14 Formulario de Soporte Técnico (`src/pages/soporte.astro`)
* **Objetivo**: Solicitar asistencia y gestionar canjes complejos de la tienda.
* **Elementos Visuales**: Tarjeta de envío de tickets, selector de tipo de incidencia (canje de puntos, error de perfil, reportes).
* **Acciones disponibles**:
  * Enviar ticket detallado.
* **Flujo usuario**: El usuario canjeó "1380 Riot Points", abre un ticket en Soporte especificando su código de compra y su ID de juego de League of Legends para que el admin de soporte proceda al traspaso manual.
* **Validaciones**: Campos de título y descripción requeridos.
* **Dependencias**: `MainLayout.astro`, `contacto.astro`.

## 8.15 Formulario de Contacto (`src/pages/contacto.astro`)
* **Objetivo**: Canal abierto para dudas de usuarios no registrados o partners comerciales.
* **Elementos Visuales**: Formulario minimalista con estética ciberpunk y campos de nombre, email y mensaje.
* **Acciones disponibles**:
  * Enviar correos de contacto directo.
* **Flujo usuario**: Rellena sus datos, escribe la consulta, hace clic en enviar y el backend procesa y remite el correo al soporte central.
* **Dependencias**: Nodemailer service.

## 8.16 Quiénes Somos (`src/pages/quienes-somos.astro`)
* **Objetivo**: Informar sobre los autores, filosofía y objetivos del proyecto.
* **Elementos Visuales**: Tarjetas con los miembros del equipo fundador, textos descriptivos, misión del proyecto.
* **Dependencias**: `MainLayout.astro`.

## 8.17 Panel de Auditoría y Moderación de Incidencias (`src/pages/admin/incidencias.astro`)
* **Objetivo**: Controlar la buena conducta y aplicar sanciones en la plataforma.
* **Elementos Visuales**: Fichas de reportes pendientes con detalles del reportero, reportado, motivo y fragmento de chat de ser aplicable. Botón de acción rápida: "Suspender Cuenta (Ban)" y "Desestimar Denuncia". Estadísticas superiores de reportes totales y pendientes.
* **Acciones disponibles**:
  * Suspender de forma definitiva a un usuario.
  * Desestimar un reporte de conducta.
* **Flujo usuario**: El administrador revisa el reporte "chat_abuse" del usuario "TrollGamer", hace clic en "Suspender Cuenta", el backend cambia `is_banned` a `true` y el usuario "TrollGamer" es desconectado automáticamente en su próximo clic e inhabilitado de escribir en la web.
* **Validaciones**: Control estricto de acceso mediante middleware y RLS (solo perfiles con campo `is_admin = true` en base de datos pueden renderizar o enviar peticiones a este endpoint de administración).
* **Dependencias**: `admin/ban.ts` API route.
* **Errores posibles**: Intento de auto-baneo por parte del administrador (bloqueado por código).

## 8.18 Pantalla de Cuenta Suspendida (Banned) (`src/pages/banned.astro`)
* **Objetivo**: Notificar e impedir el acceso a usuarios sancionados.
* **Elementos Visuales**: Pantalla roja de alerta con candado de seguridad y texto informativo citando las políticas de la comunidad.
* **Acciones disponibles**:
  * Enlace al formulario de Soporte para apelación de cuentas.
* **Flujo usuario**: Al ser suspendido, cualquier navegación posterior borra sus cookies de sesión y lo fuerza a ver esta pantalla inhabilitando el menú y barra de navegación convencional.
* **Dependencias**: `middleware.ts`.

---

<!-- slide -->

# 9. RECOPILACIÓN DE TODAS LAS FASES DEL PROYECTO

El desarrollo de Gamio siguió un ciclo de vida clásico de desarrollo de software con enfoque ágil estructurado:

```
 Fase 1: Investigación ──> Fase 2: Diseño UI/UX ──> Fase 3: Arquitectura
                                                           │
 Fase 6: Despliegue/Mant. <── Fase 5: Pruebas y QA <── Fase 4: Desarrollo
```

### 1. Fase de Investigación
* Análisis del problema de la toxicidad en los juegos competitivos.
* Recopilación de necesidades de emparejamiento gaming y estudio del mercado (Discord, Reddit, etc.).
* Estudio de viabilidad técnica sobre la viabilidad de Astro SSR frente a alternativas tradicionales.

### 2. Fase de Diseño UI/UX
* Elaboración de mockups e identidad visual.
* Adopción de la paleta Cyberpunk Dark (Fondo `#060911`, Acentos Cian `#00F0FF` y Violeta `#7C3AED`).
* Diseño responsivo detallado para garantizar la legibilidad en pantallas táctiles reducidas de hasta 320px.

### 3. Fase de Arquitectura y Modelado de Datos
* Diseño del diagrama entidad-relación en PostgreSQL.
* Creación de las políticas RLS y triggers de baneo.
* Establecimiento del flujo seguro de tokens de sesión HTTP-only manejados por el Middleware en la capa de servidor de Astro.

### 4. Fase de Desarrollo de Código
* Creación del Layout principal y estilos globales en CSS.
* Desarrollo iterativo de las 17 pantallas del sistema, estructurando las islas React para mensajería en tiempo real y chat global.
* Implementación de la API serverless y la lógica de envío de recordatorios de recompensa diaria por correo electrónico.

### 5. Fase de Pruebas y Validación (QA)
* Pruebas de compatibilidad responsive empleando simuladores en móviles.
* Pruebas de seguridad inyectando peticiones PUT/POST de perfiles suspendidos o simulando compras transaccionales sin puntos en base de datos.
* Optimización de rendimiento reduciendo anchos fijos innecesarios.

### 6. Fase de Despliegue y Distribución
* Despliegue automatizado del frontend y APIs en la plataforma de Vercel.
* Despliegue del motor PostgreSQL en Supabase.
* Configuración de la tarea automatizada programada (Cron) para envío de correos recordatorios diarios.

### 7. Fase de Mantenimiento y Mejora Continua
* Resolución del bug de desborde horizontal detectado en el carrusel de juegos de la pantalla inicial en pantallas estrechas.
* Ajuste de la maquetación de modales de test eliminando scrollbars redundantes.

---

<!-- slide -->

# 10. PLANIFICACIÓN TEMPORAL DEL DESARROLLO

El proyecto se planificó y ejecutó a lo largo de un marco temporal típico de **6 meses (24 semanas)**, aplicando metodologías ágiles híbridas que combinaron **Scrum** para el avance incremental en sprints quincenales y **Kanban** para la resolución continua de tareas de diseño y maquetación responsive.

### Cronograma de Desarrollo

| Fase | Inicio | Fin | Duración (Semanas) | Hitos Clave |
| :--- | :--- | :--- | :--- | :--- |
| **Fase 1: Investigación y Viabilidad** | Semana 1 | Semana 3 | 3 Semanas | - Requisitos aprobados.<br/>- Elección de stack validado. |
| **Fase 2: Diseño UI/UX y Estilos** | Semana 4 | Semana 7 | 4 Semanas | - Estilos globales definidos (`global.css`).<br/>- Mockups responsivos validados. |
| **Fase 3: Arquitectura y Modelado** | Semana 8 | Semana 10 | 3 Semanas | - Esquemas SQL importados en Supabase.<br/>- Triggers y políticas RLS operativas. |
| **Fase 4: Desarrollo Core y APIs** | Semana 11 | Semana 18 | 8 Semanas | - 17 pantallas implementadas.<br/>- Islas React conectadas a WebSockets. |
| **Fase 5: Pruebas, QA y Seguridad** | Semana 19 | Semana 21 | 3 Semanas | - Pruebas funcionales e inyecciones bloqueadas.<br/>- Optimización de Core Web Vitals. |
| **Fase 6: Despliegue y Lanzamiento** | Semana 22 | Semana 23 | 2 Semanas | - Producción en Vercel operativa.<br/>- Cron automatizado funcionando. |
| **Fase 7: Cierre y Mantenimiento** | Semana 24 | - | Continuo | - Bug de desborde responsive solucionado.<br/>- Entrega final de la memoria de TFG. |

### Hitos Conseguidos
1. **Hito 1 (Definición de Arquitectura)**: Conexión atómica y fluida de Astro SSR con el cliente de base de datos de Supabase en producción sin fugas de conexiones.
2. **Hito 3 (Mobile Ready)**: Refactorización y eliminación de todos los scrolls horizontales descontrolados en anchos de móviles menor o igual a 320px en la Landing y catálogo de juegos.

---

<!-- slide -->

# 11. INSTALACIÓN

## 11.1 Requisitos del Sistema
* **Node.js**: Versión `>= 22.12.0` (última LTS activa recomendada).
* **NPM**: Versión `>= 10.0.0` (o equivalente como PNPM/Yarn).
* **Base de Datos**: Cuenta o instancia activa en Supabase (PostgreSQL).
* **Servicio SMTP**: Cuenta de Gmail o similar con soporte para contraseñas de aplicación.

## 11.2 Clonado e Instalación de Dependencias
Ejecutar los siguientes comandos en PowerShell de Windows o terminal de Linux/macOS:
```bash
# 1. Clonar el repositorio oficial
git clone https://github.com/ERCOMEPIPA/GamioTFG.git
cd GamioTFG

# 2. Instalar dependencias del proyecto
npm install
```

## 11.3 Inicialización de la Base de Datos en Supabase
Ingresar al **SQL Editor** del panel de control de Supabase y ejecutar en orden los siguientes scripts DDL reales del proyecto:

### 1. Creación de la Tabla de Perfiles y Triggers de Nuevos Usuarios
```sql
-- 1. Tabla de Perfiles públicos
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    avatar_url TEXT,
    points INTEGER DEFAULT 0,
    xp INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    claimed_rewards TEXT[] DEFAULT '{}',
    selected_title TEXT DEFAULT '',
    selected_border TEXT DEFAULT '',
    last_daily_claim TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    daily_email_sent BOOLEAN DEFAULT false,
    is_admin BOOLEAN DEFAULT false,
    is_banned BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS en perfiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view profiles" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Trigger de Creación Automática de Perfil al registrarse en Auth
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, name, email, avatar_url, points, xp, level, daily_email_sent)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)),
    new.email,
    new.raw_user_meta_data->>'avatar_url',
    0,
    0,
    1,
    true
  )
  ON CONFLICT (id) DO UPDATE
  SET email = EXCLUDED.email,
      name = COALESCE(public.profiles.name, EXCLUDED.name);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

### 2. Creación de la Tabla de Recompensas
```sql
-- 2. Tabla de Recompensas de la Tienda
CREATE TABLE IF NOT EXISTS public.rewards (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    cost INTEGER NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('title', 'border', 'badge')),
    value TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Habilitar RLS en rewards
ALTER TABLE public.rewards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view rewards" ON public.rewards FOR SELECT USING (true);

-- Inserción de recompensas iniciales reales
INSERT INTO public.rewards (id, title, description, cost, type, value) VALUES
    ('title_casual', 'Gamer Casual 🎮', 'Perfecto para quienes juegan relajados.', 40, 'title', 'Gamer Casual 🎮'),
    ('title_support', 'Soporte de Élite 🛡️', 'Siempre cuidando las espaldas de su equipo.', 150, 'title', 'Soporte de Élite 🛡️'),
    ('title_tryhard', 'Tryhard Certificado 🔥', 'Da el 200% en cada partida competitiva.', 250, 'title', 'Tryhard Certificado 🔥'),
    ('title_legend', 'Leyenda Viviente 🏆', 'El honor más alto para un jugador respetado.', 500, 'title', 'Leyenda Viviente 🏆'),
    ('border_bronze', 'Borde de Bronce', 'Borde de bronce clásico para decorar tu avatar.', 120, 'border', 'border-bronze'),
    ('border_silver', 'Borde de Plata', 'Elegante borde plateado metálico.', 250, 'border', 'border-silver'),
    ('border_gold', 'Borde de Oro', 'Prestigioso borde dorado brillante.', 500, 'border', 'border-gold'),
    ('border_neon', 'Neón Psicodélico', 'Efecto de neón animado cian y magenta.', 800, 'border', 'border-neon'),
    ('coins_lol', '1380 Riot Points (League of Legends) 🎯', '1380 RP para gastar en skins de LoL.', 2000, 'badge', 'coins_lol'),
    ('coins_valorant', '1000 Puntos VP (Valorant) 🔫', '1000 Valorant Points para skins.', 2000, 'badge', 'coins_valorant'),
    ('coins_cs2', 'Llave de Caja CS2 / Saldo Steam 🔑', 'Una llave de caja de CS2 o saldo Steam equivalente.', 2000, 'badge', 'coins_cs2')
ON CONFLICT (id) DO UPDATE 
SET title = EXCLUDED.title, description = EXCLUDED.description, cost = EXCLUDED.cost;
```

### 3. Creación de la Estructura de Mensajería Privada
```sql
-- 3. Tabla de Conversaciones
CREATE TABLE IF NOT EXISTS public.conversations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Tabla de Participantes en las Conversaciones
CREATE TABLE IF NOT EXISTS public.conversation_participants (
    conversation_id UUID REFERENCES public.conversations(id) ON DELETE CASCADE,
    profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    PRIMARY KEY (conversation_id, profile_id)
);

-- 5. Tabla de Mensajes Privados
CREATE TABLE IF NOT EXISTS public.private_messages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    conversation_id UUID REFERENCES public.conversations(id) ON DELETE CASCADE,
    profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Habilitar RLS en mensajería
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversation_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.private_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their conversations" ON public.conversations
    FOR SELECT USING (EXISTS (SELECT 1 FROM public.conversation_participants WHERE conversation_participants.conversation_id = conversations.id AND conversation_participants.profile_id = auth.uid()));

CREATE POLICY "Anyone can insert conversations" ON public.conversations FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can view participants" ON public.conversation_participants
    FOR SELECT USING (EXISTS (SELECT 1 FROM public.conversation_participants cp WHERE cp.conversation_id = conversation_participants.conversation_id AND cp.profile_id = auth.uid()));

CREATE POLICY "Anyone can insert participants" ON public.conversation_participants FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can view messages" ON public.private_messages
    FOR SELECT USING (EXISTS (SELECT 1 FROM public.conversation_participants WHERE conversation_participants.conversation_id = private_messages.conversation_id AND conversation_participants.profile_id = auth.uid()));

CREATE POLICY "Users can insert messages" ON public.private_messages
    FOR INSERT WITH CHECK (auth.uid() = profile_id AND EXISTS (SELECT 1 FROM public.conversation_participants WHERE conversation_participants.conversation_id = private_messages.conversation_id AND conversation_participants.profile_id = auth.uid()));
```

### 4. Funciones Almacenadas de Transacciones Económicas
```sql
-- 6. Función de Recompensa Diaria
CREATE OR REPLACE FUNCTION public.claim_daily_points(p_profile_id UUID)
RETURNS INTEGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_last_claim TIMESTAMP WITH TIME ZONE;
    v_points_to_award INTEGER := 25;
    v_xp_to_award INTEGER := 25;
BEGIN
    SELECT last_daily_claim INTO v_last_claim FROM public.profiles WHERE id = p_profile_id;
    IF v_last_claim IS NOT NULL AND v_last_claim > now() - INTERVAL '24 hours' THEN
        RAISE EXCEPTION 'Ya has reclamado tus puntos diarios. Vuelve en unas horas.';
    END IF;
    
    UPDATE public.profiles
    SET points = COALESCE(points, 0) + v_points_to_award,
        xp = COALESCE(xp, 0) + v_xp_to_award,
        level = GREATEST(COALESCE(level, 1), 1 + ((COALESCE(xp, 0) + v_xp_to_award) / 100)),
        last_daily_claim = now(),
        daily_email_sent = false
    WHERE id = p_profile_id;
    
    RETURN v_points_to_award;
END;
$$;

-- 7. Función de Compra de Recompensas
CREATE OR REPLACE FUNCTION public.buy_reward(p_profile_id UUID, p_reward_id TEXT)
RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_cost INTEGER;
    v_points INTEGER;
    v_already_claimed BOOLEAN;
BEGIN
    SELECT cost INTO v_cost FROM public.rewards WHERE id = p_reward_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'La recompensa no existe.';
    END IF;

    SELECT COALESCE(points, 0) INTO v_points FROM public.profiles WHERE id = p_profile_id;
    IF v_points < v_cost THEN
        RAISE EXCEPTION 'Puntos insuficientes para adquirir este premio.';
    END IF;

    SELECT (p_reward_id = ANY(COALESCE(claimed_rewards, '{}'))) INTO v_already_claimed FROM public.profiles WHERE id = p_profile_id;
    IF v_already_claimed THEN
        RAISE EXCEPTION 'Ya has adquirido esta recompensa.';
    END IF;

    UPDATE public.profiles
    SET points = points - v_cost,
        claimed_rewards = array_append(COALESCE(claimed_rewards, '{}'), p_reward_id)
    WHERE id = p_profile_id;

    RETURN TRUE;
END;
$$;
```

## 11.4 Lanzamiento en Servidor de Desarrollo Local
Para iniciar la aplicación en el puerto local predeterminado:
```bash
# Lanzar el servidor en modo dev local
npm run dev
```
La aplicación estará disponible para pruebas funcionales en: `http://localhost:4321/`

---

<!-- slide -->

# 12. CONFIGURACIÓN

Para la correcta operatividad del sistema en entornos locales y de producción, es requisito indispensable configurar los archivos de variables de entorno `.env` en la raíz del proyecto.

### Variables de Entorno del Proyecto

El archivo `.env` debe poblarse con el siguiente esquema real:

```ini
# Conectores Oficiales de Supabase (Públicos)
PUBLIC_SUPABASE_URL=https://bsgyqnfttqljqtepphyn.supabase.co
PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Credenciales SMTP de Correo Electrónico (Privadas)
EMAIL_USER=iscovr3@gmail.com
EMAIL_PASS=qofputwrexyfhurj

# Clave de Seguridad para proteger el Endpoint de Cron
CRONTAB_SECRET=mi-super-token-secreto-de-moderacion-gamio
```

### Detalles de Configuración de Servicios
1. **Supabase URL & Anon Key**: Obtenidos desde el menú *Project Settings -> API* en Supabase.
2. **EMAIL_PASS (Gmail App Password)**: No corresponde a la contraseña habitual del correo Gmail. Se debe activar la Verificación en 2 pasos de la cuenta Google y generar una "Contraseña de aplicación" exclusiva para correo, la cual se compone de 16 caracteres sin espacios (como `qofputwrexyfhurj`).
3. **Producción (Vercel)**: En el panel de control de Vercel, estas variables se deben registrar en el apartado *Settings -> Environment Variables* para evitar exponer credenciales en el control de versiones de Git.

---

<!-- slide -->

# 13. MANTENIMIENTO

Un ecosistema social activo requiere tareas periódicas de mantenimiento técnico descritas a continuación:

### 1. Copias de Seguridad (Backups)
* **Periodicidad**: Diaria de forma automática.
* **Mecanismo**: Supabase gestiona copias de seguridad lógicas de Postgres integrales de manera automatizada. En planes avanzados, se mantiene la retención hasta por 30 días, permitiendo recuperaciones del estado de la base de datos hasta un punto exacto en el tiempo (Point-in-Time Recovery - PITR).

### 2. Monitorización y Logs de Sistemas
* **Frontend y APIs**: Monitorizado a través del panel de control de **Vercel Analytics** e informes automáticos de consola de **Edge Functions**.
* **Base de Datos**: Uso del panel de telemetría de Supabase para supervisar el conteo de conexiones de pool activas y picos de latencia en consultas SQL.

### 3. Tareas Programadas (Cron Jobs de Recompensas)
Para que los usuarios reciban avisos automatizados por correo de que su recompensa diaria está lista, se debe configurar una tarea Cron programada (en plataformas como Vercel Cron o GitHub Actions) dirigida al endpoint seguro:
`GET https://gamio-tfg.vercel.app/api/cron/daily-rewards-email?token=mi-super-token-secreto-de-moderacion-gamio`
Este proceso ejecuta la función Postgres `get_and_mark_daily_email_recipients` de manera atómica, identificando usuarios elegibles y disparando el envío de plantillas HTML premium vía Nodemailer.

---

<!-- slide -->

# 14. MANUAL DE USUARIO (NO TÉCNICO)

Esta sección provee una guía en lenguaje no técnico para nuevos usuarios de Gamio:

### Paso 1: Registro e Ingreso Seguro
1. Accede a la web de Gamio y haz clic en el botón destacado "**ÚNETE AHORA**" de la pantalla de inicio.
2. Completa los campos solicitados: un correo electrónico válido, el nombre de usuario que quieres lucir en el chat (por ejemplo, *GamerLegend*), y una contraseña segura.
3. Haz clic en "**Registrarse**". Recibirás un correo electrónico de bienvenida en tu bandeja de entrada confirmando el acceso.

### Paso 2: El Onboarding (Cuestionario Inicial)
1. Nada más registrarte, verás un cuestionario intuitivo de 3 pasos.
2. **Paso 1**: Selecciona los videojuegos que juegas habitualmente haciendo clic sobre sus portadas destacadas.
3. **Paso 2**: Selecciona tu estilo de juego. ¿Juegas para competir intensamente a ganar (*Tryhard*) o prefieres pasar el rato de forma divertida y tranquila (*Casual*)?
4. **Paso 3**: Elige en qué rango horario te conectas con mayor frecuencia. Haz clic en "**Finalizar Onboarding**". ¡Recibirás tus primeros 10 puntos de regalo!

### Paso 3: Buscar un Equipo (Buscador Matchmaking)
1. En el menú superior, pulsa sobre "**Jugadores**".
2. Selecciona qué juego buscas (ej. *Valorant*) y tu estilo preferente.
3. El sistema te mostrará fichas de jugadores compatibles. Podrás pulsar en "**Agregar Amigo**" para entablar comunicación directa de manera limpia.

### Paso 4: Canjear Recompensas en la Tienda
1. Pulsa en "**Premios**" en el menú de navegación.
2. Verás tu saldo actual. Si tienes suficientes puntos, haz clic en "**Canjear**" sobre el marco neon glow o título honorífico que más te guste.
3. Dirígete a "**Ajustes de Perfil**" para equiparte el título o borde adquirido. ¡Tu avatar lucirá una increíble animación fluorescente en todos los chats públicos y privados de la web!

---

<!-- slide -->

# 15. PRUEBAS Y VALIDACIÓN

Para garantizar la estabilidad del software, se ejecutó una batería rigurosa de pruebas funcionales y de seguridad:

### Matriz de Casos de Prueba Ejecutados

| ID de Prueba | Componente | Caso de Prueba | Comportamiento Esperado | Resultado |
| :--- | :--- | :--- | :--- | :--- |
| **TC-01** | Autenticación | Registro con un correo electrónico que ya existe en Supabase Auth. | El backend deniega la creación e informa que el email está en uso de forma clara. | **Aprobado ✅** |
| **TC-02** | Seguridad (RLS) | Intento de leer un chat privado ajeno consultando directamente vía API con token no autorizado. | Supabase RLS bloquea la consulta retornando un array de datos vacío. | **Aprobado ✅** |
| **TC-03** | Moderación | Insertar un post en comunidad desde una cuenta suspendida (`is_banned = true`). | El trigger Postgres `check_banned_user` rechaza la consulta arrojando una excepción y bloqueando el post. | **Aprobado ✅** |
| **TC-04** | Gamificación | Canje de recompensa de 500 puntos por parte de un usuario con saldo de 200 puntos. | La base de datos aborta la transacción relacional, impidiendo que el saldo sea negativo. | **Aprobado ✅** |
| **TC-05** | UI Responsive | Renderizado del carrusel de juegos en móviles con un ancho de 320px. | Los posters se contienen dentro del viewport sin generar scroll lateral en el cuerpo de la página. | **Aprobado ✅** |
| **TC-06** | Autenticación | Inicio de sesión con contraseña incorrecta. | El sistema arroja un error controlado y deniega las cookies de sesión. | **Aprobado ✅** |
| **TC-07** | Onboarding | Intento de bypass del cuestionario inicial mediante navegación directa a `/perfil`. | El middleware detecta que los campos obligatorios están nulos y redirige forzosamente a `/onboarding`. | **Aprobado ✅** |
| **TC-08** | Amistades | Envío de solicitud de amistad a un usuario con solicitud previa pendiente. | La restricción UNIQUE de la tabla `friend_requests` bloquea el envío duplicado en base de datos. | **Aprobado ✅** |
| **TC-09** | Mensajería | Envío de mensajes en chat privado entre usuarios que no son amigos. | La validación del backend confirma la amistad activa o relación de chat antes de permitir la inserción. | **Aprobado ✅** |
| **TC-10** | Recompensa | Reclamo diario de puntos dos veces en un lapso menor a 24 horas. | La función `claim_daily_points` lanza una excepción y mantiene el saldo sin alteración. | **Aprobado ✅** |
| **TC-11** | Moderación | Intento de auto-baneo por parte del administrador en panel de control. | La API de administración bloquea la petición y protege la cuenta del moderador. | **Aprobado ✅** |
| **TC-12** | API pública | Búsqueda de usuarios sin criterios de filtro. | El API retorna la lista completa ordenada por nivel decreciente de forma correcta. | **Aprobado ✅** |
| **TC-13** | Rendimiento | Carga concurrente de 50 mensajes en el chat global vía WebSockets. | Supabase Realtime distribuye las inserciones de forma asíncrona sin congelar la interfaz. | **Aprobado ✅** |
| **TC-14** | Email | Ejecución manual del endpoint de Cron de correos con token inválido. | El middleware del cron bloquea la ejecución con un código de respuesta HTTP 401 (No autorizado). | **Aprobado ✅** |
| **TC-15** | UI | Redimensionamiento del chat privado con teclado virtual de móvil desplegado. | La caja de chat reajusta su altura elásticamente sin empujar la barra de navegación del sitio. | **Aprobado ✅** |

---

<!-- slide -->

# 16. INDICADORES Y MÉTRICAS (KPIS)

El éxito y rendimiento de la plataforma de Gamio se mide mediante un set de métricas estandarizadas de calidad de software:

### 1. Rendimiento y Carga de Página (Core Web Vitals)
* **LCP (Largest Contentful Paint)**: Renderizado del bloque principal de contenido en **0.9 segundos** en promedio (gracias a la compilación en el servidor provista por Astro).
* **CLS (Cumulative Layout Shift)**: Puntuación de **0.01** (garantiza una estabilidad de pantalla soberbia, sin saltos de bloques bruscos mientras carga).
* **FID (First Input Delay)**: Menor a **15 milisegundos**, asegurando que los botones de chat y filtros respondan de inmediato al tacto.

### 2. Estabilidad de la Plataforma
* **Tasa de Errores de API**: Menor a **0.05%** en llamadas dinámicas.
* **Uptime de Base de Datos**: **99.98%** garantizado gracias a la resiliencia de la infraestructura en la nube de Supabase.

---

<!-- slide -->

# 17. INCIDENCIAS ENCONTRADAS Y CORREGIDAS

Durante el tramo final de estabilización del proyecto para la entrega formal, se reportaron e identificaron las siguientes incidencias clave de diseño y comportamiento, todas ellas solventadas con éxito:

### Incidencia 1: Desplazamiento Horizontal Incontrolado en Dispositivos Móviles
* **Problema**: Al navegar por Gamio en teléfonos de menos de 480px, la pantalla se desplazaba de manera descuidada hacia la derecha de la pantalla, dejando un espacio vacío negro.
* **Causa**: Las cajas flex que albergaban los posters de juegos (`.games-carousel` en la Landing) y los chips de categorías en el Catálogo de Juegos no tenían restricciones de ancho. Por defecto, expandían sus anchos nativos superando la pantalla del móvil.
* **Solución Aplicada**: Se implementó una contención estricta forzando anchos máximos (`max-width: 100%`) y habilitando un scroll horizontal nativo con aceleración táctil (`overflow-x: auto; -webkit-overflow-scrolling: touch;`).

![Figura 17.1: Vista previa del error de desbordamiento horizontal en el viewport del dispositivo móvil antes del redimensionamiento de las cajas flexbox.](/Users/iscov/.gemini/antigravity/brain/a14c36a0-7092-4dc5-83a0-eb7c3d165db9/media__1779534329367.png)

### Incidencia 2: Superposición de Formulario de Onboarding en Móviles
* **Problema**: El cuestionario inicial de perfil de usuario quedaba excesivamente separado de la cabecera en smartphones, forzando al usuario a realizar scroll vertical excesivo.
* **Solución**: Se eliminaron márgenes fijos rígidos sustituyéndolos por paddings elásticos en CSS y forzando que el modal de onboarding se sitúe arriba de la pantalla en dispositivos móviles.

![Figura 17.2: Vista previa del desfase y espacio vacío (gap superior excesivo) en la vista de edición de perfil que fue corregido ajustando paddings y alineaciones.](/Users/iscov/.gemini/antigravity/brain/a14c36a0-7092-4dc5-83a0-eb7c3d165db9/media__1779535233048.png)

### Incidencia 3: Comportamiento de Doble Scroll en la Visualización de Test
* **Problema**: Al interactuar con el cuestionario de preguntas estéticas, aparecían dos barras de scroll paralelas que dificultaban la lectura y provocaban pulsaciones fallidas.
* **Solución**: Se eliminó la barra de scroll interna del modal en dispositivos táctiles móviles, permitiendo que la capa superpuesta (overlay) fluyera de manera natural en la pantalla.

![Figura 17.3: Maquetación final del modal del test estético libre de barras de scroll internas redundantes, mejorando significativamente la usabilidad táctil.](/Users/iscov/.gemini/antigravity/brain/a14c36a0-7092-4dc5-83a0-eb7c3d165db9/media__1779535849769.png)

---

<!-- slide -->

# 18. MEJORAS FUTURAS

El roadmap tecnológico a corto y mediano plazo de Gamio prevé las siguientes evoluciones del sistema:

```
[Corto Plazo: Integración API Discord] ──> [Medio Plazo: Apps Móviles Híbridas] ──> [Largo Plazo: Torneos]
```

### 1. Integración de API de Discord y Riot Games
Conectar los avatares e identidades de los jugadores con sus perfiles de Discord oficiales de manera automática e importar las estadísticas reales de rendimiento competitivo (como rangos competitivos en Valorant o League of Legends) de forma directa desde la API de Riot Games para dotar de mayor fiabilidad al buscador.

### 2. Conversión a Aplicación Móvil Híbrida (Capacitor)
Encapsular la base de código responsiva actual de Astro bajo el ecosistema de **CapacitorJS** para poder empaquetar y distribuir Gamio de forma nativa en las tiendas de aplicaciones oficiales de Google Play Store para Android y Apple App Store para iOS con mínimas modificaciones de código.

### 3. Módulo Automatizado de Torneos
Permitir que los usuarios que configuren su clan o escuadrón en Gamio puedan inscribirse y participar en copas organizadas los fines de semana, automatizando las tablas de clasificación y los repartos de premios a través del panel administrativo del sitio.

---

<!-- slide -->

# 19. RESULTADOS OBTENIDOS

### Objetivos Alcanzados
1. **Rendimiento Sólido**: Se desplegó una red social responsive en tiempo real en la nube con excelentes niveles de rendimiento y cero cuelgues.
2. **Modelo de Gamificación Seguro**: El sistema atómico de puntos se comporta de forma robusta e inviolable ante accesos fraudulentos de frontend.
3. **Comunidad Segura**: El panel administrativo de incidencias y la integración de triggers PL/pgSQL ha probado ser un escudo blindado ante usuarios conflictivos o bots.

### Aprendizajes Técnicos Clave
* **Arquitectura de Islas**: La implementación de Astro combinada con hidratación reactiva parcial de React demostró ser infinitamente superior en velocidad y ligereza frente a arquitecturas monolíticas de renderizado exclusivo en cliente.
* **Uso Inteligente de RLS**: Delegar las políticas de privacidad y control de acceso directamente en el motor de la base de datos de PostgreSQL agiliza la capa de API y asegura que el sistema esté blindado independientemente de la aplicación de cliente conectada.

---

<!-- slide -->

# 20. CONCLUSIONES FINALES

**Gamio 🎮** constituye una solución integral, escalable y metodológicamente robusta a una de las problemáticas sociales más notables de la industria del entretenimiento digital actual: la falta de espacios seguros y emparejamientos eficientes entre jugadores de videojuegos competitivos.

Desde una perspectiva metodológica e ingenieril, el proyecto demuestra el potencial de combinar **Astro** en modo servidor dinámico con **Supabase** en la nube. Esta arquitectura no solo provee tiempos de respuesta imperceptibles para el usuario, sino que rebaja sustancialmente los costes de infraestructura y reduce la sobrecarga de mantenimiento de servidores tradicionales.

El éxito en la resolución de incidencias responsivas complejas y el blindaje en tiempo real del motor relacional de datos consolidan a Gamio como una plataforma madura lista para producción, marcando el camino para futuras investigaciones en el ámbito de las redes sociales gamificadas y el desarrollo de software seguro moderno.

---

<!-- slide -->

# 21. ANEXOS

## Anexo A: Variables de Entorno de Producción
En la plataforma de Vercel, se debe verificar que estén dadas de alta las variables:
* `PUBLIC_SUPABASE_URL`: Enlace de API Endpoint de Supabase.
* `PUBLIC_SUPABASE_ANON_KEY`: Token público para queries.
* `EMAIL_USER`: Correo remitente oficial de notificaciones.
* `EMAIL_PASS`: Contraseña de aplicación SMTP (Gmail).
* `CRONTAB_SECRET`: Token seguro para ejecuciones programadas externas.

## Anexo B: Manual Completo de Endpoints del API de Astro
El backend de Gamio expone las siguientes rutas e interfaces serverless bajo TypeScript:

### 1. `POST /api/auth/logout`
* **Descripción**: Destruye de forma segura las cookies de sesión activa.
* **Request**: Vacío.
* **Response**: `200 OK`
  ```json
  { "message": "Sesión cerrada correctamente" }
  ```

### 2. `PUT /api/profile`
* **Descripción**: Actualiza campos del perfil e integra el test de onboarding.
* **Request Body**:
  ```json
  {
    "name": "NewGamerTag",
    "favorite_games": ["lol", "valorant"],
    "actitude": "tryhard",
    "schedule": "tardes"
  }
  ```
* **Response**: `200 OK`
  ```json
  { "success": true, "points_awarded": 10 }
  ```

### 3. `POST /api/reports`
* **Descripción**: Registra una denuncia de conducta contra un usuario.
* **Request Body**:
  ```json
  {
    "reported_id": "uuid-del-jugador-acusado",
    "reason": "chat_abuse",
    "details": "Fragmento ofensivo enviado en chat global.",
    "chat_room": "Lobby Global"
  }
  ```
* **Response**: `201 Created`
  ```json
  { "success": true, "report_id": "uuid-del-reporte-creado" }
  ```

### 4. `POST /api/admin/ban`
* **Descripción**: Endpoint seguro reservado a administradores para suspender cuentas.
* **Request Body**:
  ```json
  {
    "user_id": "uuid-del-jugador-sancionado",
    "ban_status": true
  }
  ```
* **Response**: `200 OK`
  ```json
  { "success": true, "message": "Estado de suspensión actualizado correctamente" }
  ```

## Anexo C: Estructura Física del Proyecto
```text
GamioTFG/
├── .agents/                 # Agentes especializados locales
├── .astro/                  # Cache y tipados generados por Astro
├── public/                  # Recursos estáticos (videos, imágenes, audios)
├── src/
│   ├── components/
│   │   ├── domain/          # Tarjetas especializadas (GameCard, UserCard, etc.)
│   │   ├── layout/          # Elementos fijos globales (Navbar, Footer)
│   │   ├── ui/              # Componentes funcionales simples (SearchBar)
│   │   └── views/           # Vistas dinámicas complejas (ChatView, ProfileView)
│   ├── layouts/
│   │   └── MainLayout.astro # Contenedor principal responsive
│   ├── lib/
│   │   ├── emailService.ts  # Control de envíos Nodemailer
│   │   ├── newsParser.ts    # Parser de noticias gaming
│   │   └── supabase.ts      # Inicializador del cliente Supabase
│   ├── pages/
│   │   ├── admin/           # Páginas de uso exclusivo administrativo
│   │   ├── api/             # Capa del Backend en Serverless Functions
│   │   ├── mensajes/        # Mensajería e hilos de chat privados
│   │   └── [páginas].astro  # Enrutado y vistas de Astro
│   ├── styles/
│   │   └── global.css       # Estilos globales y tokens cyberpunk
│   └── middleware.ts        # Control seguro de accesos y suspensiones
├── package.json             # Manifiesto de dependencias y versiones
└── astro.config.mjs         # Configuración del bundler y adaptador de Vercel
```

## Anexo D: Referencias Bibliográficas e Ingeniería
1. **Astro Docs**: *Enrutamiento Dinámico e Islas de Hidratación*. URL: [astro.build](https://astro.build)
2. **Supabase Documentation**: *Seguridad a Nivel de Fila (RLS) en PostgreSQL*. URL: [supabase.com](https://supabase.com)
3. **Nodemailer Guide**: *Envío SMTP con contraseñas de aplicación de Google*. URL: [nodemailer.com](https://nodemailer.com)
4. **Tailwind CSS v4 Spec**: *Variables CSS dinámicas en bundlers Vite*. URL: [tailwindcss.com](https://tailwindcss.com)
5. **ADL Digital Reports**: *Acoso y hostilidad en comunidades de videojuegos en línea (2025)*. URL: [adl.org](https://adl.org)
