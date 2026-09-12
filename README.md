# CPEMS

**Connected Peak Expiratory Measurement System (CPEMS)**

CPEMS is a healthcare monitoring system designed to support patients with chronic pulmonary conditions by enabling remote monitoring of respiratory readings and improving communication between patients and healthcare providers.

## Project Overview

The system consists of multiple components, including:

* **Mobile Application** — Used by patients to take and track respiratory readings, view their health data, manage medications, and communicate with healthcare providers.
* **Healthcare Provider System** — Used by healthcare providers to monitor patients, review readings, and generate reports.
* **Connected Medical Device** — Provides respiratory measurements that are transmitted to the system.

## Mobile Application

The mobile application is developed using **Flutter** and **Dart**.

### Main Features

* Patient authentication
* Home dashboard
* Medical device connection and status
* Respiratory reading process
* Reading history and charts
* Medication information and reminders
* Notifications
* Emergency/help request
* Patient profile

## Tech Stack

| Technology | Purpose                           |
| ---------- | --------------------------------- |
| Flutter    | Mobile application development    |
| Dart       | Programming language              |
| Supabase   | Backend services                  |
| PostgreSQL | Database                          |
| Git        | Version control                   |
| GitHub     | Repository and team collaboration |

## Project Structure

```text
lib/
├── core/
├── features/
├── shared/
└── main.dart
```

The project follows a **feature-based structure**, where each major application feature is organized separately to improve maintainability and scalability.

More detailed architecture documentation can be found in the `docs/` directory.

## Getting Started

### Prerequisites

Before running the project, make sure the following tools are installed:

- Flutter SDK
- Dart SDK
- Android Studio
- Android SDK
- VS Code or Android Studio
- Git

Verify your Flutter installation by running:

```bash
flutter doctor
```

Resolve any issues reported by Flutter Doctor before continuing.

---

### Installation

#### 1. Clone the repository

```bash
git clone <repository-url>
```

#### 2. Navigate to the project directory

```bash
cd cpems
```

#### 3. Install dependencies

```bash
flutter pub get
```

#### 4. Configure environment variables

Create a `.env` file in the project root based on:

```text
.env.example
```

Add the required environment variables to the `.env` file.

> Do not commit the `.env` file to GitHub because it may contain sensitive configuration values.

---

### Running the Application

The application can be run using either an Android emulator or a physical Android device.

#### Option 1 — Android Emulator

Android Studio is required to create and manage Android emulators.

1. Open **Android Studio**.
2. Go to **Device Manager**.
3. Click **Create Virtual Device** if no emulator exists.
4. Select a device, such as **Pixel**.
5. Select or download an Android system image.
6. Finish the emulator setup.
7. Start the emulator from **Device Manager**.

After the emulator starts, verify that Flutter detects it:

```bash
flutter devices
```

You should see the Android emulator in the list of available devices.

Then run the application:

```bash
flutter run
```

Alternatively, you can start an existing emulator from the terminal.

First, list available emulators:

```bash
flutter emulators
```

Then launch one:

```bash
flutter emulators --launch <emulator-id>
```

For example:

```bash
flutter emulators --launch flutter_emulator
```

Then run:

```bash
flutter run
```

#### Option 2 — Physical Android Device

1. Enable **Developer Options** on the Android device.
2. Enable **USB Debugging**.
3. Connect the device to the computer using USB.
4. Allow USB debugging when prompted on the device.
5. Verify that Flutter detects the device:

```bash
flutter devices
```

6. Run the application:

```bash
flutter run
```

---

### Development

For development with VS Code:

1. Open the project folder in VS Code.
2. Make sure the **Flutter** and **Dart** extensions are installed.
3. Start an Android emulator or connect a physical device.
4. Select the target device from the VS Code status bar.
5. Press `F5` to start debugging.

You can also run the application from the terminal:

```bash
flutter run
```

To stop the running application, press:

```text
q
```

## Environment Variables

Environment-specific configuration should not be committed directly to the repository.

Example:

```text
SUPABASE_URL=
SUPABASE_ANON_KEY=
```

Use `.env.example` to document the required variables without exposing sensitive credentials.

## Development Workflow

Development is performed using Git and GitHub.

General workflow:

```text
Create Issue / Task
       ↓
Create Branch
       ↓
Development
       ↓
Testing
       ↓
Pull Request
       ↓
Code Review
       ↓
Merge
```

Detailed Git and GitHub conventions are documented separately in the project documentation.


## Project Status

🚧 **Currently under development**

The project architecture and initial mobile application are currently being developed.

## Team

CPEMS Development Team
