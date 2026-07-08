import 'package:drift/drift.dart';

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  TextColumn get contactPerson => text()();
  TextColumn get company => text().withDefault(const Constant(''))();
  TextColumn get emails => text().withDefault(const Constant('[]'))();
  TextColumn get phones => text().withDefault(const Constant('[]'))();
  TextColumn get whatsapp => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get postalCode => text().withDefault(const Constant(''))();
  TextColumn get country => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  IntColumn get customerId => integer().references(Customers, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get budget => real().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get pricingType => text().withDefault(const Constant('fixed'))();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  TextColumn get status => text().withDefault(const Constant('not_started'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  TextColumn get invoiceNumber => text()();
  IntColumn get customerId => integer().references(Customers, #id)();
  IntColumn get projectId => integer().nullable().references(Projects, #id)();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  RealColumn get taxRate => real().withDefault(const Constant(0))();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get lineItems => text().withDefault(const Constant('[]'))();
  DateTimeColumn get issueDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class BusinessProfiles extends Table {
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get logoPath => text().nullable()();
  TextColumn get businessName => text().withDefault(const Constant(''))();
  TextColumn get businessEmail => text().withDefault(const Constant(''))();
  TextColumn get businessPhone => text().withDefault(const Constant(''))();
  TextColumn get ownerName => text().withDefault(const Constant(''))();
  TextColumn get ownerPhotoPath => text().nullable()();
  TextColumn get businessAddress => text().withDefault(const Constant(''))();
  TextColumn get businessCity => text().withDefault(const Constant(''))();
  TextColumn get businessPostalCode => text().withDefault(const Constant(''))();
  TextColumn get businessCountry => text().withDefault(const Constant(''))();
  TextColumn get skills => text().withDefault(const Constant('[]'))();
  TextColumn get bio => text().withDefault(const Constant(''))();
  TextColumn get clientCompany => text().withDefault(const Constant(''))();
  TextColumn get clientIndustry => text().withDefault(const Constant(''))();
  TextColumn get clientWebsite => text().withDefault(const Constant(''))();
  DateTimeColumn get memberSince => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {userId};
}

class InvoiceBrandings extends Table {
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get accentColor => text().withDefault(const Constant('#6C63FF'))();
  TextColumn get templateStyle => text().withDefault(const Constant('classic'))();
  BoolColumn get showLogo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {userId};
}

class AppSettingsTable extends Table {
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get themeMode => text().withDefault(const Constant('light'))();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get timezone => text().withDefault(const Constant('UTC'))();
  TextColumn get subscriptionPlan => text().withDefault(const Constant('free'))();

  @override
  Set<Column<Object>> get primaryKey => {userId};
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get projectId => integer().nullable().references(Projects, #id)();
  IntColumn get customerId => integer().nullable().references(Customers, #id)();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get category => text().withDefault(const Constant('other'))();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  IntColumn get projectId => integer().nullable().references(Projects, #id)();
  IntColumn get customerId => integer().nullable().references(Customers, #id)();
  TextColumn get vendor => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get expenseDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  TextColumn get title => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get type => text().withDefault(const Constant('personal'))();
  IntColumn get projectId => integer().nullable().references(Projects, #id)();
  IntColumn get customerId => integer().nullable().references(Customers, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  TextColumn get profilePhotoPath => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('user'))();
  TextColumn get accountType => text().withDefault(const Constant('freelancer'))();
  TextColumn get googleId => text().nullable()();
  BoolColumn get emailVerified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class AppAnalytics extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventType => text()();
  TextColumn get userEmail => text().withDefault(const Constant(''))();
  TextColumn get userName => text().withDefault(const Constant(''))();
  TextColumn get plan => text().withDefault(const Constant('free'))();
  RealColumn get amount => real().withDefault(const Constant(0))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get payload => text().withDefault(const Constant('{}'))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class MessageTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('email'))();
  TextColumn get category => text().withDefault(const Constant('general'))();
  TextColumn get subject => text().withDefault(const Constant(''))();
  TextColumn get body => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Contracts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  IntColumn get customerId => integer().references(Customers, #id)();
  TextColumn get title => text()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get content => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Status history for invoices and projects (tracking timeline).
class TrackingEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  TextColumn get entityType => text()();
  IntColumn get entityId => integer()();
  TextColumn get status => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Time-tracking sessions per project (start/stop timer).
class ProjectTimeEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  IntColumn get projectId => integer().references(Projects, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  TextColumn get note => text().withDefault(const Constant(''))();
}

/// Links a freelancer project to a client account (by email / user id).
class ProjectClientLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  IntColumn get freelancerUserId => integer().references(Users, #id)();
  TextColumn get clientEmail => text()();
  IntColumn get clientUserId => integer().nullable().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Messages between freelancer and client (in-app).
class ClientMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get fromUserId => integer().references(Users, #id)();
  IntColumn get toUserId => integer().references(Users, #id)();
  IntColumn get projectId => integer().nullable().references(Projects, #id)();
  TextColumn get subject => text().withDefault(const Constant(''))();
  TextColumn get body => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// File attachments linked to invoices, projects, contracts, customers.
class FileAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  TextColumn get entityType => text()();
  IntColumn get entityId => integer()();
  TextColumn get fileName => text()();
  TextColumn get localPath => text()();
  TextColumn get mimeType => text().withDefault(const Constant(''))();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Scheduled reminders and follow-ups.
class CalendarReminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  TextColumn get title => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get kind => text().withDefault(const Constant('reminder'))();
  IntColumn get linkedEntityId => integer().nullable()();
  TextColumn get linkedEntityType => text().withDefault(const Constant(''))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Team members invited by a freelancer.
class TeamMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUserId => integer().references(Users, #id)();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get role => text().withDefault(const Constant('member'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
