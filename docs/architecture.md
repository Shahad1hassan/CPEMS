# CPEMS Architecture

## 1. Overview

The system consists of three main components:

* **Patient Mobile Application** — Flutter-based application used by patients.
* **Healthcare Provider System** — Interface for monitoring patients, reviewing readings, and managing reports.
* **Backend** — Handles authentication, data storage, access control, and communication between system components.

A connected respiratory medical device provides measurements to the patient application.

---

## 2. High-Level Architecture

```text
┌─────────────────────┐
│   Medical Device    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Flutter Mobile App  │
│      (Patient)      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      Supabase       │
│ Auth • API • RLS    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│     PostgreSQL      │
│      Database       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Healthcare Provider │
│       System        │
└─────────────────────┘
```

### Technology Stack

| Layer                      | Technology    |
| -------------------------- | ------------- |
| Mobile Application         | Flutter       |
| Programming Language       | Dart          |
| Backend Platform           | Supabase      |
| Database                   | PostgreSQL    |
| Authentication             | Supabase Auth |
| Version Control            | Git           |
| Repository & Collaboration | GitHub        |

---

## 3. Mobile Application Architecture

The Flutter application follows a **feature-based architecture**.

Instead of organizing the entire application only by technical type, related code is grouped according to the feature it belongs to.

### Application Structure

The initial structure will be:

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   │
│   └── theme/
│       └── app_theme.dart
│
├── shared/
│   └── widgets/
│       └── app_bottom_navigation.dart
│
└── features/
		├── authentication/
		│   ├── screens/
		│   │   └── login_screen.dart
		│   ├── widgets/
		│   ├── models/
		│   └── services/
    │
    ├── main_navigation/
    │   └── screens/
    │       └── main_navigation_screen.dart
    │
    ├── home/
    │   ├── screens/
    │   │   └── home_screen.dart
    │   └── widgets/
    │
    ├── measurement/
    │   ├── screens/
    │   │   ├── measurement_screen.dart
    │   │   ├── measurement_steps_screen.dart
    │   │   └── measurement_result_screen.dart
    │   └── widgets/
    │
    ├── charts/
    │   ├── screens/
    │   │   └── charts_screen.dart
    │   └── widgets/
    │
    └── profile/
        ├── screens/
        │   └── profile_screen.dart
        └── widgets/
```

### `core/`

Contains application-wide functionality that is not owned by a specific feature.

```text
core/
├── constants/
├── errors/
├── network/
├── routing/
├── services/
├── theme/
└── utils/
```

Typical responsibilities include:

* Application routing
* Theme configuration
* Global constants
* Network configuration
* Error handling
* Application-wide services
* Utility functions

### `features/`

Contains the application's main functional areas.

```text
features/
├── authentication/
├── home/
├── readings/
├── charts/
├── medications/
├── notifications/
└── profile/
```

Each feature owns the code related to its functionality.

For example:

```text
features/
└── home/
    └── presentation/
        ├── pages/
        └── widgets/
```

As a feature becomes more complex, it can be extended into:

```text
home/
├── data/
├── domain/
└── presentation/
```

Where:

* **presentation** — Pages, widgets, and UI state.
* **domain** — Business rules and core feature logic.
* **data** — Data sources, repositories, models, and backend communication.

This separation should be introduced when needed rather than creating unnecessary layers for simple features.

### `shared/`

Contains reusable components used across multiple features.

```text
shared/
├── widgets/
├── models/
└── extensions/
```

Examples include:

* Reusable buttons
* Input fields
* Loading indicators
* Common cards
* Dialogs
* Shared models

A component should only be moved to `shared/` when it is actually used by multiple features.

---

## 4. Application Features

The patient mobile application is divided into the following primary features:

| Feature        | Responsibility                                                 |
| -------------- | -------------------------------------------------------------- |
| Authentication | Login, session management, and logout                          |
| Home           | Patient overview, latest reading, reminders, and quick actions |
| Readings       | Device connection and respiratory measurement process          |
| Charts         | Reading history, trends, and visualizations                    |
| Medications    | Medication information and reminders                           |
| Notifications  | System and healthcare-related notifications                    |
| Profile        | Patient information and application settings                   |

The main patient navigation consists of:

```text
Home → Reading → Charts → Profile
```

Authentication exists outside the main navigation and controls access to the patient application.

---

## 5. Backend Architecture

CPEMS uses **Supabase** as the backend platform with **PostgreSQL** as the underlying relational database.

The backend is responsible for:

* User authentication
* Patient data storage
* Respiratory reading storage
* Medication data
* Notifications
* Healthcare provider relationships
* Authorization and access control
* API access to application data

### Backend Flow

```text
Flutter
   │
   ▼
Supabase Client
   │
   ├── Authentication
   ├── Database API
   ├── Realtime (when required)
   └── Storage (when required)
           │
           ▼
      PostgreSQL
```

---

## 6. Data Flow

A typical respiratory measurement follows this flow:

```text
Patient
   │
   ▼
Starts Measurement
   │
   ▼
Medical Device
   │
   ▼
Flutter Application
   │
   ▼
Validate / Process Reading
   │
   ▼
Supabase
   │
   ▼
PostgreSQL
   │
   ├──────────────► Patient View
   │
   └──────────────► Healthcare Provider View
```

The exact device communication protocol will be documented separately once the device integration requirements are finalized.

---

## 7. Security Architecture

Because CPEMS handles healthcare-related information, security must be considered at every layer.

### Authentication

Supabase Auth is responsible for identifying authenticated users.

### Authorization

Database access must be controlled using PostgreSQL/Supabase **Row Level Security (RLS)**.

For example:

```text
Patient A → Patient A Data     ✓
Patient A → Patient B Data     ✗
```

Healthcare providers should only access patients assigned or authorized to them.

### Secrets

Sensitive credentials must never be hard-coded in the Flutter source code or committed to GitHub.

Environment configuration should be managed separately.

> Note: Values distributed inside a mobile application should not be treated as true secrets. Highly sensitive credentials must remain on trusted backend infrastructure.

---

## 8. Architecture Principles

Development should follow these principles:

### Separation of Concerns

UI, business logic, and data access should remain separated where appropriate.

### Feature Ownership

Code that belongs to one feature should remain inside that feature unless it is genuinely shared.

### Reusability

Repeated components should be extracted into reusable widgets or utilities.

### Single Responsibility

Each class, file, and component should have a clear responsibility.

### Scalability

The structure should allow new features to be introduced without requiring major changes to existing features.

### Maintainability

Naming, folder organization, and implementation patterns should remain consistent across the project.

### Security by Design

Authentication, authorization, sensitive data, and access policies should be considered during implementation rather than added only at the end.

---

## 9. Architecture Decisions

Current architectural decisions:

| Decision               | Choice             |
| ---------------------- | ------------------ |
| Mobile Framework       | Flutter            |
| Language               | Dart               |
| Project Organization   | Feature-based      |
| Backend                | Supabase           |
| Database               | PostgreSQL         |
| Authentication         | Supabase Auth      |
| Database Authorization | Row Level Security |
| Version Control        | Git                |
| Collaboration          | GitHub             |

Architecture decisions may evolve as system requirements become clearer.

Any major architectural change should be documented before or alongside its implementation.

---

## 10. Future Considerations

The architecture should remain flexible enough to support future capabilities such as:

* Medical device communication
* Realtime monitoring
* Push notifications
* Medication reminders
* Offline handling
* Emergency workflows
* Healthcare provider dashboard
* Report generation
* Advanced analytics

These capabilities should be introduced according to project requirements rather than implemented prematurely.
