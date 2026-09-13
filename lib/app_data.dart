import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String speciality;
  final double rating;
  final int experienceYears;
  final String patients;
  final String about;
  final String location;
  final double fee;
  final bool availableToday;

  const Doctor({
    required this.name,
    required this.speciality,
    required this.rating,
    required this.experienceYears,
    required this.patients,
    required this.about,
    required this.location,
    required this.fee,
    this.availableToday = true,
  });
}

class Appointment {
  final String doctorName;
  final String speciality;
  final String date;
  final String time;
  final String reason;
  final double fee;

  const Appointment({
    required this.doctorName,
    required this.speciality,
    required this.date,
    required this.time,
    required this.reason,
    required this.fee,
  });
}

class Medication {
  final String name;
  final String dose;
  final String frequency;
  final String instructions;

  const Medication({
    required this.name,
    required this.dose,
    required this.frequency,
    required this.instructions,
  });
}

class MedicationReminder {
  final String medicineName;
  final String dosage;
  final TimeOfDay time;
  final List<String> days;
  final String message;

  const MedicationReminder({
    required this.medicineName,
    required this.dosage,
    required this.time,
    required this.days,
    required this.message,
  });
}

class AppData {
  static const List<Doctor> doctors = [
    Doctor(
      name: 'Dr Sarah Wilson',
      speciality: 'General Practitioner',
      rating: 4.9,
      experienceYears: 8,
      patients: '500+',
      about: 'An experienced General Practitioner providing patient-centred healthcare, preventive care and general medical consultations.',
      location: '32 Street, CareConnect Medical, Auburn',
      fee: 60,
    ),
    Doctor(
      name: 'Dr James Lee',
      speciality: 'Dentist',
      rating: 4.8,
      experienceYears: 10,
      patients: '700+',
      about: 'A dental practitioner focused on preventive dentistry, oral health checks and comfortable patient care.',
      location: '18 Queen Street, CareConnect Dental, Parramatta',
      fee: 75,
    ),
    Doctor(
      name: 'Dr Emma Brown',
      speciality: 'Dermatologist',
      rating: 4.7,
      experienceYears: 7,
      patients: '420+',
      about: 'A dermatologist providing consultations for common skin conditions, skin checks and ongoing skin-care management.',
      location: '7 Park Road, CareConnect Skin Clinic, Westmead',
      fee: 90,
    ),
    Doctor(
      name: 'Dr Michael Chen',
      speciality: 'General Practitioner',
      rating: 4.9,
      experienceYears: 12,
      patients: '900+',
      about: 'A General Practitioner with broad experience in family medicine, health screening and chronic-condition support.',
      location: '41 George Street, CareConnect Medical, Sydney',
      fee: 65,
    ),
  ];

  static final List<Appointment> appointments = [];

  static final List<Medication> medications = [
    const Medication(
      name: 'Amoxicillin',
      dose: '500 mg',
      frequency: 'Twice Daily',
      instructions: 'Take after food with water',
    ),
    const Medication(
      name: 'Paracetamol',
      dose: '500 mg',
      frequency: 'As Required',
      instructions: 'Take only as directed on the label or by your clinician',
    ),
  ];

  static final List<MedicationReminder> reminders = [];

  static String userName = 'Sam';
  static String userEmail = 'sam@example.com';
  static String userPhone = '+61 4XX XXX XXX';
  static bool appointmentNotifications = true;
  static bool medicationNotifications = true;
  static bool healthTips = false;

  static void addAppointment(Appointment appointment) => appointments.add(appointment);

  static void updateAppointment(int index, Appointment appointment) {
    if (index >= 0 && index < appointments.length) appointments[index] = appointment;
  }

  static void removeAppointment(int index) {
    if (index >= 0 && index < appointments.length) appointments.removeAt(index);
  }

  static void addMedication(Medication medication) => medications.add(medication);

  static void addReminder(MedicationReminder reminder) {
    reminders.removeWhere((r) => r.medicineName == reminder.medicineName);
    reminders.add(reminder);
  }

  static void removeReminder(int index) {
    if (index >= 0 && index < reminders.length) reminders.removeAt(index);
  }

  static String formatTime(BuildContext context, TimeOfDay time) => time.format(context);
}
