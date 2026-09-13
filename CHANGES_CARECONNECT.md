# CareConnect dynamic update

This revision makes the prototype data flow consistently through the app.

## Updated
- Doctor search filters by name/speciality.
- Doctor cards pass the selected doctor into Doctor Details.
- Doctor Details passes the same doctor into Book Appointment.
- Booking passes real doctor, speciality, fee, date, time and reason.
- Confirmed appointments appear on Home and My Appointments.
- Appointment reschedule/cancel updates the shared session data.
- Medication list uses shared dynamic data.
- Users can add medications.
- Medication Details displays the selected medication.
- Reminder setup stores medication, time, days and message.
- Home displays the latest medication reminder.
- Notifications are generated from current appointments/reminders.
- Signup/login update the displayed user details and include basic validation.
- Account page displays current user information and validates password fields.
- Fixed splash page filename casing to match main.dart import.

## Important limitation
The app currently uses in-memory shared data (`AppData`). Data is retained while the app session is running, but will reset after a full app restart. Production use would require persistent storage/backend authentication and real notification scheduling.
