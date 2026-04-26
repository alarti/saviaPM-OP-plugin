# OpenProject AI Project Planner Plugin

![OpenProject Version](https://img.shields.io/badge/OpenProject-13.0+-blue.svg)
![License](https://img.shields.io/badge/license-GPL--3.0-green.svg)
![Author](https://img.shields.io/badge/Author-Alberto%20Arce-orange.svg)

## 📝 Descripción

**OpenProject AI Project Planner** es un plugin profesional diseñado para automatizar la gestión de proyectos desde su concepción. Permite generar una estructura de proyecto completa (WBS, Diagramas de Gantt, presupuestos y cronogramas) a partir de una simple descripción textual.

Además, el plugin introduce un motor de **Mejora Continua**, integrando ganchos (hooks) dentro de cada proyecto para analizar el rendimiento en tiempo real y proponer cambios proactivos en la planificación.

## ✨ Características Principales

* **Generador Automático de Proyectos:** Crea instantáneamente:
    * **WBS (Work Breakdown Structure):** Jerarquía completa de paquetes de trabajo.
    * **Gantt & Timeline:** Definición automática de fases, hitos y relaciones (predecesores/seguidores).
    * **Presupuesto y Estimaciones:** Cálculo de horas estimadas y asignación presupuestaria inicial.
    * **Planificación de Reuniones:** Configuración de puntos de control y sincronización.
* **Hook de Mejora Continua:** Panel "Project Advisor" integrado que analiza desviaciones en tiempos y costes para sugerir ajustes.
* **Documentación Profesional:** Código fuente íntegramente comentado en inglés bajo estándares **Doxygen**.
* **Integración Nativa:** Desarrollado siguiendo los patrones de diseño de OpenProject (Services, Contracts y Representers).

## 🛠 Instalación

Para instalar el plugin en tu instancia de OpenProject, sigue estos pasos:

1.  **Añadir al Gemfile:**
    Añade la siguiente línea en `frontend/src/app/plugins/gemfile.plugins.rb` (o en tu archivo de plugins habitual):
    ```ruby
    gem "openproject-ai_project_planner", git: "[https://github.com/tu-repositorio/openproject-ai_project_planner.git](https://github.com/tu-repositorio/openproject-ai_project_planner.git)"
    ```

2.  **Instalar dependencias:**
    ```bash
    bundle install
    npm install
    ```

3.  **Ejecutar Migraciones:**
    ```bash
    bundle exec rake db:migrate
    ```

4.  **Precompilar activos:**
    ```bash
    bundle exec rake assets:precompile
    ```

5.  **Reiniciar el servidor:**
    ```bash
    reboot openproject
    ```

## 🚀 Uso

### Generación de Proyecto
1. Dirígete al menú de **Proyectos** y selecciona **"Generar con IA"**.
2. Introduce una descripción detallada (ej: *"Crear un plan para el despliegue de una infraestructura cloud en AWS con fase de auditoría y pruebas"*).
3. El plugin generará automáticamente los paquetes de trabajo, fechas y presupuestos.

### Mejora Continua (Advisor)
Dentro de cualquier proyecto existente, encontrarás un nuevo icono de **"Análisis de Mejora"** en la barra lateral. Al hacer clic, el sistema comparará:
* Tiempo estimado vs. tiempo gastado.
* Presupuesto planificado vs. coste actual.
* Sugerencias de re-planificación de fechas en el Gantt.

## 📚 Documentación Técnica (Doxygen)

Este proyecto utiliza **Doxygen** para la generación de documentación técnica. Para generar el reporte de arquitectura:

```bash
doxygen Doxyfile
