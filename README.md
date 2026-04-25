# app@uniparthenope  

app@uniparthenope is a mobile application developed using Flutter, designed for students, faculty, and administrative staff of the University of Parthenope. The app provides a range of useful services such as viewing academic progress, accessing courses, managing university fees, an integrated weather service, and a library service.

## Features

- **Authentication**: Login using university credentials and FaceID.
- **Academic Progress**: View completed exams and academic path.
- **Courses**: Access courses for each academic year.
- **Fees**: Monitor the status of university fees.
- **Weather**: University of Parthenope weather service.
- **Room Availability (for Faculty)**: View and book classrooms.
- **Event Search (for Faculty)**: View events organized by the university.

## Technologies Used

- **Flutter**: Framework used for app development.
- **Provider**: State management for the app.
- **HTTP**: Communication with university backend services ([API's Uniparthenope](https://api.uniparthenope.it)).
- **Shared Preferences**: Securely saving login credentials.
- **Local Authentication**: Support for biometric authentication (fingerprint/face recognition).

## Installation

1. **Prerequisites**:
    - [Flutter](https://flutter.dev/docs/get-started/install) installed on your system.
    - A configured Android/iOS emulator or a connected physical device.

2. **Clone the Repository**:
    ```sh
    git clone https://github.com/carminecoppola/appUniParthenope.git
    cd UniParthenopeApp
    ```

3. **Install Dependencies**:
    ```sh
    flutter pub get
    ```

4. **Run the App**:
    ```sh
    flutter run
    ```

## Project Structure

- **lib/**: Contains the app source code.
  - **main.dart**: Entry point of the app.
  - **models/**: Data models.
  - **controller/**: Functions for proper data logic implementation.
  - **providers/**: State management providers.
  - **screens/**: App screens.
  - **services/**: Service functions to interact with the university API.
  - **utilityFunctions/**: Useful functions for widgets.
  - **widgets/**: Custom widgets used in the app.
  - **app_routes.dart**: Defined routes.

## Development Team

The **app@uniparthenope** application was developed by a team of students from the University of Naples "Parthenope", consisting of:

| Name                  | Role         |
|-----------------------|--------------|
| **Raffaele Montela**   | Team leader  |
| **Carmine Coppola**    | Developer    |

The team has worked with dedication to provide an innovative and accessible solution for the entire academic community.

## Contributing

Contributions, bug reports, and feature requests are welcome!

1. Fork the project
2. Create a branch for your feature (`git checkout -b feature/feature-name`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/feature-name`)
5. Open a Pull Request

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For further information, questions, or suggestions, contact me at: [carminecoppola917@gmail.com](mailto:carminecoppola917@gmail.com).
