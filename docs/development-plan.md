# CPEMS Development Plan

The CPEMS mobile application will be developed in multiple stages to keep the implementation organized, maintainable, and easier to test.

Each phase will build on the previous one, starting with the project foundation and user interface before introducing backend services, device integration, and advanced functionality.

---

## Phase 1 — Project Setup

The first stage will establish the development environment and the initial application foundation.

### Tasks

* Create the Flutter project
* Configure VS Code and Android development tools
* Set up Git and GitHub
* Create the initial project structure
* Configure application theme and constants
* Prepare project documentation


### Expected Outcome

A clean Flutter project that can be successfully run and used by all developers.

---

## Phase 2 — Authentication UI, Navigation, and Basic Screens

The basic application flow and main navigation will be implemented.

The initial screens will include:

```text
Login
Home
Measurement
Charts
Profile
```

At this stage, the Login page will initially focus on the user interface and navigation flow.

Full authentication functionality will be integrated with Supabase during the backend integration phase.

After successful authentication, the patient will be directed to the main application, which contains four primary navigation sections:

```text
Home
Measurement
Charts
Profile
```

A bottom navigation bar will allow the patient to switch between these four main sections.

### Initial Application Flow

```text
Application Start
       ↓
Login
       ↓
Main Application
       ↓
Home / Measurement / Charts / Profile
```

At this stage, the focus will be on establishing:

* Application structure
* Screen flow
* Navigation
* Page organization

Backend functionality will not yet be required.

### Expected Outcome

The user can navigate between the major application screens using the intended application flow.

---

## Phase 3 — User Interface Development

The user interface of each page will be implemented based on the approved application design.

The Home page will be developed first, followed by:

1. Measurement
2. Charts
3. Profile
4. Medication-related interfaces

During this phase, temporary or mock data may be used to represent information that will later come from the backend.

Reusable widgets will be extracted when UI components are used in multiple locations.

Examples may include:

* Buttons
* Cards
* Status indicators
* Loading states
* Input fields
* Dialogs

### Expected Outcome

The primary patient application interface is complete and can be demonstrated without requiring a backend connection.

---

## Phase 4 — State and Data Models

After the main interface becomes stable, the application data structure will be introduced.

Initial models may include:

```text
Patient
Measurement
Device
Medication
Notification
```

The application state will also be managed so that UI components can react to changes in data.

Examples include:

* Logged-in patient information
* Device connection state
* Current measurement state
* Loading states
* Reading history
* Medication information

The selected state management approach should remain consistent throughout the application.

### Expected Outcome

The UI becomes driven by structured Dart data rather than hard-coded values.

---

## Phase 5 — Backend Integration

The application will then be connected to Supabase.

This phase will include:

* User authentication
* Patient data retrieval
* Measurement storage
* Reading history
* Medication data
* Notification-related data
* Communication with backend services

Data received from the backend will be converted into Dart models before being displayed in the UI.

### Backend Flow

```text
Flutter Application
        ↓
Supabase Client
        ↓
Authentication / Database API
        ↓
PostgreSQL
```

Backend security and access rules should also be configured during this stage.

### Expected Outcome

The application can authenticate users and retrieve or store real patient data.

---

## Phase 6 — Device Integration

Bluetooth Low Energy (BLE) integration will be implemented to connect the application with the respiratory measurement device.

The application will need to handle:

* Device discovery
* Device connection
* Connection status
* Battery status
* Measurement transmission
* Device disconnection
* Connection errors

The Bluetooth logic will be separated from the UI through dedicated services.

Example structure:

```text
UI
 ↓
Device Service
 ↓
Bluetooth Layer
 ↓
Respiratory Device
```

This separation will make the device integration easier to test, maintain, and replace if required.

### Expected Outcome

The application can discover, connect to, and communicate with the respiratory measurement device.

---

## Phase 7 — Measurement Workflow

The complete measurement process will then be implemented.

### Measurement Flow

```text
Check Device
     ↓
Connect Device
     ↓
Start Measurement
     ↓
Guide Patient
     ↓
Receive Reading
     ↓
Validate Reading
     ↓
Store Reading
     ↓
Display Result
```

The application should also handle unsuccessful measurement cases such as:

* Device disconnected
* Reading failed
* Invalid reading
* Measurement interrupted
* Communication error

The patient should receive clear feedback throughout the entire process.

### Expected Outcome

The patient can complete a full respiratory measurement from device connection to result display and storage.

---

## Phase 8 — Charts and Patient Monitoring

Stored respiratory readings will be displayed using charts and historical views.

The patient will be able to monitor changes in respiratory measurements over time.

Possible functionality includes:

* Historical readings
* Reading trends
* Date-based views
* Reading status indicators
* Comparison between previous measurements

Chart components should use data retrieved from the backend rather than static values.

### Expected Outcome

Patients can clearly review and understand their measurement history.

---

## Phase 9 — Notifications and Medication Reminders

Local notifications will be implemented for features such as:

* Medication reminders
* Scheduled respiratory measurements
* Important system notifications

The application should support:

* Notification permissions
* Scheduling reminders
* Updating reminders
* Disabling reminders
* Handling notification interactions

Backend-driven notifications may also be introduced later if required.

### Expected Outcome

Patients receive appropriate reminders related to their measurements, medications, and care activities.

---

## Phase 10 — Testing and Improvement

The final phase will focus on validating the application and improving overall quality.

Testing will include:

* UI testing
* Navigation testing
* Backend integration testing
* Authentication testing
* Bluetooth connection testing
* Measurement workflow testing
* Error handling
* Different screen sizes
* State management behavior
* Performance testing

The application should also be tested for scenarios such as:

```text
No Internet Connection
Device Not Found
Device Disconnected
Invalid Login
Backend Error
Empty Reading History
Notification Permission Denied
```

The application will be refined based on the results before deployment.

### Final Review

Before release, the team should verify:

* Code quality
* Project structure
* Security
* Error handling
* Accessibility
* Responsiveness
* Documentation
* GitHub repository status
* Backend policies
* Application performance

### Expected Outcome

A stable, tested, and documented version of the CPEMS mobile application that is ready for final deployment or project delivery.

---

## Development Flow Summary

```text
Project Setup
      ↓
Navigation & Basic Screens
      ↓
User Interface
      ↓
State & Data Models
      ↓
Backend Integration
      ↓
Device Integration
      ↓
Measurement Workflow
      ↓
Charts & Monitoring
      ↓
Notifications
      ↓
Testing & Improvement
```
