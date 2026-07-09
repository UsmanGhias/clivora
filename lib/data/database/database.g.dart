// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profilePhotoPathMeta = const VerificationMeta(
    'profilePhotoPath',
  );
  @override
  late final GeneratedColumn<String> profilePhotoPath = GeneratedColumn<String>(
    'profile_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user'),
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('freelancer'),
  );
  static const VerificationMeta _googleIdMeta = const VerificationMeta(
    'googleId',
  );
  @override
  late final GeneratedColumn<String> googleId = GeneratedColumn<String>(
    'google_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailVerifiedMeta = const VerificationMeta(
    'emailVerified',
  );
  @override
  late final GeneratedColumn<bool> emailVerified = GeneratedColumn<bool>(
    'email_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("email_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    passwordHash,
    name,
    profilePhotoPath,
    role,
    accountType,
    googleId,
    emailVerified,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('profile_photo_path')) {
      context.handle(
        _profilePhotoPathMeta,
        profilePhotoPath.isAcceptableOrUnknown(
          data['profile_photo_path']!,
          _profilePhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    }
    if (data.containsKey('google_id')) {
      context.handle(
        _googleIdMeta,
        googleId.isAcceptableOrUnknown(data['google_id']!, _googleIdMeta),
      );
    }
    if (data.containsKey('email_verified')) {
      context.handle(
        _emailVerifiedMeta,
        emailVerified.isAcceptableOrUnknown(
          data['email_verified']!,
          _emailVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      profilePhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_photo_path'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      googleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_id'],
      ),
      emailVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}email_verified'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String email;
  final String passwordHash;
  final String name;
  final String? profilePhotoPath;
  final String role;
  final String accountType;
  final String? googleId;
  final bool emailVerified;
  final DateTime createdAt;
  const User({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.name,
    this.profilePhotoPath,
    required this.role,
    required this.accountType,
    this.googleId,
    required this.emailVerified,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || profilePhotoPath != null) {
      map['profile_photo_path'] = Variable<String>(profilePhotoPath);
    }
    map['role'] = Variable<String>(role);
    map['account_type'] = Variable<String>(accountType);
    if (!nullToAbsent || googleId != null) {
      map['google_id'] = Variable<String>(googleId);
    }
    map['email_verified'] = Variable<bool>(emailVerified);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      passwordHash: Value(passwordHash),
      name: Value(name),
      profilePhotoPath: profilePhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePhotoPath),
      role: Value(role),
      accountType: Value(accountType),
      googleId: googleId == null && nullToAbsent
          ? const Value.absent()
          : Value(googleId),
      emailVerified: Value(emailVerified),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      name: serializer.fromJson<String>(json['name']),
      profilePhotoPath: serializer.fromJson<String?>(json['profilePhotoPath']),
      role: serializer.fromJson<String>(json['role']),
      accountType: serializer.fromJson<String>(json['accountType']),
      googleId: serializer.fromJson<String?>(json['googleId']),
      emailVerified: serializer.fromJson<bool>(json['emailVerified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'name': serializer.toJson<String>(name),
      'profilePhotoPath': serializer.toJson<String?>(profilePhotoPath),
      'role': serializer.toJson<String>(role),
      'accountType': serializer.toJson<String>(accountType),
      'googleId': serializer.toJson<String?>(googleId),
      'emailVerified': serializer.toJson<bool>(emailVerified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith({
    int? id,
    String? email,
    String? passwordHash,
    String? name,
    Value<String?> profilePhotoPath = const Value.absent(),
    String? role,
    String? accountType,
    Value<String?> googleId = const Value.absent(),
    bool? emailVerified,
    DateTime? createdAt,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    passwordHash: passwordHash ?? this.passwordHash,
    name: name ?? this.name,
    profilePhotoPath: profilePhotoPath.present
        ? profilePhotoPath.value
        : this.profilePhotoPath,
    role: role ?? this.role,
    accountType: accountType ?? this.accountType,
    googleId: googleId.present ? googleId.value : this.googleId,
    emailVerified: emailVerified ?? this.emailVerified,
    createdAt: createdAt ?? this.createdAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      name: data.name.present ? data.name.value : this.name,
      profilePhotoPath: data.profilePhotoPath.present
          ? data.profilePhotoPath.value
          : this.profilePhotoPath,
      role: data.role.present ? data.role.value : this.role,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      googleId: data.googleId.present ? data.googleId.value : this.googleId,
      emailVerified: data.emailVerified.present
          ? data.emailVerified.value
          : this.emailVerified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('name: $name, ')
          ..write('profilePhotoPath: $profilePhotoPath, ')
          ..write('role: $role, ')
          ..write('accountType: $accountType, ')
          ..write('googleId: $googleId, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    passwordHash,
    name,
    profilePhotoPath,
    role,
    accountType,
    googleId,
    emailVerified,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.name == this.name &&
          other.profilePhotoPath == this.profilePhotoPath &&
          other.role == this.role &&
          other.accountType == this.accountType &&
          other.googleId == this.googleId &&
          other.emailVerified == this.emailVerified &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String> name;
  final Value<String?> profilePhotoPath;
  final Value<String> role;
  final Value<String> accountType;
  final Value<String?> googleId;
  final Value<bool> emailVerified;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.name = const Value.absent(),
    this.profilePhotoPath = const Value.absent(),
    this.role = const Value.absent(),
    this.accountType = const Value.absent(),
    this.googleId = const Value.absent(),
    this.emailVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    this.passwordHash = const Value.absent(),
    required String name,
    this.profilePhotoPath = const Value.absent(),
    this.role = const Value.absent(),
    this.accountType = const Value.absent(),
    this.googleId = const Value.absent(),
    this.emailVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : email = Value(email),
       name = Value(name);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? name,
    Expression<String>? profilePhotoPath,
    Expression<String>? role,
    Expression<String>? accountType,
    Expression<String>? googleId,
    Expression<bool>? emailVerified,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (name != null) 'name': name,
      if (profilePhotoPath != null) 'profile_photo_path': profilePhotoPath,
      if (role != null) 'role': role,
      if (accountType != null) 'account_type': accountType,
      if (googleId != null) 'google_id': googleId,
      if (emailVerified != null) 'email_verified': emailVerified,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? email,
    Value<String>? passwordHash,
    Value<String>? name,
    Value<String?>? profilePhotoPath,
    Value<String>? role,
    Value<String>? accountType,
    Value<String?>? googleId,
    Value<bool>? emailVerified,
    Value<DateTime>? createdAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      name: name ?? this.name,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      role: role ?? this.role,
      accountType: accountType ?? this.accountType,
      googleId: googleId ?? this.googleId,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (profilePhotoPath.present) {
      map['profile_photo_path'] = Variable<String>(profilePhotoPath.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (googleId.present) {
      map['google_id'] = Variable<String>(googleId.value);
    }
    if (emailVerified.present) {
      map['email_verified'] = Variable<bool>(emailVerified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('name: $name, ')
          ..write('profilePhotoPath: $profilePhotoPath, ')
          ..write('role: $role, ')
          ..write('accountType: $accountType, ')
          ..write('googleId: $googleId, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _contactPersonMeta = const VerificationMeta(
    'contactPerson',
  );
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
    'contact_person',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailsMeta = const VerificationMeta('emails');
  @override
  late final GeneratedColumn<String> emails = GeneratedColumn<String>(
    'emails',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _phonesMeta = const VerificationMeta('phones');
  @override
  late final GeneratedColumn<String> phones = GeneratedColumn<String>(
    'phones',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _whatsappMeta = const VerificationMeta(
    'whatsapp',
  );
  @override
  late final GeneratedColumn<String> whatsapp = GeneratedColumn<String>(
    'whatsapp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _postalCodeMeta = const VerificationMeta(
    'postalCode',
  );
  @override
  late final GeneratedColumn<String> postalCode = GeneratedColumn<String>(
    'postal_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    contactPerson,
    company,
    emails,
    phones,
    whatsapp,
    address,
    city,
    postalCode,
    country,
    notes,
    tags,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('contact_person')) {
      context.handle(
        _contactPersonMeta,
        contactPerson.isAcceptableOrUnknown(
          data['contact_person']!,
          _contactPersonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contactPersonMeta);
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('emails')) {
      context.handle(
        _emailsMeta,
        emails.isAcceptableOrUnknown(data['emails']!, _emailsMeta),
      );
    }
    if (data.containsKey('phones')) {
      context.handle(
        _phonesMeta,
        phones.isAcceptableOrUnknown(data['phones']!, _phonesMeta),
      );
    }
    if (data.containsKey('whatsapp')) {
      context.handle(
        _whatsappMeta,
        whatsapp.isAcceptableOrUnknown(data['whatsapp']!, _whatsappMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('postal_code')) {
      context.handle(
        _postalCodeMeta,
        postalCode.isAcceptableOrUnknown(data['postal_code']!, _postalCodeMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      contactPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      )!,
      emails: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emails'],
      )!,
      phones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phones'],
      )!,
      whatsapp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      postalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}postal_code'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final int ownerUserId;
  final String contactPerson;
  final String company;
  final String emails;
  final String phones;
  final String whatsapp;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String notes;
  final String tags;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Customer({
    required this.id,
    required this.ownerUserId,
    required this.contactPerson,
    required this.company,
    required this.emails,
    required this.phones,
    required this.whatsapp,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.notes,
    required this.tags,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['contact_person'] = Variable<String>(contactPerson);
    map['company'] = Variable<String>(company);
    map['emails'] = Variable<String>(emails);
    map['phones'] = Variable<String>(phones);
    map['whatsapp'] = Variable<String>(whatsapp);
    map['address'] = Variable<String>(address);
    map['city'] = Variable<String>(city);
    map['postal_code'] = Variable<String>(postalCode);
    map['country'] = Variable<String>(country);
    map['notes'] = Variable<String>(notes);
    map['tags'] = Variable<String>(tags);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      contactPerson: Value(contactPerson),
      company: Value(company),
      emails: Value(emails),
      phones: Value(phones),
      whatsapp: Value(whatsapp),
      address: Value(address),
      city: Value(city),
      postalCode: Value(postalCode),
      country: Value(country),
      notes: Value(notes),
      tags: Value(tags),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      contactPerson: serializer.fromJson<String>(json['contactPerson']),
      company: serializer.fromJson<String>(json['company']),
      emails: serializer.fromJson<String>(json['emails']),
      phones: serializer.fromJson<String>(json['phones']),
      whatsapp: serializer.fromJson<String>(json['whatsapp']),
      address: serializer.fromJson<String>(json['address']),
      city: serializer.fromJson<String>(json['city']),
      postalCode: serializer.fromJson<String>(json['postalCode']),
      country: serializer.fromJson<String>(json['country']),
      notes: serializer.fromJson<String>(json['notes']),
      tags: serializer.fromJson<String>(json['tags']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'contactPerson': serializer.toJson<String>(contactPerson),
      'company': serializer.toJson<String>(company),
      'emails': serializer.toJson<String>(emails),
      'phones': serializer.toJson<String>(phones),
      'whatsapp': serializer.toJson<String>(whatsapp),
      'address': serializer.toJson<String>(address),
      'city': serializer.toJson<String>(city),
      'postalCode': serializer.toJson<String>(postalCode),
      'country': serializer.toJson<String>(country),
      'notes': serializer.toJson<String>(notes),
      'tags': serializer.toJson<String>(tags),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith({
    int? id,
    int? ownerUserId,
    String? contactPerson,
    String? company,
    String? emails,
    String? phones,
    String? whatsapp,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    String? notes,
    String? tags,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Customer(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    contactPerson: contactPerson ?? this.contactPerson,
    company: company ?? this.company,
    emails: emails ?? this.emails,
    phones: phones ?? this.phones,
    whatsapp: whatsapp ?? this.whatsapp,
    address: address ?? this.address,
    city: city ?? this.city,
    postalCode: postalCode ?? this.postalCode,
    country: country ?? this.country,
    notes: notes ?? this.notes,
    tags: tags ?? this.tags,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
      company: data.company.present ? data.company.value : this.company,
      emails: data.emails.present ? data.emails.value : this.emails,
      phones: data.phones.present ? data.phones.value : this.phones,
      whatsapp: data.whatsapp.present ? data.whatsapp.value : this.whatsapp,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      postalCode: data.postalCode.present
          ? data.postalCode.value
          : this.postalCode,
      country: data.country.present ? data.country.value : this.country,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('company: $company, ')
          ..write('emails: $emails, ')
          ..write('phones: $phones, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('postalCode: $postalCode, ')
          ..write('country: $country, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    contactPerson,
    company,
    emails,
    phones,
    whatsapp,
    address,
    city,
    postalCode,
    country,
    notes,
    tags,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.contactPerson == this.contactPerson &&
          other.company == this.company &&
          other.emails == this.emails &&
          other.phones == this.phones &&
          other.whatsapp == this.whatsapp &&
          other.address == this.address &&
          other.city == this.city &&
          other.postalCode == this.postalCode &&
          other.country == this.country &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<String> contactPerson;
  final Value<String> company;
  final Value<String> emails;
  final Value<String> phones;
  final Value<String> whatsapp;
  final Value<String> address;
  final Value<String> city;
  final Value<String> postalCode;
  final Value<String> country;
  final Value<String> notes;
  final Value<String> tags;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.company = const Value.absent(),
    this.emails = const Value.absent(),
    this.phones = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.country = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required String contactPerson,
    this.company = const Value.absent(),
    this.emails = const Value.absent(),
    this.phones = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.country = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       contactPerson = Value(contactPerson);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<String>? contactPerson,
    Expression<String>? company,
    Expression<String>? emails,
    Expression<String>? phones,
    Expression<String>? whatsapp,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? postalCode,
    Expression<String>? country,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (company != null) 'company': company,
      if (emails != null) 'emails': emails,
      if (phones != null) 'phones': phones,
      if (whatsapp != null) 'whatsapp': whatsapp,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (postalCode != null) 'postal_code': postalCode,
      if (country != null) 'country': country,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<String>? contactPerson,
    Value<String>? company,
    Value<String>? emails,
    Value<String>? phones,
    Value<String>? whatsapp,
    Value<String>? address,
    Value<String>? city,
    Value<String>? postalCode,
    Value<String>? country,
    Value<String>? notes,
    Value<String>? tags,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      contactPerson: contactPerson ?? this.contactPerson,
      company: company ?? this.company,
      emails: emails ?? this.emails,
      phones: phones ?? this.phones,
      whatsapp: whatsapp ?? this.whatsapp,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (emails.present) {
      map['emails'] = Variable<String>(emails.value);
    }
    if (phones.present) {
      map['phones'] = Variable<String>(phones.value);
    }
    if (whatsapp.present) {
      map['whatsapp'] = Variable<String>(whatsapp.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (postalCode.present) {
      map['postal_code'] = Variable<String>(postalCode.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('company: $company, ')
          ..write('emails: $emails, ')
          ..write('phones: $phones, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('postalCode: $postalCode, ')
          ..write('country: $country, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<double> budget = GeneratedColumn<double>(
    'budget',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _pricingTypeMeta = const VerificationMeta(
    'pricingType',
  );
  @override
  late final GeneratedColumn<String> pricingType = GeneratedColumn<String>(
    'pricing_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fixed'),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('not_started'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    customerId,
    name,
    description,
    budget,
    currency,
    pricingType,
    startDate,
    deadline,
    priority,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('budget')) {
      context.handle(
        _budgetMeta,
        budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('pricing_type')) {
      context.handle(
        _pricingTypeMeta,
        pricingType.isAcceptableOrUnknown(
          data['pricing_type']!,
          _pricingTypeMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      budget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}budget'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      pricingType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pricing_type'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final int id;
  final int ownerUserId;
  final int customerId;
  final String name;
  final String description;
  final double budget;
  final String currency;
  final String pricingType;
  final DateTime? startDate;
  final DateTime? deadline;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Project({
    required this.id,
    required this.ownerUserId,
    required this.customerId,
    required this.name,
    required this.description,
    required this.budget,
    required this.currency,
    required this.pricingType,
    this.startDate,
    this.deadline,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['customer_id'] = Variable<int>(customerId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['budget'] = Variable<double>(budget);
    map['currency'] = Variable<String>(currency);
    map['pricing_type'] = Variable<String>(pricingType);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      customerId: Value(customerId),
      name: Value(name),
      description: Value(description),
      budget: Value(budget),
      currency: Value(currency),
      pricingType: Value(pricingType),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      priority: Value(priority),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      customerId: serializer.fromJson<int>(json['customerId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      budget: serializer.fromJson<double>(json['budget']),
      currency: serializer.fromJson<String>(json['currency']),
      pricingType: serializer.fromJson<String>(json['pricingType']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'customerId': serializer.toJson<int>(customerId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'budget': serializer.toJson<double>(budget),
      'currency': serializer.toJson<String>(currency),
      'pricingType': serializer.toJson<String>(pricingType),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Project copyWith({
    int? id,
    int? ownerUserId,
    int? customerId,
    String? name,
    String? description,
    double? budget,
    String? currency,
    String? pricingType,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> deadline = const Value.absent(),
    String? priority,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Project(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    customerId: customerId ?? this.customerId,
    name: name ?? this.name,
    description: description ?? this.description,
    budget: budget ?? this.budget,
    currency: currency ?? this.currency,
    pricingType: pricingType ?? this.pricingType,
    startDate: startDate.present ? startDate.value : this.startDate,
    deadline: deadline.present ? deadline.value : this.deadline,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      budget: data.budget.present ? data.budget.value : this.budget,
      currency: data.currency.present ? data.currency.value : this.currency,
      pricingType: data.pricingType.present
          ? data.pricingType.value
          : this.pricingType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('customerId: $customerId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('budget: $budget, ')
          ..write('currency: $currency, ')
          ..write('pricingType: $pricingType, ')
          ..write('startDate: $startDate, ')
          ..write('deadline: $deadline, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    customerId,
    name,
    description,
    budget,
    currency,
    pricingType,
    startDate,
    deadline,
    priority,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.customerId == this.customerId &&
          other.name == this.name &&
          other.description == this.description &&
          other.budget == this.budget &&
          other.currency == this.currency &&
          other.pricingType == this.pricingType &&
          other.startDate == this.startDate &&
          other.deadline == this.deadline &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<int> customerId;
  final Value<String> name;
  final Value<String> description;
  final Value<double> budget;
  final Value<String> currency;
  final Value<String> pricingType;
  final Value<DateTime?> startDate;
  final Value<DateTime?> deadline;
  final Value<String> priority;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.budget = const Value.absent(),
    this.currency = const Value.absent(),
    this.pricingType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.deadline = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required int customerId,
    required String name,
    this.description = const Value.absent(),
    this.budget = const Value.absent(),
    this.currency = const Value.absent(),
    this.pricingType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.deadline = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       customerId = Value(customerId),
       name = Value(name);
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<int>? customerId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? budget,
    Expression<String>? currency,
    Expression<String>? pricingType,
    Expression<DateTime>? startDate,
    Expression<DateTime>? deadline,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (customerId != null) 'customer_id': customerId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (budget != null) 'budget': budget,
      if (currency != null) 'currency': currency,
      if (pricingType != null) 'pricing_type': pricingType,
      if (startDate != null) 'start_date': startDate,
      if (deadline != null) 'deadline': deadline,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<int>? customerId,
    Value<String>? name,
    Value<String>? description,
    Value<double>? budget,
    Value<String>? currency,
    Value<String>? pricingType,
    Value<DateTime?>? startDate,
    Value<DateTime?>? deadline,
    Value<String>? priority,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      pricingType: pricingType ?? this.pricingType,
      startDate: startDate ?? this.startDate,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (budget.present) {
      map['budget'] = Variable<double>(budget.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (pricingType.present) {
      map['pricing_type'] = Variable<String>(pricingType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('customerId: $customerId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('budget: $budget, ')
          ..write('currency: $currency, ')
          ..write('pricingType: $pricingType, ')
          ..write('startDate: $startDate, ')
          ..write('deadline: $deadline, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _lineItemsMeta = const VerificationMeta(
    'lineItems',
  );
  @override
  late final GeneratedColumn<String> lineItems = GeneratedColumn<String>(
    'line_items',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _issueDateMeta = const VerificationMeta(
    'issueDate',
  );
  @override
  late final GeneratedColumn<DateTime> issueDate = GeneratedColumn<DateTime>(
    'issue_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    invoiceNumber,
    customerId,
    projectId,
    status,
    subtotal,
    taxRate,
    discount,
    total,
    currency,
    lineItems,
    issueDate,
    dueDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('line_items')) {
      context.handle(
        _lineItemsMeta,
        lineItems.isAcceptableOrUnknown(data['line_items']!, _lineItemsMeta),
      );
    }
    if (data.containsKey('issue_date')) {
      context.handle(
        _issueDateMeta,
        issueDate.isAcceptableOrUnknown(data['issue_date']!, _issueDateMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      lineItems: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line_items'],
      )!,
      issueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}issue_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final int id;
  final int ownerUserId;
  final String invoiceNumber;
  final int customerId;
  final int? projectId;
  final String status;
  final double subtotal;
  final double taxRate;
  final double discount;
  final double total;
  final String currency;
  final String lineItems;
  final DateTime issueDate;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Invoice({
    required this.id,
    required this.ownerUserId,
    required this.invoiceNumber,
    required this.customerId,
    this.projectId,
    required this.status,
    required this.subtotal,
    required this.taxRate,
    required this.discount,
    required this.total,
    required this.currency,
    required this.lineItems,
    required this.issueDate,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['customer_id'] = Variable<int>(customerId);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    map['status'] = Variable<String>(status);
    map['subtotal'] = Variable<double>(subtotal);
    map['tax_rate'] = Variable<double>(taxRate);
    map['discount'] = Variable<double>(discount);
    map['total'] = Variable<double>(total);
    map['currency'] = Variable<String>(currency);
    map['line_items'] = Variable<String>(lineItems);
    map['issue_date'] = Variable<DateTime>(issueDate);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      invoiceNumber: Value(invoiceNumber),
      customerId: Value(customerId),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      status: Value(status),
      subtotal: Value(subtotal),
      taxRate: Value(taxRate),
      discount: Value(discount),
      total: Value(total),
      currency: Value(currency),
      lineItems: Value(lineItems),
      issueDate: Value(issueDate),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      customerId: serializer.fromJson<int>(json['customerId']),
      projectId: serializer.fromJson<int?>(json['projectId']),
      status: serializer.fromJson<String>(json['status']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      discount: serializer.fromJson<double>(json['discount']),
      total: serializer.fromJson<double>(json['total']),
      currency: serializer.fromJson<String>(json['currency']),
      lineItems: serializer.fromJson<String>(json['lineItems']),
      issueDate: serializer.fromJson<DateTime>(json['issueDate']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'customerId': serializer.toJson<int>(customerId),
      'projectId': serializer.toJson<int?>(projectId),
      'status': serializer.toJson<String>(status),
      'subtotal': serializer.toJson<double>(subtotal),
      'taxRate': serializer.toJson<double>(taxRate),
      'discount': serializer.toJson<double>(discount),
      'total': serializer.toJson<double>(total),
      'currency': serializer.toJson<String>(currency),
      'lineItems': serializer.toJson<String>(lineItems),
      'issueDate': serializer.toJson<DateTime>(issueDate),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Invoice copyWith({
    int? id,
    int? ownerUserId,
    String? invoiceNumber,
    int? customerId,
    Value<int?> projectId = const Value.absent(),
    String? status,
    double? subtotal,
    double? taxRate,
    double? discount,
    double? total,
    String? currency,
    String? lineItems,
    DateTime? issueDate,
    Value<DateTime?> dueDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Invoice(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    customerId: customerId ?? this.customerId,
    projectId: projectId.present ? projectId.value : this.projectId,
    status: status ?? this.status,
    subtotal: subtotal ?? this.subtotal,
    taxRate: taxRate ?? this.taxRate,
    discount: discount ?? this.discount,
    total: total ?? this.total,
    currency: currency ?? this.currency,
    lineItems: lineItems ?? this.lineItems,
    issueDate: issueDate ?? this.issueDate,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      status: data.status.present ? data.status.value : this.status,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      discount: data.discount.present ? data.discount.value : this.discount,
      total: data.total.present ? data.total.value : this.total,
      currency: data.currency.present ? data.currency.value : this.currency,
      lineItems: data.lineItems.present ? data.lineItems.value : this.lineItems,
      issueDate: data.issueDate.present ? data.issueDate.value : this.issueDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('projectId: $projectId, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxRate: $taxRate, ')
          ..write('discount: $discount, ')
          ..write('total: $total, ')
          ..write('currency: $currency, ')
          ..write('lineItems: $lineItems, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    invoiceNumber,
    customerId,
    projectId,
    status,
    subtotal,
    taxRate,
    discount,
    total,
    currency,
    lineItems,
    issueDate,
    dueDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.customerId == this.customerId &&
          other.projectId == this.projectId &&
          other.status == this.status &&
          other.subtotal == this.subtotal &&
          other.taxRate == this.taxRate &&
          other.discount == this.discount &&
          other.total == this.total &&
          other.currency == this.currency &&
          other.lineItems == this.lineItems &&
          other.issueDate == this.issueDate &&
          other.dueDate == this.dueDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<String> invoiceNumber;
  final Value<int> customerId;
  final Value<int?> projectId;
  final Value<String> status;
  final Value<double> subtotal;
  final Value<double> taxRate;
  final Value<double> discount;
  final Value<double> total;
  final Value<String> currency;
  final Value<String> lineItems;
  final Value<DateTime> issueDate;
  final Value<DateTime?> dueDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.discount = const Value.absent(),
    this.total = const Value.absent(),
    this.currency = const Value.absent(),
    this.lineItems = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required String invoiceNumber,
    required int customerId,
    this.projectId = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.discount = const Value.absent(),
    this.total = const Value.absent(),
    this.currency = const Value.absent(),
    this.lineItems = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       invoiceNumber = Value(invoiceNumber),
       customerId = Value(customerId);
  static Insertable<Invoice> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<String>? invoiceNumber,
    Expression<int>? customerId,
    Expression<int>? projectId,
    Expression<String>? status,
    Expression<double>? subtotal,
    Expression<double>? taxRate,
    Expression<double>? discount,
    Expression<double>? total,
    Expression<String>? currency,
    Expression<String>? lineItems,
    Expression<DateTime>? issueDate,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (customerId != null) 'customer_id': customerId,
      if (projectId != null) 'project_id': projectId,
      if (status != null) 'status': status,
      if (subtotal != null) 'subtotal': subtotal,
      if (taxRate != null) 'tax_rate': taxRate,
      if (discount != null) 'discount': discount,
      if (total != null) 'total': total,
      if (currency != null) 'currency': currency,
      if (lineItems != null) 'line_items': lineItems,
      if (issueDate != null) 'issue_date': issueDate,
      if (dueDate != null) 'due_date': dueDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InvoicesCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<String>? invoiceNumber,
    Value<int>? customerId,
    Value<int?>? projectId,
    Value<String>? status,
    Value<double>? subtotal,
    Value<double>? taxRate,
    Value<double>? discount,
    Value<double>? total,
    Value<String>? currency,
    Value<String>? lineItems,
    Value<DateTime>? issueDate,
    Value<DateTime?>? dueDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerId: customerId ?? this.customerId,
      projectId: projectId ?? this.projectId,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      taxRate: taxRate ?? this.taxRate,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      lineItems: lineItems ?? this.lineItems,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (lineItems.present) {
      map['line_items'] = Variable<String>(lineItems.value);
    }
    if (issueDate.present) {
      map['issue_date'] = Variable<DateTime>(issueDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('projectId: $projectId, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxRate: $taxRate, ')
          ..write('discount: $discount, ')
          ..write('total: $total, ')
          ..write('currency: $currency, ')
          ..write('lineItems: $lineItems, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BusinessProfilesTable extends BusinessProfiles
    with TableInfo<$BusinessProfilesTable, BusinessProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _businessNameMeta = const VerificationMeta(
    'businessName',
  );
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
    'business_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _businessEmailMeta = const VerificationMeta(
    'businessEmail',
  );
  @override
  late final GeneratedColumn<String> businessEmail = GeneratedColumn<String>(
    'business_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _businessPhoneMeta = const VerificationMeta(
    'businessPhone',
  );
  @override
  late final GeneratedColumn<String> businessPhone = GeneratedColumn<String>(
    'business_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ownerNameMeta = const VerificationMeta(
    'ownerName',
  );
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
    'owner_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ownerPhotoPathMeta = const VerificationMeta(
    'ownerPhotoPath',
  );
  @override
  late final GeneratedColumn<String> ownerPhotoPath = GeneratedColumn<String>(
    'owner_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _businessAddressMeta = const VerificationMeta(
    'businessAddress',
  );
  @override
  late final GeneratedColumn<String> businessAddress = GeneratedColumn<String>(
    'business_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _businessCityMeta = const VerificationMeta(
    'businessCity',
  );
  @override
  late final GeneratedColumn<String> businessCity = GeneratedColumn<String>(
    'business_city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _businessPostalCodeMeta =
      const VerificationMeta('businessPostalCode');
  @override
  late final GeneratedColumn<String> businessPostalCode =
      GeneratedColumn<String>(
        'business_postal_code',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _businessCountryMeta = const VerificationMeta(
    'businessCountry',
  );
  @override
  late final GeneratedColumn<String> businessCountry = GeneratedColumn<String>(
    'business_country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _skillsMeta = const VerificationMeta('skills');
  @override
  late final GeneratedColumn<String> skills = GeneratedColumn<String>(
    'skills',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _clientCompanyMeta = const VerificationMeta(
    'clientCompany',
  );
  @override
  late final GeneratedColumn<String> clientCompany = GeneratedColumn<String>(
    'client_company',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _clientIndustryMeta = const VerificationMeta(
    'clientIndustry',
  );
  @override
  late final GeneratedColumn<String> clientIndustry = GeneratedColumn<String>(
    'client_industry',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _clientWebsiteMeta = const VerificationMeta(
    'clientWebsite',
  );
  @override
  late final GeneratedColumn<String> clientWebsite = GeneratedColumn<String>(
    'client_website',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _memberSinceMeta = const VerificationMeta(
    'memberSince',
  );
  @override
  late final GeneratedColumn<DateTime> memberSince = GeneratedColumn<DateTime>(
    'member_since',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    logoPath,
    businessName,
    businessEmail,
    businessPhone,
    ownerName,
    ownerPhotoPath,
    businessAddress,
    businessCity,
    businessPostalCode,
    businessCountry,
    skills,
    bio,
    clientCompany,
    clientIndustry,
    clientWebsite,
    memberSince,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusinessProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('business_name')) {
      context.handle(
        _businessNameMeta,
        businessName.isAcceptableOrUnknown(
          data['business_name']!,
          _businessNameMeta,
        ),
      );
    }
    if (data.containsKey('business_email')) {
      context.handle(
        _businessEmailMeta,
        businessEmail.isAcceptableOrUnknown(
          data['business_email']!,
          _businessEmailMeta,
        ),
      );
    }
    if (data.containsKey('business_phone')) {
      context.handle(
        _businessPhoneMeta,
        businessPhone.isAcceptableOrUnknown(
          data['business_phone']!,
          _businessPhoneMeta,
        ),
      );
    }
    if (data.containsKey('owner_name')) {
      context.handle(
        _ownerNameMeta,
        ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta),
      );
    }
    if (data.containsKey('owner_photo_path')) {
      context.handle(
        _ownerPhotoPathMeta,
        ownerPhotoPath.isAcceptableOrUnknown(
          data['owner_photo_path']!,
          _ownerPhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('business_address')) {
      context.handle(
        _businessAddressMeta,
        businessAddress.isAcceptableOrUnknown(
          data['business_address']!,
          _businessAddressMeta,
        ),
      );
    }
    if (data.containsKey('business_city')) {
      context.handle(
        _businessCityMeta,
        businessCity.isAcceptableOrUnknown(
          data['business_city']!,
          _businessCityMeta,
        ),
      );
    }
    if (data.containsKey('business_postal_code')) {
      context.handle(
        _businessPostalCodeMeta,
        businessPostalCode.isAcceptableOrUnknown(
          data['business_postal_code']!,
          _businessPostalCodeMeta,
        ),
      );
    }
    if (data.containsKey('business_country')) {
      context.handle(
        _businessCountryMeta,
        businessCountry.isAcceptableOrUnknown(
          data['business_country']!,
          _businessCountryMeta,
        ),
      );
    }
    if (data.containsKey('skills')) {
      context.handle(
        _skillsMeta,
        skills.isAcceptableOrUnknown(data['skills']!, _skillsMeta),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('client_company')) {
      context.handle(
        _clientCompanyMeta,
        clientCompany.isAcceptableOrUnknown(
          data['client_company']!,
          _clientCompanyMeta,
        ),
      );
    }
    if (data.containsKey('client_industry')) {
      context.handle(
        _clientIndustryMeta,
        clientIndustry.isAcceptableOrUnknown(
          data['client_industry']!,
          _clientIndustryMeta,
        ),
      );
    }
    if (data.containsKey('client_website')) {
      context.handle(
        _clientWebsiteMeta,
        clientWebsite.isAcceptableOrUnknown(
          data['client_website']!,
          _clientWebsiteMeta,
        ),
      );
    }
    if (data.containsKey('member_since')) {
      context.handle(
        _memberSinceMeta,
        memberSince.isAcceptableOrUnknown(
          data['member_since']!,
          _memberSinceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  BusinessProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessProfile(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      businessName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_name'],
      )!,
      businessEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_email'],
      )!,
      businessPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_phone'],
      )!,
      ownerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_name'],
      )!,
      ownerPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_photo_path'],
      ),
      businessAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_address'],
      )!,
      businessCity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_city'],
      )!,
      businessPostalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_postal_code'],
      )!,
      businessCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_country'],
      )!,
      skills: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skills'],
      )!,
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      )!,
      clientCompany: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_company'],
      )!,
      clientIndustry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_industry'],
      )!,
      clientWebsite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_website'],
      )!,
      memberSince: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}member_since'],
      )!,
    );
  }

  @override
  $BusinessProfilesTable createAlias(String alias) {
    return $BusinessProfilesTable(attachedDatabase, alias);
  }
}

class BusinessProfile extends DataClass implements Insertable<BusinessProfile> {
  final int userId;
  final String? logoPath;
  final String businessName;
  final String businessEmail;
  final String businessPhone;
  final String ownerName;
  final String? ownerPhotoPath;
  final String businessAddress;
  final String businessCity;
  final String businessPostalCode;
  final String businessCountry;
  final String skills;
  final String bio;
  final String clientCompany;
  final String clientIndustry;
  final String clientWebsite;
  final DateTime memberSince;
  const BusinessProfile({
    required this.userId,
    this.logoPath,
    required this.businessName,
    required this.businessEmail,
    required this.businessPhone,
    required this.ownerName,
    this.ownerPhotoPath,
    required this.businessAddress,
    required this.businessCity,
    required this.businessPostalCode,
    required this.businessCountry,
    required this.skills,
    required this.bio,
    required this.clientCompany,
    required this.clientIndustry,
    required this.clientWebsite,
    required this.memberSince,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['business_name'] = Variable<String>(businessName);
    map['business_email'] = Variable<String>(businessEmail);
    map['business_phone'] = Variable<String>(businessPhone);
    map['owner_name'] = Variable<String>(ownerName);
    if (!nullToAbsent || ownerPhotoPath != null) {
      map['owner_photo_path'] = Variable<String>(ownerPhotoPath);
    }
    map['business_address'] = Variable<String>(businessAddress);
    map['business_city'] = Variable<String>(businessCity);
    map['business_postal_code'] = Variable<String>(businessPostalCode);
    map['business_country'] = Variable<String>(businessCountry);
    map['skills'] = Variable<String>(skills);
    map['bio'] = Variable<String>(bio);
    map['client_company'] = Variable<String>(clientCompany);
    map['client_industry'] = Variable<String>(clientIndustry);
    map['client_website'] = Variable<String>(clientWebsite);
    map['member_since'] = Variable<DateTime>(memberSince);
    return map;
  }

  BusinessProfilesCompanion toCompanion(bool nullToAbsent) {
    return BusinessProfilesCompanion(
      userId: Value(userId),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      businessName: Value(businessName),
      businessEmail: Value(businessEmail),
      businessPhone: Value(businessPhone),
      ownerName: Value(ownerName),
      ownerPhotoPath: ownerPhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerPhotoPath),
      businessAddress: Value(businessAddress),
      businessCity: Value(businessCity),
      businessPostalCode: Value(businessPostalCode),
      businessCountry: Value(businessCountry),
      skills: Value(skills),
      bio: Value(bio),
      clientCompany: Value(clientCompany),
      clientIndustry: Value(clientIndustry),
      clientWebsite: Value(clientWebsite),
      memberSince: Value(memberSince),
    );
  }

  factory BusinessProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessProfile(
      userId: serializer.fromJson<int>(json['userId']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      businessName: serializer.fromJson<String>(json['businessName']),
      businessEmail: serializer.fromJson<String>(json['businessEmail']),
      businessPhone: serializer.fromJson<String>(json['businessPhone']),
      ownerName: serializer.fromJson<String>(json['ownerName']),
      ownerPhotoPath: serializer.fromJson<String?>(json['ownerPhotoPath']),
      businessAddress: serializer.fromJson<String>(json['businessAddress']),
      businessCity: serializer.fromJson<String>(json['businessCity']),
      businessPostalCode: serializer.fromJson<String>(
        json['businessPostalCode'],
      ),
      businessCountry: serializer.fromJson<String>(json['businessCountry']),
      skills: serializer.fromJson<String>(json['skills']),
      bio: serializer.fromJson<String>(json['bio']),
      clientCompany: serializer.fromJson<String>(json['clientCompany']),
      clientIndustry: serializer.fromJson<String>(json['clientIndustry']),
      clientWebsite: serializer.fromJson<String>(json['clientWebsite']),
      memberSince: serializer.fromJson<DateTime>(json['memberSince']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'logoPath': serializer.toJson<String?>(logoPath),
      'businessName': serializer.toJson<String>(businessName),
      'businessEmail': serializer.toJson<String>(businessEmail),
      'businessPhone': serializer.toJson<String>(businessPhone),
      'ownerName': serializer.toJson<String>(ownerName),
      'ownerPhotoPath': serializer.toJson<String?>(ownerPhotoPath),
      'businessAddress': serializer.toJson<String>(businessAddress),
      'businessCity': serializer.toJson<String>(businessCity),
      'businessPostalCode': serializer.toJson<String>(businessPostalCode),
      'businessCountry': serializer.toJson<String>(businessCountry),
      'skills': serializer.toJson<String>(skills),
      'bio': serializer.toJson<String>(bio),
      'clientCompany': serializer.toJson<String>(clientCompany),
      'clientIndustry': serializer.toJson<String>(clientIndustry),
      'clientWebsite': serializer.toJson<String>(clientWebsite),
      'memberSince': serializer.toJson<DateTime>(memberSince),
    };
  }

  BusinessProfile copyWith({
    int? userId,
    Value<String?> logoPath = const Value.absent(),
    String? businessName,
    String? businessEmail,
    String? businessPhone,
    String? ownerName,
    Value<String?> ownerPhotoPath = const Value.absent(),
    String? businessAddress,
    String? businessCity,
    String? businessPostalCode,
    String? businessCountry,
    String? skills,
    String? bio,
    String? clientCompany,
    String? clientIndustry,
    String? clientWebsite,
    DateTime? memberSince,
  }) => BusinessProfile(
    userId: userId ?? this.userId,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    businessName: businessName ?? this.businessName,
    businessEmail: businessEmail ?? this.businessEmail,
    businessPhone: businessPhone ?? this.businessPhone,
    ownerName: ownerName ?? this.ownerName,
    ownerPhotoPath: ownerPhotoPath.present
        ? ownerPhotoPath.value
        : this.ownerPhotoPath,
    businessAddress: businessAddress ?? this.businessAddress,
    businessCity: businessCity ?? this.businessCity,
    businessPostalCode: businessPostalCode ?? this.businessPostalCode,
    businessCountry: businessCountry ?? this.businessCountry,
    skills: skills ?? this.skills,
    bio: bio ?? this.bio,
    clientCompany: clientCompany ?? this.clientCompany,
    clientIndustry: clientIndustry ?? this.clientIndustry,
    clientWebsite: clientWebsite ?? this.clientWebsite,
    memberSince: memberSince ?? this.memberSince,
  );
  BusinessProfile copyWithCompanion(BusinessProfilesCompanion data) {
    return BusinessProfile(
      userId: data.userId.present ? data.userId.value : this.userId,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      businessEmail: data.businessEmail.present
          ? data.businessEmail.value
          : this.businessEmail,
      businessPhone: data.businessPhone.present
          ? data.businessPhone.value
          : this.businessPhone,
      ownerName: data.ownerName.present ? data.ownerName.value : this.ownerName,
      ownerPhotoPath: data.ownerPhotoPath.present
          ? data.ownerPhotoPath.value
          : this.ownerPhotoPath,
      businessAddress: data.businessAddress.present
          ? data.businessAddress.value
          : this.businessAddress,
      businessCity: data.businessCity.present
          ? data.businessCity.value
          : this.businessCity,
      businessPostalCode: data.businessPostalCode.present
          ? data.businessPostalCode.value
          : this.businessPostalCode,
      businessCountry: data.businessCountry.present
          ? data.businessCountry.value
          : this.businessCountry,
      skills: data.skills.present ? data.skills.value : this.skills,
      bio: data.bio.present ? data.bio.value : this.bio,
      clientCompany: data.clientCompany.present
          ? data.clientCompany.value
          : this.clientCompany,
      clientIndustry: data.clientIndustry.present
          ? data.clientIndustry.value
          : this.clientIndustry,
      clientWebsite: data.clientWebsite.present
          ? data.clientWebsite.value
          : this.clientWebsite,
      memberSince: data.memberSince.present
          ? data.memberSince.value
          : this.memberSince,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfile(')
          ..write('userId: $userId, ')
          ..write('logoPath: $logoPath, ')
          ..write('businessName: $businessName, ')
          ..write('businessEmail: $businessEmail, ')
          ..write('businessPhone: $businessPhone, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerPhotoPath: $ownerPhotoPath, ')
          ..write('businessAddress: $businessAddress, ')
          ..write('businessCity: $businessCity, ')
          ..write('businessPostalCode: $businessPostalCode, ')
          ..write('businessCountry: $businessCountry, ')
          ..write('skills: $skills, ')
          ..write('bio: $bio, ')
          ..write('clientCompany: $clientCompany, ')
          ..write('clientIndustry: $clientIndustry, ')
          ..write('clientWebsite: $clientWebsite, ')
          ..write('memberSince: $memberSince')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    logoPath,
    businessName,
    businessEmail,
    businessPhone,
    ownerName,
    ownerPhotoPath,
    businessAddress,
    businessCity,
    businessPostalCode,
    businessCountry,
    skills,
    bio,
    clientCompany,
    clientIndustry,
    clientWebsite,
    memberSince,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessProfile &&
          other.userId == this.userId &&
          other.logoPath == this.logoPath &&
          other.businessName == this.businessName &&
          other.businessEmail == this.businessEmail &&
          other.businessPhone == this.businessPhone &&
          other.ownerName == this.ownerName &&
          other.ownerPhotoPath == this.ownerPhotoPath &&
          other.businessAddress == this.businessAddress &&
          other.businessCity == this.businessCity &&
          other.businessPostalCode == this.businessPostalCode &&
          other.businessCountry == this.businessCountry &&
          other.skills == this.skills &&
          other.bio == this.bio &&
          other.clientCompany == this.clientCompany &&
          other.clientIndustry == this.clientIndustry &&
          other.clientWebsite == this.clientWebsite &&
          other.memberSince == this.memberSince);
}

class BusinessProfilesCompanion extends UpdateCompanion<BusinessProfile> {
  final Value<int> userId;
  final Value<String?> logoPath;
  final Value<String> businessName;
  final Value<String> businessEmail;
  final Value<String> businessPhone;
  final Value<String> ownerName;
  final Value<String?> ownerPhotoPath;
  final Value<String> businessAddress;
  final Value<String> businessCity;
  final Value<String> businessPostalCode;
  final Value<String> businessCountry;
  final Value<String> skills;
  final Value<String> bio;
  final Value<String> clientCompany;
  final Value<String> clientIndustry;
  final Value<String> clientWebsite;
  final Value<DateTime> memberSince;
  const BusinessProfilesCompanion({
    this.userId = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.businessName = const Value.absent(),
    this.businessEmail = const Value.absent(),
    this.businessPhone = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.ownerPhotoPath = const Value.absent(),
    this.businessAddress = const Value.absent(),
    this.businessCity = const Value.absent(),
    this.businessPostalCode = const Value.absent(),
    this.businessCountry = const Value.absent(),
    this.skills = const Value.absent(),
    this.bio = const Value.absent(),
    this.clientCompany = const Value.absent(),
    this.clientIndustry = const Value.absent(),
    this.clientWebsite = const Value.absent(),
    this.memberSince = const Value.absent(),
  });
  BusinessProfilesCompanion.insert({
    this.userId = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.businessName = const Value.absent(),
    this.businessEmail = const Value.absent(),
    this.businessPhone = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.ownerPhotoPath = const Value.absent(),
    this.businessAddress = const Value.absent(),
    this.businessCity = const Value.absent(),
    this.businessPostalCode = const Value.absent(),
    this.businessCountry = const Value.absent(),
    this.skills = const Value.absent(),
    this.bio = const Value.absent(),
    this.clientCompany = const Value.absent(),
    this.clientIndustry = const Value.absent(),
    this.clientWebsite = const Value.absent(),
    this.memberSince = const Value.absent(),
  });
  static Insertable<BusinessProfile> custom({
    Expression<int>? userId,
    Expression<String>? logoPath,
    Expression<String>? businessName,
    Expression<String>? businessEmail,
    Expression<String>? businessPhone,
    Expression<String>? ownerName,
    Expression<String>? ownerPhotoPath,
    Expression<String>? businessAddress,
    Expression<String>? businessCity,
    Expression<String>? businessPostalCode,
    Expression<String>? businessCountry,
    Expression<String>? skills,
    Expression<String>? bio,
    Expression<String>? clientCompany,
    Expression<String>? clientIndustry,
    Expression<String>? clientWebsite,
    Expression<DateTime>? memberSince,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (logoPath != null) 'logo_path': logoPath,
      if (businessName != null) 'business_name': businessName,
      if (businessEmail != null) 'business_email': businessEmail,
      if (businessPhone != null) 'business_phone': businessPhone,
      if (ownerName != null) 'owner_name': ownerName,
      if (ownerPhotoPath != null) 'owner_photo_path': ownerPhotoPath,
      if (businessAddress != null) 'business_address': businessAddress,
      if (businessCity != null) 'business_city': businessCity,
      if (businessPostalCode != null)
        'business_postal_code': businessPostalCode,
      if (businessCountry != null) 'business_country': businessCountry,
      if (skills != null) 'skills': skills,
      if (bio != null) 'bio': bio,
      if (clientCompany != null) 'client_company': clientCompany,
      if (clientIndustry != null) 'client_industry': clientIndustry,
      if (clientWebsite != null) 'client_website': clientWebsite,
      if (memberSince != null) 'member_since': memberSince,
    });
  }

  BusinessProfilesCompanion copyWith({
    Value<int>? userId,
    Value<String?>? logoPath,
    Value<String>? businessName,
    Value<String>? businessEmail,
    Value<String>? businessPhone,
    Value<String>? ownerName,
    Value<String?>? ownerPhotoPath,
    Value<String>? businessAddress,
    Value<String>? businessCity,
    Value<String>? businessPostalCode,
    Value<String>? businessCountry,
    Value<String>? skills,
    Value<String>? bio,
    Value<String>? clientCompany,
    Value<String>? clientIndustry,
    Value<String>? clientWebsite,
    Value<DateTime>? memberSince,
  }) {
    return BusinessProfilesCompanion(
      userId: userId ?? this.userId,
      logoPath: logoPath ?? this.logoPath,
      businessName: businessName ?? this.businessName,
      businessEmail: businessEmail ?? this.businessEmail,
      businessPhone: businessPhone ?? this.businessPhone,
      ownerName: ownerName ?? this.ownerName,
      ownerPhotoPath: ownerPhotoPath ?? this.ownerPhotoPath,
      businessAddress: businessAddress ?? this.businessAddress,
      businessCity: businessCity ?? this.businessCity,
      businessPostalCode: businessPostalCode ?? this.businessPostalCode,
      businessCountry: businessCountry ?? this.businessCountry,
      skills: skills ?? this.skills,
      bio: bio ?? this.bio,
      clientCompany: clientCompany ?? this.clientCompany,
      clientIndustry: clientIndustry ?? this.clientIndustry,
      clientWebsite: clientWebsite ?? this.clientWebsite,
      memberSince: memberSince ?? this.memberSince,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (businessEmail.present) {
      map['business_email'] = Variable<String>(businessEmail.value);
    }
    if (businessPhone.present) {
      map['business_phone'] = Variable<String>(businessPhone.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (ownerPhotoPath.present) {
      map['owner_photo_path'] = Variable<String>(ownerPhotoPath.value);
    }
    if (businessAddress.present) {
      map['business_address'] = Variable<String>(businessAddress.value);
    }
    if (businessCity.present) {
      map['business_city'] = Variable<String>(businessCity.value);
    }
    if (businessPostalCode.present) {
      map['business_postal_code'] = Variable<String>(businessPostalCode.value);
    }
    if (businessCountry.present) {
      map['business_country'] = Variable<String>(businessCountry.value);
    }
    if (skills.present) {
      map['skills'] = Variable<String>(skills.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (clientCompany.present) {
      map['client_company'] = Variable<String>(clientCompany.value);
    }
    if (clientIndustry.present) {
      map['client_industry'] = Variable<String>(clientIndustry.value);
    }
    if (clientWebsite.present) {
      map['client_website'] = Variable<String>(clientWebsite.value);
    }
    if (memberSince.present) {
      map['member_since'] = Variable<DateTime>(memberSince.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfilesCompanion(')
          ..write('userId: $userId, ')
          ..write('logoPath: $logoPath, ')
          ..write('businessName: $businessName, ')
          ..write('businessEmail: $businessEmail, ')
          ..write('businessPhone: $businessPhone, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerPhotoPath: $ownerPhotoPath, ')
          ..write('businessAddress: $businessAddress, ')
          ..write('businessCity: $businessCity, ')
          ..write('businessPostalCode: $businessPostalCode, ')
          ..write('businessCountry: $businessCountry, ')
          ..write('skills: $skills, ')
          ..write('bio: $bio, ')
          ..write('clientCompany: $clientCompany, ')
          ..write('clientIndustry: $clientIndustry, ')
          ..write('clientWebsite: $clientWebsite, ')
          ..write('memberSince: $memberSince')
          ..write(')'))
        .toString();
  }
}

class $InvoiceBrandingsTable extends InvoiceBrandings
    with TableInfo<$InvoiceBrandingsTable, InvoiceBranding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceBrandingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _accentColorMeta = const VerificationMeta(
    'accentColor',
  );
  @override
  late final GeneratedColumn<String> accentColor = GeneratedColumn<String>(
    'accent_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#6C63FF'),
  );
  static const VerificationMeta _templateStyleMeta = const VerificationMeta(
    'templateStyle',
  );
  @override
  late final GeneratedColumn<String> templateStyle = GeneratedColumn<String>(
    'template_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('classic'),
  );
  static const VerificationMeta _showLogoMeta = const VerificationMeta(
    'showLogo',
  );
  @override
  late final GeneratedColumn<bool> showLogo = GeneratedColumn<bool>(
    'show_logo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_logo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    accentColor,
    templateStyle,
    showLogo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_brandings';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceBranding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('accent_color')) {
      context.handle(
        _accentColorMeta,
        accentColor.isAcceptableOrUnknown(
          data['accent_color']!,
          _accentColorMeta,
        ),
      );
    }
    if (data.containsKey('template_style')) {
      context.handle(
        _templateStyleMeta,
        templateStyle.isAcceptableOrUnknown(
          data['template_style']!,
          _templateStyleMeta,
        ),
      );
    }
    if (data.containsKey('show_logo')) {
      context.handle(
        _showLogoMeta,
        showLogo.isAcceptableOrUnknown(data['show_logo']!, _showLogoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  InvoiceBranding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceBranding(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      accentColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent_color'],
      )!,
      templateStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_style'],
      )!,
      showLogo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_logo'],
      )!,
    );
  }

  @override
  $InvoiceBrandingsTable createAlias(String alias) {
    return $InvoiceBrandingsTable(attachedDatabase, alias);
  }
}

class InvoiceBranding extends DataClass implements Insertable<InvoiceBranding> {
  final int userId;
  final String accentColor;
  final String templateStyle;
  final bool showLogo;
  const InvoiceBranding({
    required this.userId,
    required this.accentColor,
    required this.templateStyle,
    required this.showLogo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['accent_color'] = Variable<String>(accentColor);
    map['template_style'] = Variable<String>(templateStyle);
    map['show_logo'] = Variable<bool>(showLogo);
    return map;
  }

  InvoiceBrandingsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceBrandingsCompanion(
      userId: Value(userId),
      accentColor: Value(accentColor),
      templateStyle: Value(templateStyle),
      showLogo: Value(showLogo),
    );
  }

  factory InvoiceBranding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceBranding(
      userId: serializer.fromJson<int>(json['userId']),
      accentColor: serializer.fromJson<String>(json['accentColor']),
      templateStyle: serializer.fromJson<String>(json['templateStyle']),
      showLogo: serializer.fromJson<bool>(json['showLogo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'accentColor': serializer.toJson<String>(accentColor),
      'templateStyle': serializer.toJson<String>(templateStyle),
      'showLogo': serializer.toJson<bool>(showLogo),
    };
  }

  InvoiceBranding copyWith({
    int? userId,
    String? accentColor,
    String? templateStyle,
    bool? showLogo,
  }) => InvoiceBranding(
    userId: userId ?? this.userId,
    accentColor: accentColor ?? this.accentColor,
    templateStyle: templateStyle ?? this.templateStyle,
    showLogo: showLogo ?? this.showLogo,
  );
  InvoiceBranding copyWithCompanion(InvoiceBrandingsCompanion data) {
    return InvoiceBranding(
      userId: data.userId.present ? data.userId.value : this.userId,
      accentColor: data.accentColor.present
          ? data.accentColor.value
          : this.accentColor,
      templateStyle: data.templateStyle.present
          ? data.templateStyle.value
          : this.templateStyle,
      showLogo: data.showLogo.present ? data.showLogo.value : this.showLogo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceBranding(')
          ..write('userId: $userId, ')
          ..write('accentColor: $accentColor, ')
          ..write('templateStyle: $templateStyle, ')
          ..write('showLogo: $showLogo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, accentColor, templateStyle, showLogo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceBranding &&
          other.userId == this.userId &&
          other.accentColor == this.accentColor &&
          other.templateStyle == this.templateStyle &&
          other.showLogo == this.showLogo);
}

class InvoiceBrandingsCompanion extends UpdateCompanion<InvoiceBranding> {
  final Value<int> userId;
  final Value<String> accentColor;
  final Value<String> templateStyle;
  final Value<bool> showLogo;
  const InvoiceBrandingsCompanion({
    this.userId = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.templateStyle = const Value.absent(),
    this.showLogo = const Value.absent(),
  });
  InvoiceBrandingsCompanion.insert({
    this.userId = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.templateStyle = const Value.absent(),
    this.showLogo = const Value.absent(),
  });
  static Insertable<InvoiceBranding> custom({
    Expression<int>? userId,
    Expression<String>? accentColor,
    Expression<String>? templateStyle,
    Expression<bool>? showLogo,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (accentColor != null) 'accent_color': accentColor,
      if (templateStyle != null) 'template_style': templateStyle,
      if (showLogo != null) 'show_logo': showLogo,
    });
  }

  InvoiceBrandingsCompanion copyWith({
    Value<int>? userId,
    Value<String>? accentColor,
    Value<String>? templateStyle,
    Value<bool>? showLogo,
  }) {
    return InvoiceBrandingsCompanion(
      userId: userId ?? this.userId,
      accentColor: accentColor ?? this.accentColor,
      templateStyle: templateStyle ?? this.templateStyle,
      showLogo: showLogo ?? this.showLogo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (accentColor.present) {
      map['accent_color'] = Variable<String>(accentColor.value);
    }
    if (templateStyle.present) {
      map['template_style'] = Variable<String>(templateStyle.value);
    }
    if (showLogo.present) {
      map['show_logo'] = Variable<bool>(showLogo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceBrandingsCompanion(')
          ..write('userId: $userId, ')
          ..write('accentColor: $accentColor, ')
          ..write('templateStyle: $templateStyle, ')
          ..write('showLogo: $showLogo')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('light'),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UTC'),
  );
  static const VerificationMeta _subscriptionPlanMeta = const VerificationMeta(
    'subscriptionPlan',
  );
  @override
  late final GeneratedColumn<String> subscriptionPlan = GeneratedColumn<String>(
    'subscription_plan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('free'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    themeMode,
    currency,
    timezone,
    subscriptionPlan,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    if (data.containsKey('subscription_plan')) {
      context.handle(
        _subscriptionPlanMeta,
        subscriptionPlan.isAcceptableOrUnknown(
          data['subscription_plan']!,
          _subscriptionPlanMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      subscriptionPlan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_plan'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final int userId;
  final String themeMode;
  final String currency;
  final String timezone;
  final String subscriptionPlan;
  const AppSettingsTableData({
    required this.userId,
    required this.themeMode,
    required this.currency,
    required this.timezone,
    required this.subscriptionPlan,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['theme_mode'] = Variable<String>(themeMode);
    map['currency'] = Variable<String>(currency);
    map['timezone'] = Variable<String>(timezone);
    map['subscription_plan'] = Variable<String>(subscriptionPlan);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      userId: Value(userId),
      themeMode: Value(themeMode),
      currency: Value(currency),
      timezone: Value(timezone),
      subscriptionPlan: Value(subscriptionPlan),
    );
  }

  factory AppSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      userId: serializer.fromJson<int>(json['userId']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      currency: serializer.fromJson<String>(json['currency']),
      timezone: serializer.fromJson<String>(json['timezone']),
      subscriptionPlan: serializer.fromJson<String>(json['subscriptionPlan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'themeMode': serializer.toJson<String>(themeMode),
      'currency': serializer.toJson<String>(currency),
      'timezone': serializer.toJson<String>(timezone),
      'subscriptionPlan': serializer.toJson<String>(subscriptionPlan),
    };
  }

  AppSettingsTableData copyWith({
    int? userId,
    String? themeMode,
    String? currency,
    String? timezone,
    String? subscriptionPlan,
  }) => AppSettingsTableData(
    userId: userId ?? this.userId,
    themeMode: themeMode ?? this.themeMode,
    currency: currency ?? this.currency,
    timezone: timezone ?? this.timezone,
    subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
  );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      currency: data.currency.present ? data.currency.value : this.currency,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      subscriptionPlan: data.subscriptionPlan.present
          ? data.subscriptionPlan.value
          : this.subscriptionPlan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('userId: $userId, ')
          ..write('themeMode: $themeMode, ')
          ..write('currency: $currency, ')
          ..write('timezone: $timezone, ')
          ..write('subscriptionPlan: $subscriptionPlan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, themeMode, currency, timezone, subscriptionPlan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.userId == this.userId &&
          other.themeMode == this.themeMode &&
          other.currency == this.currency &&
          other.timezone == this.timezone &&
          other.subscriptionPlan == this.subscriptionPlan);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<int> userId;
  final Value<String> themeMode;
  final Value<String> currency;
  final Value<String> timezone;
  final Value<String> subscriptionPlan;
  const AppSettingsTableCompanion({
    this.userId = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.currency = const Value.absent(),
    this.timezone = const Value.absent(),
    this.subscriptionPlan = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.userId = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.currency = const Value.absent(),
    this.timezone = const Value.absent(),
    this.subscriptionPlan = const Value.absent(),
  });
  static Insertable<AppSettingsTableData> custom({
    Expression<int>? userId,
    Expression<String>? themeMode,
    Expression<String>? currency,
    Expression<String>? timezone,
    Expression<String>? subscriptionPlan,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (themeMode != null) 'theme_mode': themeMode,
      if (currency != null) 'currency': currency,
      if (timezone != null) 'timezone': timezone,
      if (subscriptionPlan != null) 'subscription_plan': subscriptionPlan,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<int>? userId,
    Value<String>? themeMode,
    Value<String>? currency,
    Value<String>? timezone,
    Value<String>? subscriptionPlan,
  }) {
    return AppSettingsTableCompanion(
      userId: userId ?? this.userId,
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (subscriptionPlan.present) {
      map['subscription_plan'] = Variable<String>(subscriptionPlan.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('themeMode: $themeMode, ')
          ..write('currency: $currency, ')
          ..write('timezone: $timezone, ')
          ..write('subscriptionPlan: $subscriptionPlan')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    title,
    description,
    projectId,
    customerId,
    priority,
    status,
    dueDate,
    completed,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final int ownerUserId;
  final String title;
  final String description;
  final int? projectId;
  final int? customerId;
  final String priority;
  final String status;
  final DateTime? dueDate;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Task({
    required this.id,
    required this.ownerUserId,
    required this.title,
    required this.description,
    this.projectId,
    this.customerId,
    required this.priority,
    required this.status,
    this.dueDate,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['completed'] = Variable<bool>(completed);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      title: Value(title),
      description: Value(description),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      priority: Value(priority),
      status: Value(status),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      completed: Value(completed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      projectId: serializer.fromJson<int?>(json['projectId']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      completed: serializer.fromJson<bool>(json['completed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'projectId': serializer.toJson<int?>(projectId),
      'customerId': serializer.toJson<int?>(customerId),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'completed': serializer.toJson<bool>(completed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Task copyWith({
    int? id,
    int? ownerUserId,
    String? title,
    String? description,
    Value<int?> projectId = const Value.absent(),
    Value<int?> customerId = const Value.absent(),
    String? priority,
    String? status,
    Value<DateTime?> dueDate = const Value.absent(),
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Task(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    title: title ?? this.title,
    description: description ?? this.description,
    projectId: projectId.present ? projectId.value : this.projectId,
    customerId: customerId.present ? customerId.value : this.customerId,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    completed: completed ?? this.completed,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      completed: data.completed.present ? data.completed.value : this.completed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('projectId: $projectId, ')
          ..write('customerId: $customerId, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('completed: $completed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    title,
    description,
    projectId,
    customerId,
    priority,
    status,
    dueDate,
    completed,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.title == this.title &&
          other.description == this.description &&
          other.projectId == this.projectId &&
          other.customerId == this.customerId &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.dueDate == this.dueDate &&
          other.completed == this.completed &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<String> title;
  final Value<String> description;
  final Value<int?> projectId;
  final Value<int?> customerId;
  final Value<String> priority;
  final Value<String> status;
  final Value<DateTime?> dueDate;
  final Value<bool> completed;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.projectId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.completed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required String title,
    this.description = const Value.absent(),
    this.projectId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.completed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       title = Value(title);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? projectId,
    Expression<int>? customerId,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<DateTime>? dueDate,
    Expression<bool>? completed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (projectId != null) 'project_id': projectId,
      if (customerId != null) 'customer_id': customerId,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (dueDate != null) 'due_date': dueDate,
      if (completed != null) 'completed': completed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<String>? title,
    Value<String>? description,
    Value<int?>? projectId,
    Value<int?>? customerId,
    Value<String>? priority,
    Value<String>? status,
    Value<DateTime?>? dueDate,
    Value<bool>? completed,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      customerId: customerId ?? this.customerId,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('projectId: $projectId, ')
          ..write('customerId: $customerId, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('completed: $completed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cash'),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _vendorMeta = const VerificationMeta('vendor');
  @override
  late final GeneratedColumn<String> vendor = GeneratedColumn<String>(
    'vendor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _expenseDateMeta = const VerificationMeta(
    'expenseDate',
  );
  @override
  late final GeneratedColumn<DateTime> expenseDate = GeneratedColumn<DateTime>(
    'expense_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    title,
    amount,
    currency,
    category,
    paymentMethod,
    projectId,
    customerId,
    vendor,
    notes,
    expenseDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('vendor')) {
      context.handle(
        _vendorMeta,
        vendor.isAcceptableOrUnknown(data['vendor']!, _vendorMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('expense_date')) {
      context.handle(
        _expenseDateMeta,
        expenseDate.isAcceptableOrUnknown(
          data['expense_date']!,
          _expenseDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      ),
      vendor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      expenseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expense_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int ownerUserId;
  final String title;
  final double amount;
  final String currency;
  final String category;
  final String paymentMethod;
  final int? projectId;
  final int? customerId;
  final String vendor;
  final String notes;
  final DateTime expenseDate;
  final DateTime createdAt;
  const Expense({
    required this.id,
    required this.ownerUserId,
    required this.title,
    required this.amount,
    required this.currency,
    required this.category,
    required this.paymentMethod,
    this.projectId,
    this.customerId,
    required this.vendor,
    required this.notes,
    required this.expenseDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['category'] = Variable<String>(category);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['vendor'] = Variable<String>(vendor);
    map['notes'] = Variable<String>(notes);
    map['expense_date'] = Variable<DateTime>(expenseDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      title: Value(title),
      amount: Value(amount),
      currency: Value(currency),
      category: Value(category),
      paymentMethod: Value(paymentMethod),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      vendor: Value(vendor),
      notes: Value(notes),
      expenseDate: Value(expenseDate),
      createdAt: Value(createdAt),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      category: serializer.fromJson<String>(json['category']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      projectId: serializer.fromJson<int?>(json['projectId']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      vendor: serializer.fromJson<String>(json['vendor']),
      notes: serializer.fromJson<String>(json['notes']),
      expenseDate: serializer.fromJson<DateTime>(json['expenseDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'category': serializer.toJson<String>(category),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'projectId': serializer.toJson<int?>(projectId),
      'customerId': serializer.toJson<int?>(customerId),
      'vendor': serializer.toJson<String>(vendor),
      'notes': serializer.toJson<String>(notes),
      'expenseDate': serializer.toJson<DateTime>(expenseDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Expense copyWith({
    int? id,
    int? ownerUserId,
    String? title,
    double? amount,
    String? currency,
    String? category,
    String? paymentMethod,
    Value<int?> projectId = const Value.absent(),
    Value<int?> customerId = const Value.absent(),
    String? vendor,
    String? notes,
    DateTime? expenseDate,
    DateTime? createdAt,
  }) => Expense(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    category: category ?? this.category,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    projectId: projectId.present ? projectId.value : this.projectId,
    customerId: customerId.present ? customerId.value : this.customerId,
    vendor: vendor ?? this.vendor,
    notes: notes ?? this.notes,
    expenseDate: expenseDate ?? this.expenseDate,
    createdAt: createdAt ?? this.createdAt,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      category: data.category.present ? data.category.value : this.category,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      vendor: data.vendor.present ? data.vendor.value : this.vendor,
      notes: data.notes.present ? data.notes.value : this.notes,
      expenseDate: data.expenseDate.present
          ? data.expenseDate.value
          : this.expenseDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('category: $category, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('projectId: $projectId, ')
          ..write('customerId: $customerId, ')
          ..write('vendor: $vendor, ')
          ..write('notes: $notes, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    title,
    amount,
    currency,
    category,
    paymentMethod,
    projectId,
    customerId,
    vendor,
    notes,
    expenseDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.category == this.category &&
          other.paymentMethod == this.paymentMethod &&
          other.projectId == this.projectId &&
          other.customerId == this.customerId &&
          other.vendor == this.vendor &&
          other.notes == this.notes &&
          other.expenseDate == this.expenseDate &&
          other.createdAt == this.createdAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> category;
  final Value<String> paymentMethod;
  final Value<int?> projectId;
  final Value<int?> customerId;
  final Value<String> vendor;
  final Value<String> notes;
  final Value<DateTime> expenseDate;
  final Value<DateTime> createdAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.category = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.projectId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.vendor = const Value.absent(),
    this.notes = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required String title,
    required double amount,
    this.currency = const Value.absent(),
    this.category = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.projectId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.vendor = const Value.absent(),
    this.notes = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       title = Value(title),
       amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? category,
    Expression<String>? paymentMethod,
    Expression<int>? projectId,
    Expression<int>? customerId,
    Expression<String>? vendor,
    Expression<String>? notes,
    Expression<DateTime>? expenseDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (category != null) 'category': category,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (projectId != null) 'project_id': projectId,
      if (customerId != null) 'customer_id': customerId,
      if (vendor != null) 'vendor': vendor,
      if (notes != null) 'notes': notes,
      if (expenseDate != null) 'expense_date': expenseDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<String>? title,
    Value<double>? amount,
    Value<String>? currency,
    Value<String>? category,
    Value<String>? paymentMethod,
    Value<int?>? projectId,
    Value<int?>? customerId,
    Value<String>? vendor,
    Value<String>? notes,
    Value<DateTime>? expenseDate,
    Value<DateTime>? createdAt,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      projectId: projectId ?? this.projectId,
      customerId: customerId ?? this.customerId,
      vendor: vendor ?? this.vendor,
      notes: notes ?? this.notes,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (vendor.present) {
      map['vendor'] = Variable<String>(vendor.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (expenseDate.present) {
      map['expense_date'] = Variable<DateTime>(expenseDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('category: $category, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('projectId: $projectId, ')
          ..write('customerId: $customerId, ')
          ..write('vendor: $vendor, ')
          ..write('notes: $notes, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('personal'),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    title,
    content,
    type,
    projectId,
    customerId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final int ownerUserId;
  final String title;
  final String content;
  final String type;
  final int? projectId;
  final int? customerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Note({
    required this.id,
    required this.ownerUserId,
    required this.title,
    required this.content,
    required this.type,
    this.projectId,
    this.customerId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      title: Value(title),
      content: Value(content),
      type: Value(type),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      type: serializer.fromJson<String>(json['type']),
      projectId: serializer.fromJson<int?>(json['projectId']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'type': serializer.toJson<String>(type),
      'projectId': serializer.toJson<int?>(projectId),
      'customerId': serializer.toJson<int?>(customerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Note copyWith({
    int? id,
    int? ownerUserId,
    String? title,
    String? content,
    String? type,
    Value<int?> projectId = const Value.absent(),
    Value<int?> customerId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Note(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    title: title ?? this.title,
    content: content ?? this.content,
    type: type ?? this.type,
    projectId: projectId.present ? projectId.value : this.projectId,
    customerId: customerId.present ? customerId.value : this.customerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('projectId: $projectId, ')
          ..write('customerId: $customerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    title,
    content,
    type,
    projectId,
    customerId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.title == this.title &&
          other.content == this.content &&
          other.type == this.type &&
          other.projectId == this.projectId &&
          other.customerId == this.customerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<String> title;
  final Value<String> content;
  final Value<String> type;
  final Value<int?> projectId;
  final Value<int?> customerId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.projectId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required String title,
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.projectId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       title = Value(title);
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? type,
    Expression<int>? projectId,
    Expression<int>? customerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (projectId != null) 'project_id': projectId,
      if (customerId != null) 'customer_id': customerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<String>? title,
    Value<String>? content,
    Value<String>? type,
    Value<int?>? projectId,
    Value<int?>? customerId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      projectId: projectId ?? this.projectId,
      customerId: customerId ?? this.customerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('projectId: $projectId, ')
          ..write('customerId: $customerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MessageTemplatesTable extends MessageTemplates
    with TableInfo<$MessageTemplatesTable, MessageTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('email'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    name,
    type,
    category,
    subject,
    body,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MessageTemplatesTable createAlias(String alias) {
    return $MessageTemplatesTable(attachedDatabase, alias);
  }
}

class MessageTemplate extends DataClass implements Insertable<MessageTemplate> {
  final int id;
  final int ownerUserId;
  final String name;
  final String type;
  final String category;
  final String subject;
  final String body;
  final DateTime createdAt;
  const MessageTemplate({
    required this.id,
    required this.ownerUserId,
    required this.name,
    required this.type,
    required this.category,
    required this.subject,
    required this.body,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['subject'] = Variable<String>(subject);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MessageTemplatesCompanion toCompanion(bool nullToAbsent) {
    return MessageTemplatesCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      name: Value(name),
      type: Value(type),
      category: Value(category),
      subject: Value(subject),
      body: Value(body),
      createdAt: Value(createdAt),
    );
  }

  factory MessageTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageTemplate(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      subject: serializer.fromJson<String>(json['subject']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'subject': serializer.toJson<String>(subject),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MessageTemplate copyWith({
    int? id,
    int? ownerUserId,
    String? name,
    String? type,
    String? category,
    String? subject,
    String? body,
    DateTime? createdAt,
  }) => MessageTemplate(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    name: name ?? this.name,
    type: type ?? this.type,
    category: category ?? this.category,
    subject: subject ?? this.subject,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
  );
  MessageTemplate copyWithCompanion(MessageTemplatesCompanion data) {
    return MessageTemplate(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      subject: data.subject.present ? data.subject.value : this.subject,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageTemplate(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('subject: $subject, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    name,
    type,
    category,
    subject,
    body,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageTemplate &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.name == this.name &&
          other.type == this.type &&
          other.category == this.category &&
          other.subject == this.subject &&
          other.body == this.body &&
          other.createdAt == this.createdAt);
}

class MessageTemplatesCompanion extends UpdateCompanion<MessageTemplate> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<String> name;
  final Value<String> type;
  final Value<String> category;
  final Value<String> subject;
  final Value<String> body;
  final Value<DateTime> createdAt;
  const MessageTemplatesCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.subject = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MessageTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required String name,
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.subject = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       name = Value(name);
  static Insertable<MessageTemplate> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? subject,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (subject != null) 'subject': subject,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MessageTemplatesCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<String>? name,
    Value<String>? type,
    Value<String>? category,
    Value<String>? subject,
    Value<String>? body,
    Value<DateTime>? createdAt,
  }) {
    return MessageTemplatesCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      name: name ?? this.name,
      type: type ?? this.type,
      category: category ?? this.category,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('subject: $subject, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ContractsTable extends Contracts
    with TableInfo<$ContractsTable, Contract> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    customerId,
    title,
    status,
    content,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contracts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contract> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contract map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contract(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ContractsTable createAlias(String alias) {
    return $ContractsTable(attachedDatabase, alias);
  }
}

class Contract extends DataClass implements Insertable<Contract> {
  final int id;
  final int ownerUserId;
  final int customerId;
  final String title;
  final String status;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Contract({
    required this.id,
    required this.ownerUserId,
    required this.customerId,
    required this.title,
    required this.status,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['customer_id'] = Variable<int>(customerId);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<String>(status);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ContractsCompanion toCompanion(bool nullToAbsent) {
    return ContractsCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      customerId: Value(customerId),
      title: Value(title),
      status: Value(status),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Contract.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contract(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      customerId: serializer.fromJson<int>(json['customerId']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String>(json['status']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'customerId': serializer.toJson<int>(customerId),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(status),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Contract copyWith({
    int? id,
    int? ownerUserId,
    int? customerId,
    String? title,
    String? status,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Contract(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    customerId: customerId ?? this.customerId,
    title: title ?? this.title,
    status: status ?? this.status,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Contract copyWithCompanion(ContractsCompanion data) {
    return Contract(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contract(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('customerId: $customerId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    customerId,
    title,
    status,
    content,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contract &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.customerId == this.customerId &&
          other.title == this.title &&
          other.status == this.status &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ContractsCompanion extends UpdateCompanion<Contract> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<int> customerId;
  final Value<String> title;
  final Value<String> status;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ContractsCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ContractsCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required int customerId,
    required String title,
    this.status = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       customerId = Value(customerId),
       title = Value(title);
  static Insertable<Contract> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<int>? customerId,
    Expression<String>? title,
    Expression<String>? status,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (customerId != null) 'customer_id': customerId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ContractsCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<int>? customerId,
    Value<String>? title,
    Value<String>? status,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ContractsCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      customerId: customerId ?? this.customerId,
      title: title ?? this.title,
      status: status ?? this.status,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('customerId: $customerId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppAnalyticsTable extends AppAnalytics
    with TableInfo<$AppAnalyticsTable, AppAnalytic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppAnalyticsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userEmailMeta = const VerificationMeta(
    'userEmail',
  );
  @override
  late final GeneratedColumn<String> userEmail = GeneratedColumn<String>(
    'user_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
    'plan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('free'),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventType,
    userEmail,
    userName,
    plan,
    amount,
    deviceId,
    payload,
    synced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_analytics';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppAnalytic> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('user_email')) {
      context.handle(
        _userEmailMeta,
        userEmail.isAcceptableOrUnknown(data['user_email']!, _userEmailMeta),
      );
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    }
    if (data.containsKey('plan')) {
      context.handle(
        _planMeta,
        plan.isAcceptableOrUnknown(data['plan']!, _planMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppAnalytic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppAnalytic(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      userEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_email'],
      )!,
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      )!,
      plan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AppAnalyticsTable createAlias(String alias) {
    return $AppAnalyticsTable(attachedDatabase, alias);
  }
}

class AppAnalytic extends DataClass implements Insertable<AppAnalytic> {
  final int id;
  final String eventType;
  final String userEmail;
  final String userName;
  final String plan;
  final double amount;
  final String deviceId;
  final String payload;
  final bool synced;
  final DateTime createdAt;
  const AppAnalytic({
    required this.id,
    required this.eventType,
    required this.userEmail,
    required this.userName,
    required this.plan,
    required this.amount,
    required this.deviceId,
    required this.payload,
    required this.synced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_type'] = Variable<String>(eventType);
    map['user_email'] = Variable<String>(userEmail);
    map['user_name'] = Variable<String>(userName);
    map['plan'] = Variable<String>(plan);
    map['amount'] = Variable<double>(amount);
    map['device_id'] = Variable<String>(deviceId);
    map['payload'] = Variable<String>(payload);
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AppAnalyticsCompanion toCompanion(bool nullToAbsent) {
    return AppAnalyticsCompanion(
      id: Value(id),
      eventType: Value(eventType),
      userEmail: Value(userEmail),
      userName: Value(userName),
      plan: Value(plan),
      amount: Value(amount),
      deviceId: Value(deviceId),
      payload: Value(payload),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory AppAnalytic.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppAnalytic(
      id: serializer.fromJson<int>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      userEmail: serializer.fromJson<String>(json['userEmail']),
      userName: serializer.fromJson<String>(json['userName']),
      plan: serializer.fromJson<String>(json['plan']),
      amount: serializer.fromJson<double>(json['amount']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      payload: serializer.fromJson<String>(json['payload']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventType': serializer.toJson<String>(eventType),
      'userEmail': serializer.toJson<String>(userEmail),
      'userName': serializer.toJson<String>(userName),
      'plan': serializer.toJson<String>(plan),
      'amount': serializer.toJson<double>(amount),
      'deviceId': serializer.toJson<String>(deviceId),
      'payload': serializer.toJson<String>(payload),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AppAnalytic copyWith({
    int? id,
    String? eventType,
    String? userEmail,
    String? userName,
    String? plan,
    double? amount,
    String? deviceId,
    String? payload,
    bool? synced,
    DateTime? createdAt,
  }) => AppAnalytic(
    id: id ?? this.id,
    eventType: eventType ?? this.eventType,
    userEmail: userEmail ?? this.userEmail,
    userName: userName ?? this.userName,
    plan: plan ?? this.plan,
    amount: amount ?? this.amount,
    deviceId: deviceId ?? this.deviceId,
    payload: payload ?? this.payload,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
  );
  AppAnalytic copyWithCompanion(AppAnalyticsCompanion data) {
    return AppAnalytic(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      userEmail: data.userEmail.present ? data.userEmail.value : this.userEmail,
      userName: data.userName.present ? data.userName.value : this.userName,
      plan: data.plan.present ? data.plan.value : this.plan,
      amount: data.amount.present ? data.amount.value : this.amount,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      payload: data.payload.present ? data.payload.value : this.payload,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppAnalytic(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('userEmail: $userEmail, ')
          ..write('userName: $userName, ')
          ..write('plan: $plan, ')
          ..write('amount: $amount, ')
          ..write('deviceId: $deviceId, ')
          ..write('payload: $payload, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventType,
    userEmail,
    userName,
    plan,
    amount,
    deviceId,
    payload,
    synced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppAnalytic &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.userEmail == this.userEmail &&
          other.userName == this.userName &&
          other.plan == this.plan &&
          other.amount == this.amount &&
          other.deviceId == this.deviceId &&
          other.payload == this.payload &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class AppAnalyticsCompanion extends UpdateCompanion<AppAnalytic> {
  final Value<int> id;
  final Value<String> eventType;
  final Value<String> userEmail;
  final Value<String> userName;
  final Value<String> plan;
  final Value<double> amount;
  final Value<String> deviceId;
  final Value<String> payload;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  const AppAnalyticsCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.userEmail = const Value.absent(),
    this.userName = const Value.absent(),
    this.plan = const Value.absent(),
    this.amount = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.payload = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AppAnalyticsCompanion.insert({
    this.id = const Value.absent(),
    required String eventType,
    this.userEmail = const Value.absent(),
    this.userName = const Value.absent(),
    this.plan = const Value.absent(),
    this.amount = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.payload = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : eventType = Value(eventType);
  static Insertable<AppAnalytic> custom({
    Expression<int>? id,
    Expression<String>? eventType,
    Expression<String>? userEmail,
    Expression<String>? userName,
    Expression<String>? plan,
    Expression<double>? amount,
    Expression<String>? deviceId,
    Expression<String>? payload,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (userEmail != null) 'user_email': userEmail,
      if (userName != null) 'user_name': userName,
      if (plan != null) 'plan': plan,
      if (amount != null) 'amount': amount,
      if (deviceId != null) 'device_id': deviceId,
      if (payload != null) 'payload': payload,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AppAnalyticsCompanion copyWith({
    Value<int>? id,
    Value<String>? eventType,
    Value<String>? userEmail,
    Value<String>? userName,
    Value<String>? plan,
    Value<double>? amount,
    Value<String>? deviceId,
    Value<String>? payload,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
  }) {
    return AppAnalyticsCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      plan: plan ?? this.plan,
      amount: amount ?? this.amount,
      deviceId: deviceId ?? this.deviceId,
      payload: payload ?? this.payload,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (userEmail.present) {
      map['user_email'] = Variable<String>(userEmail.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppAnalyticsCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('userEmail: $userEmail, ')
          ..write('userName: $userName, ')
          ..write('plan: $plan, ')
          ..write('amount: $amount, ')
          ..write('deviceId: $deviceId, ')
          ..write('payload: $payload, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TrackingEventsTable extends TrackingEvents
    with TableInfo<$TrackingEventsTable, TrackingEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackingEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    entityType,
    entityId,
    status,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracking_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackingEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackingEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackingEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TrackingEventsTable createAlias(String alias) {
    return $TrackingEventsTable(attachedDatabase, alias);
  }
}

class TrackingEvent extends DataClass implements Insertable<TrackingEvent> {
  final int id;
  final int ownerUserId;
  final String entityType;
  final int entityId;
  final String status;
  final String note;
  final DateTime createdAt;
  const TrackingEvent({
    required this.id,
    required this.ownerUserId,
    required this.entityType,
    required this.entityId,
    required this.status,
    required this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    map['status'] = Variable<String>(status);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TrackingEventsCompanion toCompanion(bool nullToAbsent) {
    return TrackingEventsCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      status: Value(status),
      note: Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory TrackingEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackingEvent(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TrackingEvent copyWith({
    int? id,
    int? ownerUserId,
    String? entityType,
    int? entityId,
    String? status,
    String? note,
    DateTime? createdAt,
  }) => TrackingEvent(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    status: status ?? this.status,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  TrackingEvent copyWithCompanion(TrackingEventsCompanion data) {
    return TrackingEvent(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackingEvent(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    entityType,
    entityId,
    status,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackingEvent &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.status == this.status &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class TrackingEventsCompanion extends UpdateCompanion<TrackingEvent> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<String> status;
  final Value<String> note;
  final Value<DateTime> createdAt;
  const TrackingEventsCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TrackingEventsCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required String entityType,
    required int entityId,
    required String status,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       status = Value(status);
  static Insertable<TrackingEvent> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? status,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TrackingEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<String>? entityType,
    Value<int>? entityId,
    Value<String>? status,
    Value<String>? note,
    Value<DateTime>? createdAt,
  }) {
    return TrackingEventsCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackingEventsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProjectTimeEntriesTable extends ProjectTimeEntries
    with TableInfo<$ProjectTimeEntriesTable, ProjectTimeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectTimeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    projectId,
    startedAt,
    endedAt,
    durationSeconds,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_time_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectTimeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectTimeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectTimeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $ProjectTimeEntriesTable createAlias(String alias) {
    return $ProjectTimeEntriesTable(attachedDatabase, alias);
  }
}

class ProjectTimeEntry extends DataClass
    implements Insertable<ProjectTimeEntry> {
  final int id;
  final int ownerUserId;
  final int projectId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int durationSeconds;
  final String note;
  const ProjectTimeEntry({
    required this.id,
    required this.ownerUserId,
    required this.projectId,
    required this.startedAt,
    this.endedAt,
    required this.durationSeconds,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['project_id'] = Variable<int>(projectId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['note'] = Variable<String>(note);
    return map;
  }

  ProjectTimeEntriesCompanion toCompanion(bool nullToAbsent) {
    return ProjectTimeEntriesCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      projectId: Value(projectId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationSeconds: Value(durationSeconds),
      note: Value(note),
    );
  }

  factory ProjectTimeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectTimeEntry(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      projectId: serializer.fromJson<int>(json['projectId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'projectId': serializer.toJson<int>(projectId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'note': serializer.toJson<String>(note),
    };
  }

  ProjectTimeEntry copyWith({
    int? id,
    int? ownerUserId,
    int? projectId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? durationSeconds,
    String? note,
  }) => ProjectTimeEntry(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    projectId: projectId ?? this.projectId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    note: note ?? this.note,
  );
  ProjectTimeEntry copyWithCompanion(ProjectTimeEntriesCompanion data) {
    return ProjectTimeEntry(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectTimeEntry(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('projectId: $projectId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    projectId,
    startedAt,
    endedAt,
    durationSeconds,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectTimeEntry &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.projectId == this.projectId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.note == this.note);
}

class ProjectTimeEntriesCompanion extends UpdateCompanion<ProjectTimeEntry> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<int> projectId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> durationSeconds;
  final Value<String> note;
  const ProjectTimeEntriesCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.note = const Value.absent(),
  });
  ProjectTimeEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required int projectId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.note = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       projectId = Value(projectId),
       startedAt = Value(startedAt);
  static Insertable<ProjectTimeEntry> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<int>? projectId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSeconds,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (projectId != null) 'project_id': projectId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (note != null) 'note': note,
    });
  }

  ProjectTimeEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<int>? projectId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? durationSeconds,
    Value<String>? note,
  }) {
    return ProjectTimeEntriesCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      projectId: projectId ?? this.projectId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectTimeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('projectId: $projectId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $ProjectClientLinksTable extends ProjectClientLinks
    with TableInfo<$ProjectClientLinksTable, ProjectClientLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectClientLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _freelancerUserIdMeta = const VerificationMeta(
    'freelancerUserId',
  );
  @override
  late final GeneratedColumn<int> freelancerUserId = GeneratedColumn<int>(
    'freelancer_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _clientEmailMeta = const VerificationMeta(
    'clientEmail',
  );
  @override
  late final GeneratedColumn<String> clientEmail = GeneratedColumn<String>(
    'client_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientUserIdMeta = const VerificationMeta(
    'clientUserId',
  );
  @override
  late final GeneratedColumn<int> clientUserId = GeneratedColumn<int>(
    'client_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    freelancerUserId,
    clientEmail,
    clientUserId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_client_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectClientLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('freelancer_user_id')) {
      context.handle(
        _freelancerUserIdMeta,
        freelancerUserId.isAcceptableOrUnknown(
          data['freelancer_user_id']!,
          _freelancerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_freelancerUserIdMeta);
    }
    if (data.containsKey('client_email')) {
      context.handle(
        _clientEmailMeta,
        clientEmail.isAcceptableOrUnknown(
          data['client_email']!,
          _clientEmailMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientEmailMeta);
    }
    if (data.containsKey('client_user_id')) {
      context.handle(
        _clientUserIdMeta,
        clientUserId.isAcceptableOrUnknown(
          data['client_user_id']!,
          _clientUserIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectClientLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectClientLink(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      freelancerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}freelancer_user_id'],
      )!,
      clientEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_email'],
      )!,
      clientUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProjectClientLinksTable createAlias(String alias) {
    return $ProjectClientLinksTable(attachedDatabase, alias);
  }
}

class ProjectClientLink extends DataClass
    implements Insertable<ProjectClientLink> {
  final int id;
  final int projectId;
  final int freelancerUserId;
  final String clientEmail;
  final int? clientUserId;
  final DateTime createdAt;
  const ProjectClientLink({
    required this.id,
    required this.projectId,
    required this.freelancerUserId,
    required this.clientEmail,
    this.clientUserId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['freelancer_user_id'] = Variable<int>(freelancerUserId);
    map['client_email'] = Variable<String>(clientEmail);
    if (!nullToAbsent || clientUserId != null) {
      map['client_user_id'] = Variable<int>(clientUserId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProjectClientLinksCompanion toCompanion(bool nullToAbsent) {
    return ProjectClientLinksCompanion(
      id: Value(id),
      projectId: Value(projectId),
      freelancerUserId: Value(freelancerUserId),
      clientEmail: Value(clientEmail),
      clientUserId: clientUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientUserId),
      createdAt: Value(createdAt),
    );
  }

  factory ProjectClientLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectClientLink(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      freelancerUserId: serializer.fromJson<int>(json['freelancerUserId']),
      clientEmail: serializer.fromJson<String>(json['clientEmail']),
      clientUserId: serializer.fromJson<int?>(json['clientUserId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'freelancerUserId': serializer.toJson<int>(freelancerUserId),
      'clientEmail': serializer.toJson<String>(clientEmail),
      'clientUserId': serializer.toJson<int?>(clientUserId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProjectClientLink copyWith({
    int? id,
    int? projectId,
    int? freelancerUserId,
    String? clientEmail,
    Value<int?> clientUserId = const Value.absent(),
    DateTime? createdAt,
  }) => ProjectClientLink(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    freelancerUserId: freelancerUserId ?? this.freelancerUserId,
    clientEmail: clientEmail ?? this.clientEmail,
    clientUserId: clientUserId.present ? clientUserId.value : this.clientUserId,
    createdAt: createdAt ?? this.createdAt,
  );
  ProjectClientLink copyWithCompanion(ProjectClientLinksCompanion data) {
    return ProjectClientLink(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      freelancerUserId: data.freelancerUserId.present
          ? data.freelancerUserId.value
          : this.freelancerUserId,
      clientEmail: data.clientEmail.present
          ? data.clientEmail.value
          : this.clientEmail,
      clientUserId: data.clientUserId.present
          ? data.clientUserId.value
          : this.clientUserId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectClientLink(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('freelancerUserId: $freelancerUserId, ')
          ..write('clientEmail: $clientEmail, ')
          ..write('clientUserId: $clientUserId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    freelancerUserId,
    clientEmail,
    clientUserId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectClientLink &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.freelancerUserId == this.freelancerUserId &&
          other.clientEmail == this.clientEmail &&
          other.clientUserId == this.clientUserId &&
          other.createdAt == this.createdAt);
}

class ProjectClientLinksCompanion extends UpdateCompanion<ProjectClientLink> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<int> freelancerUserId;
  final Value<String> clientEmail;
  final Value<int?> clientUserId;
  final Value<DateTime> createdAt;
  const ProjectClientLinksCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.freelancerUserId = const Value.absent(),
    this.clientEmail = const Value.absent(),
    this.clientUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProjectClientLinksCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required int freelancerUserId,
    required String clientEmail,
    this.clientUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : projectId = Value(projectId),
       freelancerUserId = Value(freelancerUserId),
       clientEmail = Value(clientEmail);
  static Insertable<ProjectClientLink> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<int>? freelancerUserId,
    Expression<String>? clientEmail,
    Expression<int>? clientUserId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (freelancerUserId != null) 'freelancer_user_id': freelancerUserId,
      if (clientEmail != null) 'client_email': clientEmail,
      if (clientUserId != null) 'client_user_id': clientUserId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProjectClientLinksCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<int>? freelancerUserId,
    Value<String>? clientEmail,
    Value<int?>? clientUserId,
    Value<DateTime>? createdAt,
  }) {
    return ProjectClientLinksCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      freelancerUserId: freelancerUserId ?? this.freelancerUserId,
      clientEmail: clientEmail ?? this.clientEmail,
      clientUserId: clientUserId ?? this.clientUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (freelancerUserId.present) {
      map['freelancer_user_id'] = Variable<int>(freelancerUserId.value);
    }
    if (clientEmail.present) {
      map['client_email'] = Variable<String>(clientEmail.value);
    }
    if (clientUserId.present) {
      map['client_user_id'] = Variable<int>(clientUserId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectClientLinksCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('freelancerUserId: $freelancerUserId, ')
          ..write('clientEmail: $clientEmail, ')
          ..write('clientUserId: $clientUserId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ClientMessagesTable extends ClientMessages
    with TableInfo<$ClientMessagesTable, ClientMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fromUserIdMeta = const VerificationMeta(
    'fromUserId',
  );
  @override
  late final GeneratedColumn<int> fromUserId = GeneratedColumn<int>(
    'from_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _toUserIdMeta = const VerificationMeta(
    'toUserId',
  );
  @override
  late final GeneratedColumn<int> toUserId = GeneratedColumn<int>(
    'to_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromUserId,
    toUserId,
    projectId,
    subject,
    body,
    isRead,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'client_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClientMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_user_id')) {
      context.handle(
        _fromUserIdMeta,
        fromUserId.isAcceptableOrUnknown(
          data['from_user_id']!,
          _fromUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromUserIdMeta);
    }
    if (data.containsKey('to_user_id')) {
      context.handle(
        _toUserIdMeta,
        toUserId.isAcceptableOrUnknown(data['to_user_id']!, _toUserIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toUserIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fromUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_user_id'],
      )!,
      toUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_user_id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      ),
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ClientMessagesTable createAlias(String alias) {
    return $ClientMessagesTable(attachedDatabase, alias);
  }
}

class ClientMessage extends DataClass implements Insertable<ClientMessage> {
  final int id;
  final int fromUserId;
  final int toUserId;
  final int? projectId;
  final String subject;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  const ClientMessage({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    this.projectId,
    required this.subject,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_user_id'] = Variable<int>(fromUserId);
    map['to_user_id'] = Variable<int>(toUserId);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    map['subject'] = Variable<String>(subject);
    map['body'] = Variable<String>(body);
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ClientMessagesCompanion toCompanion(bool nullToAbsent) {
    return ClientMessagesCompanion(
      id: Value(id),
      fromUserId: Value(fromUserId),
      toUserId: Value(toUserId),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      subject: Value(subject),
      body: Value(body),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
    );
  }

  factory ClientMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientMessage(
      id: serializer.fromJson<int>(json['id']),
      fromUserId: serializer.fromJson<int>(json['fromUserId']),
      toUserId: serializer.fromJson<int>(json['toUserId']),
      projectId: serializer.fromJson<int?>(json['projectId']),
      subject: serializer.fromJson<String>(json['subject']),
      body: serializer.fromJson<String>(json['body']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromUserId': serializer.toJson<int>(fromUserId),
      'toUserId': serializer.toJson<int>(toUserId),
      'projectId': serializer.toJson<int?>(projectId),
      'subject': serializer.toJson<String>(subject),
      'body': serializer.toJson<String>(body),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ClientMessage copyWith({
    int? id,
    int? fromUserId,
    int? toUserId,
    Value<int?> projectId = const Value.absent(),
    String? subject,
    String? body,
    bool? isRead,
    DateTime? createdAt,
  }) => ClientMessage(
    id: id ?? this.id,
    fromUserId: fromUserId ?? this.fromUserId,
    toUserId: toUserId ?? this.toUserId,
    projectId: projectId.present ? projectId.value : this.projectId,
    subject: subject ?? this.subject,
    body: body ?? this.body,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );
  ClientMessage copyWithCompanion(ClientMessagesCompanion data) {
    return ClientMessage(
      id: data.id.present ? data.id.value : this.id,
      fromUserId: data.fromUserId.present
          ? data.fromUserId.value
          : this.fromUserId,
      toUserId: data.toUserId.present ? data.toUserId.value : this.toUserId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      subject: data.subject.present ? data.subject.value : this.subject,
      body: data.body.present ? data.body.value : this.body,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientMessage(')
          ..write('id: $id, ')
          ..write('fromUserId: $fromUserId, ')
          ..write('toUserId: $toUserId, ')
          ..write('projectId: $projectId, ')
          ..write('subject: $subject, ')
          ..write('body: $body, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromUserId,
    toUserId,
    projectId,
    subject,
    body,
    isRead,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientMessage &&
          other.id == this.id &&
          other.fromUserId == this.fromUserId &&
          other.toUserId == this.toUserId &&
          other.projectId == this.projectId &&
          other.subject == this.subject &&
          other.body == this.body &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class ClientMessagesCompanion extends UpdateCompanion<ClientMessage> {
  final Value<int> id;
  final Value<int> fromUserId;
  final Value<int> toUserId;
  final Value<int?> projectId;
  final Value<String> subject;
  final Value<String> body;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  const ClientMessagesCompanion({
    this.id = const Value.absent(),
    this.fromUserId = const Value.absent(),
    this.toUserId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.subject = const Value.absent(),
    this.body = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ClientMessagesCompanion.insert({
    this.id = const Value.absent(),
    required int fromUserId,
    required int toUserId,
    this.projectId = const Value.absent(),
    this.subject = const Value.absent(),
    required String body,
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : fromUserId = Value(fromUserId),
       toUserId = Value(toUserId),
       body = Value(body);
  static Insertable<ClientMessage> custom({
    Expression<int>? id,
    Expression<int>? fromUserId,
    Expression<int>? toUserId,
    Expression<int>? projectId,
    Expression<String>? subject,
    Expression<String>? body,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromUserId != null) 'from_user_id': fromUserId,
      if (toUserId != null) 'to_user_id': toUserId,
      if (projectId != null) 'project_id': projectId,
      if (subject != null) 'subject': subject,
      if (body != null) 'body': body,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ClientMessagesCompanion copyWith({
    Value<int>? id,
    Value<int>? fromUserId,
    Value<int>? toUserId,
    Value<int?>? projectId,
    Value<String>? subject,
    Value<String>? body,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
  }) {
    return ClientMessagesCompanion(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      projectId: projectId ?? this.projectId,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromUserId.present) {
      map['from_user_id'] = Variable<int>(fromUserId.value);
    }
    if (toUserId.present) {
      map['to_user_id'] = Variable<int>(toUserId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientMessagesCompanion(')
          ..write('id: $id, ')
          ..write('fromUserId: $fromUserId, ')
          ..write('toUserId: $toUserId, ')
          ..write('projectId: $projectId, ')
          ..write('subject: $subject, ')
          ..write('body: $body, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TeamMembersTable extends TeamMembers
    with TableInfo<$TeamMembersTable, TeamMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('member'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    name,
    email,
    role,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'team_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeamMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeamMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TeamMembersTable createAlias(String alias) {
    return $TeamMembersTable(attachedDatabase, alias);
  }
}

class TeamMember extends DataClass implements Insertable<TeamMember> {
  final int id;
  final int ownerUserId;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  const TeamMember({
    required this.id,
    required this.ownerUserId,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TeamMembersCompanion toCompanion(bool nullToAbsent) {
    return TeamMembersCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      name: Value(name),
      email: Value(email),
      role: Value(role),
      createdAt: Value(createdAt),
    );
  }

  factory TeamMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamMember(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TeamMember copyWith({
    int? id,
    int? ownerUserId,
    String? name,
    String? email,
    String? role,
    DateTime? createdAt,
  }) => TeamMember(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
  );
  TeamMember copyWithCompanion(TeamMembersCompanion data) {
    return TeamMember(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamMember(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerUserId, name, email, role, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamMember &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.name == this.name &&
          other.email == this.email &&
          other.role == this.role &&
          other.createdAt == this.createdAt);
}

class TeamMembersCompanion extends UpdateCompanion<TeamMember> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<String> name;
  final Value<String> email;
  final Value<String> role;
  final Value<DateTime> createdAt;
  const TeamMembersCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TeamMembersCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required String name,
    required String email,
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       name = Value(name),
       email = Value(email);
  static Insertable<TeamMember> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TeamMembersCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<String>? name,
    Value<String>? email,
    Value<String>? role,
    Value<DateTime>? createdAt,
  }) {
    return TeamMembersCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamMembersCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FileAttachmentsTable extends FileAttachments
    with TableInfo<$FileAttachmentsTable, FileAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FileAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    entityType,
    entityId,
    fileName,
    localPath,
    mimeType,
    sizeBytes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'file_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<FileAttachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FileAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FileAttachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FileAttachmentsTable createAlias(String alias) {
    return $FileAttachmentsTable(attachedDatabase, alias);
  }
}

class FileAttachment extends DataClass implements Insertable<FileAttachment> {
  final int id;
  final int ownerUserId;
  final String entityType;
  final int entityId;
  final String fileName;
  final String localPath;
  final String mimeType;
  final int sizeBytes;
  final DateTime createdAt;
  const FileAttachment({
    required this.id,
    required this.ownerUserId,
    required this.entityType,
    required this.entityId,
    required this.fileName,
    required this.localPath,
    required this.mimeType,
    required this.sizeBytes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    map['file_name'] = Variable<String>(fileName);
    map['local_path'] = Variable<String>(localPath);
    map['mime_type'] = Variable<String>(mimeType);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FileAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return FileAttachmentsCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      fileName: Value(fileName),
      localPath: Value(localPath),
      mimeType: Value(mimeType),
      sizeBytes: Value(sizeBytes),
      createdAt: Value(createdAt),
    );
  }

  factory FileAttachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FileAttachment(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      localPath: serializer.fromJson<String>(json['localPath']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'fileName': serializer.toJson<String>(fileName),
      'localPath': serializer.toJson<String>(localPath),
      'mimeType': serializer.toJson<String>(mimeType),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FileAttachment copyWith({
    int? id,
    int? ownerUserId,
    String? entityType,
    int? entityId,
    String? fileName,
    String? localPath,
    String? mimeType,
    int? sizeBytes,
    DateTime? createdAt,
  }) => FileAttachment(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    fileName: fileName ?? this.fileName,
    localPath: localPath ?? this.localPath,
    mimeType: mimeType ?? this.mimeType,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    createdAt: createdAt ?? this.createdAt,
  );
  FileAttachment copyWithCompanion(FileAttachmentsCompanion data) {
    return FileAttachment(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FileAttachment(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('fileName: $fileName, ')
          ..write('localPath: $localPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    entityType,
    entityId,
    fileName,
    localPath,
    mimeType,
    sizeBytes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FileAttachment &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.fileName == this.fileName &&
          other.localPath == this.localPath &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.createdAt == this.createdAt);
}

class FileAttachmentsCompanion extends UpdateCompanion<FileAttachment> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<String> fileName;
  final Value<String> localPath;
  final Value<String> mimeType;
  final Value<int> sizeBytes;
  final Value<DateTime> createdAt;
  const FileAttachmentsCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.localPath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FileAttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required String entityType,
    required int entityId,
    required String fileName,
    required String localPath,
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       fileName = Value(fileName),
       localPath = Value(localPath);
  static Insertable<FileAttachment> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? fileName,
    Expression<String>? localPath,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (fileName != null) 'file_name': fileName,
      if (localPath != null) 'local_path': localPath,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FileAttachmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<String>? entityType,
    Value<int>? entityId,
    Value<String>? fileName,
    Value<String>? localPath,
    Value<String>? mimeType,
    Value<int>? sizeBytes,
    Value<DateTime>? createdAt,
  }) {
    return FileAttachmentsCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      fileName: fileName ?? this.fileName,
      localPath: localPath ?? this.localPath,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FileAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('fileName: $fileName, ')
          ..write('localPath: $localPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CalendarRemindersTable extends CalendarReminders
    with TableInfo<$CalendarRemindersTable, CalendarReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('reminder'),
  );
  static const VerificationMeta _linkedEntityIdMeta = const VerificationMeta(
    'linkedEntityId',
  );
  @override
  late final GeneratedColumn<int> linkedEntityId = GeneratedColumn<int>(
    'linked_entity_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedEntityTypeMeta = const VerificationMeta(
    'linkedEntityType',
  );
  @override
  late final GeneratedColumn<String> linkedEntityType = GeneratedColumn<String>(
    'linked_entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    title,
    notes,
    scheduledAt,
    kind,
    linkedEntityId,
    linkedEntityType,
    completed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarReminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('linked_entity_id')) {
      context.handle(
        _linkedEntityIdMeta,
        linkedEntityId.isAcceptableOrUnknown(
          data['linked_entity_id']!,
          _linkedEntityIdMeta,
        ),
      );
    }
    if (data.containsKey('linked_entity_type')) {
      context.handle(
        _linkedEntityTypeMeta,
        linkedEntityType.isAcceptableOrUnknown(
          data['linked_entity_type']!,
          _linkedEntityTypeMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarReminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      linkedEntityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}linked_entity_id'],
      ),
      linkedEntityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_entity_type'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CalendarRemindersTable createAlias(String alias) {
    return $CalendarRemindersTable(attachedDatabase, alias);
  }
}

class CalendarReminder extends DataClass
    implements Insertable<CalendarReminder> {
  final int id;
  final int ownerUserId;
  final String title;
  final String notes;
  final DateTime scheduledAt;
  final String kind;
  final int? linkedEntityId;
  final String linkedEntityType;
  final bool completed;
  final DateTime createdAt;
  const CalendarReminder({
    required this.id,
    required this.ownerUserId,
    required this.title,
    required this.notes,
    required this.scheduledAt,
    required this.kind,
    this.linkedEntityId,
    required this.linkedEntityType,
    required this.completed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['title'] = Variable<String>(title);
    map['notes'] = Variable<String>(notes);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || linkedEntityId != null) {
      map['linked_entity_id'] = Variable<int>(linkedEntityId);
    }
    map['linked_entity_type'] = Variable<String>(linkedEntityType);
    map['completed'] = Variable<bool>(completed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CalendarRemindersCompanion toCompanion(bool nullToAbsent) {
    return CalendarRemindersCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      title: Value(title),
      notes: Value(notes),
      scheduledAt: Value(scheduledAt),
      kind: Value(kind),
      linkedEntityId: linkedEntityId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedEntityId),
      linkedEntityType: Value(linkedEntityType),
      completed: Value(completed),
      createdAt: Value(createdAt),
    );
  }

  factory CalendarReminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarReminder(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String>(json['notes']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      kind: serializer.fromJson<String>(json['kind']),
      linkedEntityId: serializer.fromJson<int?>(json['linkedEntityId']),
      linkedEntityType: serializer.fromJson<String>(json['linkedEntityType']),
      completed: serializer.fromJson<bool>(json['completed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String>(notes),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'kind': serializer.toJson<String>(kind),
      'linkedEntityId': serializer.toJson<int?>(linkedEntityId),
      'linkedEntityType': serializer.toJson<String>(linkedEntityType),
      'completed': serializer.toJson<bool>(completed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CalendarReminder copyWith({
    int? id,
    int? ownerUserId,
    String? title,
    String? notes,
    DateTime? scheduledAt,
    String? kind,
    Value<int?> linkedEntityId = const Value.absent(),
    String? linkedEntityType,
    bool? completed,
    DateTime? createdAt,
  }) => CalendarReminder(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    kind: kind ?? this.kind,
    linkedEntityId: linkedEntityId.present
        ? linkedEntityId.value
        : this.linkedEntityId,
    linkedEntityType: linkedEntityType ?? this.linkedEntityType,
    completed: completed ?? this.completed,
    createdAt: createdAt ?? this.createdAt,
  );
  CalendarReminder copyWithCompanion(CalendarRemindersCompanion data) {
    return CalendarReminder(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      kind: data.kind.present ? data.kind.value : this.kind,
      linkedEntityId: data.linkedEntityId.present
          ? data.linkedEntityId.value
          : this.linkedEntityId,
      linkedEntityType: data.linkedEntityType.present
          ? data.linkedEntityType.value
          : this.linkedEntityType,
      completed: data.completed.present ? data.completed.value : this.completed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarReminder(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('kind: $kind, ')
          ..write('linkedEntityId: $linkedEntityId, ')
          ..write('linkedEntityType: $linkedEntityType, ')
          ..write('completed: $completed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    title,
    notes,
    scheduledAt,
    kind,
    linkedEntityId,
    linkedEntityType,
    completed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarReminder &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.scheduledAt == this.scheduledAt &&
          other.kind == this.kind &&
          other.linkedEntityId == this.linkedEntityId &&
          other.linkedEntityType == this.linkedEntityType &&
          other.completed == this.completed &&
          other.createdAt == this.createdAt);
}

class CalendarRemindersCompanion extends UpdateCompanion<CalendarReminder> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<String> title;
  final Value<String> notes;
  final Value<DateTime> scheduledAt;
  final Value<String> kind;
  final Value<int?> linkedEntityId;
  final Value<String> linkedEntityType;
  final Value<bool> completed;
  final Value<DateTime> createdAt;
  const CalendarRemindersCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.kind = const Value.absent(),
    this.linkedEntityId = const Value.absent(),
    this.linkedEntityType = const Value.absent(),
    this.completed = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CalendarRemindersCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required String title,
    this.notes = const Value.absent(),
    required DateTime scheduledAt,
    this.kind = const Value.absent(),
    this.linkedEntityId = const Value.absent(),
    this.linkedEntityType = const Value.absent(),
    this.completed = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       title = Value(title),
       scheduledAt = Value(scheduledAt);
  static Insertable<CalendarReminder> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<DateTime>? scheduledAt,
    Expression<String>? kind,
    Expression<int>? linkedEntityId,
    Expression<String>? linkedEntityType,
    Expression<bool>? completed,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (kind != null) 'kind': kind,
      if (linkedEntityId != null) 'linked_entity_id': linkedEntityId,
      if (linkedEntityType != null) 'linked_entity_type': linkedEntityType,
      if (completed != null) 'completed': completed,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CalendarRemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<String>? title,
    Value<String>? notes,
    Value<DateTime>? scheduledAt,
    Value<String>? kind,
    Value<int?>? linkedEntityId,
    Value<String>? linkedEntityType,
    Value<bool>? completed,
    Value<DateTime>? createdAt,
  }) {
    return CalendarRemindersCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      kind: kind ?? this.kind,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
      linkedEntityType: linkedEntityType ?? this.linkedEntityType,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (linkedEntityId.present) {
      map['linked_entity_id'] = Variable<int>(linkedEntityId.value);
    }
    if (linkedEntityType.present) {
      map['linked_entity_type'] = Variable<String>(linkedEntityType.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarRemindersCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('kind: $kind, ')
          ..write('linkedEntityId: $linkedEntityId, ')
          ..write('linkedEntityType: $linkedEntityType, ')
          ..write('completed: $completed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProjectMilestonesTable extends ProjectMilestones
    with TableInfo<$ProjectMilestonesTable, ProjectMilestone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectMilestonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    projectId,
    title,
    description,
    amount,
    currency,
    status,
    sortOrder,
    dueDate,
    invoiceId,
    completedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_milestones';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectMilestone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectMilestone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectMilestone(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectMilestonesTable createAlias(String alias) {
    return $ProjectMilestonesTable(attachedDatabase, alias);
  }
}

class ProjectMilestone extends DataClass
    implements Insertable<ProjectMilestone> {
  final int id;
  final int ownerUserId;
  final int projectId;
  final String title;
  final String description;
  final double amount;
  final String currency;
  final String status;
  final int sortOrder;
  final DateTime? dueDate;
  final int? invoiceId;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProjectMilestone({
    required this.id,
    required this.ownerUserId,
    required this.projectId,
    required this.title,
    required this.description,
    required this.amount,
    required this.currency,
    required this.status,
    required this.sortOrder,
    this.dueDate,
    this.invoiceId,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['project_id'] = Variable<int>(projectId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['status'] = Variable<String>(status);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || invoiceId != null) {
      map['invoice_id'] = Variable<int>(invoiceId);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectMilestonesCompanion toCompanion(bool nullToAbsent) {
    return ProjectMilestonesCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      projectId: Value(projectId),
      title: Value(title),
      description: Value(description),
      amount: Value(amount),
      currency: Value(currency),
      status: Value(status),
      sortOrder: Value(sortOrder),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      invoiceId: invoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceId),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProjectMilestone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectMilestone(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      projectId: serializer.fromJson<int>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      status: serializer.fromJson<String>(json['status']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      invoiceId: serializer.fromJson<int?>(json['invoiceId']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'projectId': serializer.toJson<int>(projectId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'status': serializer.toJson<String>(status),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'invoiceId': serializer.toJson<int?>(invoiceId),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProjectMilestone copyWith({
    int? id,
    int? ownerUserId,
    int? projectId,
    String? title,
    String? description,
    double? amount,
    String? currency,
    String? status,
    int? sortOrder,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<int?> invoiceId = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProjectMilestone(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    projectId: projectId ?? this.projectId,
    title: title ?? this.title,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    status: status ?? this.status,
    sortOrder: sortOrder ?? this.sortOrder,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProjectMilestone copyWithCompanion(ProjectMilestonesCompanion data) {
    return ProjectMilestone(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      status: data.status.present ? data.status.value : this.status,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectMilestone(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('dueDate: $dueDate, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    projectId,
    title,
    description,
    amount,
    currency,
    status,
    sortOrder,
    dueDate,
    invoiceId,
    completedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectMilestone &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.status == this.status &&
          other.sortOrder == this.sortOrder &&
          other.dueDate == this.dueDate &&
          other.invoiceId == this.invoiceId &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectMilestonesCompanion extends UpdateCompanion<ProjectMilestone> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<int> projectId;
  final Value<String> title;
  final Value<String> description;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> status;
  final Value<int> sortOrder;
  final Value<DateTime?> dueDate;
  final Value<int?> invoiceId;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProjectMilestonesCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectMilestonesCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required int projectId,
    required String title,
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       projectId = Value(projectId),
       title = Value(title);
  static Insertable<ProjectMilestone> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<int>? projectId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? status,
    Expression<int>? sortOrder,
    Expression<DateTime>? dueDate,
    Expression<int>? invoiceId,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (status != null) 'status': status,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (dueDate != null) 'due_date': dueDate,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectMilestonesCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<int>? projectId,
    Value<String>? title,
    Value<String>? description,
    Value<double>? amount,
    Value<String>? currency,
    Value<String>? status,
    Value<int>? sortOrder,
    Value<DateTime?>? dueDate,
    Value<int?>? invoiceId,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProjectMilestonesCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      sortOrder: sortOrder ?? this.sortOrder,
      dueDate: dueDate ?? this.dueDate,
      invoiceId: invoiceId ?? this.invoiceId,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectMilestonesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('dueDate: $dueDate, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProjectReviewsTable extends ProjectReviews
    with TableInfo<$ProjectReviewsTable, ProjectReview> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _clientEmailMeta = const VerificationMeta(
    'clientEmail',
  );
  @override
  late final GeneratedColumn<String> clientEmail = GeneratedColumn<String>(
    'client_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fromClientMeta = const VerificationMeta(
    'fromClient',
  );
  @override
  late final GeneratedColumn<bool> fromClient = GeneratedColumn<bool>(
    'from_client',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("from_client" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    projectId,
    customerId,
    clientEmail,
    rating,
    comment,
    fromClient,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectReview> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('client_email')) {
      context.handle(
        _clientEmailMeta,
        clientEmail.isAcceptableOrUnknown(
          data['client_email']!,
          _clientEmailMeta,
        ),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('from_client')) {
      context.handle(
        _fromClientMeta,
        fromClient.isAcceptableOrUnknown(data['from_client']!, _fromClientMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectReview map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectReview(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      ),
      clientEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_email'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      )!,
      fromClient: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}from_client'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProjectReviewsTable createAlias(String alias) {
    return $ProjectReviewsTable(attachedDatabase, alias);
  }
}

class ProjectReview extends DataClass implements Insertable<ProjectReview> {
  final int id;
  final int ownerUserId;
  final int projectId;
  final int? customerId;
  final String clientEmail;
  final int rating;
  final String comment;
  final bool fromClient;
  final DateTime createdAt;
  const ProjectReview({
    required this.id,
    required this.ownerUserId,
    required this.projectId,
    this.customerId,
    required this.clientEmail,
    required this.rating,
    required this.comment,
    required this.fromClient,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['project_id'] = Variable<int>(projectId);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['client_email'] = Variable<String>(clientEmail);
    map['rating'] = Variable<int>(rating);
    map['comment'] = Variable<String>(comment);
    map['from_client'] = Variable<bool>(fromClient);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProjectReviewsCompanion toCompanion(bool nullToAbsent) {
    return ProjectReviewsCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      projectId: Value(projectId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      clientEmail: Value(clientEmail),
      rating: Value(rating),
      comment: Value(comment),
      fromClient: Value(fromClient),
      createdAt: Value(createdAt),
    );
  }

  factory ProjectReview.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectReview(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      projectId: serializer.fromJson<int>(json['projectId']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      clientEmail: serializer.fromJson<String>(json['clientEmail']),
      rating: serializer.fromJson<int>(json['rating']),
      comment: serializer.fromJson<String>(json['comment']),
      fromClient: serializer.fromJson<bool>(json['fromClient']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'projectId': serializer.toJson<int>(projectId),
      'customerId': serializer.toJson<int?>(customerId),
      'clientEmail': serializer.toJson<String>(clientEmail),
      'rating': serializer.toJson<int>(rating),
      'comment': serializer.toJson<String>(comment),
      'fromClient': serializer.toJson<bool>(fromClient),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProjectReview copyWith({
    int? id,
    int? ownerUserId,
    int? projectId,
    Value<int?> customerId = const Value.absent(),
    String? clientEmail,
    int? rating,
    String? comment,
    bool? fromClient,
    DateTime? createdAt,
  }) => ProjectReview(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    projectId: projectId ?? this.projectId,
    customerId: customerId.present ? customerId.value : this.customerId,
    clientEmail: clientEmail ?? this.clientEmail,
    rating: rating ?? this.rating,
    comment: comment ?? this.comment,
    fromClient: fromClient ?? this.fromClient,
    createdAt: createdAt ?? this.createdAt,
  );
  ProjectReview copyWithCompanion(ProjectReviewsCompanion data) {
    return ProjectReview(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      clientEmail: data.clientEmail.present
          ? data.clientEmail.value
          : this.clientEmail,
      rating: data.rating.present ? data.rating.value : this.rating,
      comment: data.comment.present ? data.comment.value : this.comment,
      fromClient: data.fromClient.present
          ? data.fromClient.value
          : this.fromClient,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectReview(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('projectId: $projectId, ')
          ..write('customerId: $customerId, ')
          ..write('clientEmail: $clientEmail, ')
          ..write('rating: $rating, ')
          ..write('comment: $comment, ')
          ..write('fromClient: $fromClient, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    projectId,
    customerId,
    clientEmail,
    rating,
    comment,
    fromClient,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectReview &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.projectId == this.projectId &&
          other.customerId == this.customerId &&
          other.clientEmail == this.clientEmail &&
          other.rating == this.rating &&
          other.comment == this.comment &&
          other.fromClient == this.fromClient &&
          other.createdAt == this.createdAt);
}

class ProjectReviewsCompanion extends UpdateCompanion<ProjectReview> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<int> projectId;
  final Value<int?> customerId;
  final Value<String> clientEmail;
  final Value<int> rating;
  final Value<String> comment;
  final Value<bool> fromClient;
  final Value<DateTime> createdAt;
  const ProjectReviewsCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.clientEmail = const Value.absent(),
    this.rating = const Value.absent(),
    this.comment = const Value.absent(),
    this.fromClient = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProjectReviewsCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required int projectId,
    this.customerId = const Value.absent(),
    this.clientEmail = const Value.absent(),
    this.rating = const Value.absent(),
    this.comment = const Value.absent(),
    this.fromClient = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       projectId = Value(projectId);
  static Insertable<ProjectReview> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<int>? projectId,
    Expression<int>? customerId,
    Expression<String>? clientEmail,
    Expression<int>? rating,
    Expression<String>? comment,
    Expression<bool>? fromClient,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (projectId != null) 'project_id': projectId,
      if (customerId != null) 'customer_id': customerId,
      if (clientEmail != null) 'client_email': clientEmail,
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
      if (fromClient != null) 'from_client': fromClient,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProjectReviewsCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<int>? projectId,
    Value<int?>? customerId,
    Value<String>? clientEmail,
    Value<int>? rating,
    Value<String>? comment,
    Value<bool>? fromClient,
    Value<DateTime>? createdAt,
  }) {
    return ProjectReviewsCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      projectId: projectId ?? this.projectId,
      customerId: customerId ?? this.customerId,
      clientEmail: clientEmail ?? this.clientEmail,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      fromClient: fromClient ?? this.fromClient,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (clientEmail.present) {
      map['client_email'] = Variable<String>(clientEmail.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (fromClient.present) {
      map['from_client'] = Variable<bool>(fromClient.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectReviewsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('projectId: $projectId, ')
          ..write('customerId: $customerId, ')
          ..write('clientEmail: $clientEmail, ')
          ..write('rating: $rating, ')
          ..write('comment: $comment, ')
          ..write('fromClient: $fromClient, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $InvoiceDisputesTable extends InvoiceDisputes
    with TableInfo<$InvoiceDisputesTable, InvoiceDispute> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceDisputesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _resolutionMeta = const VerificationMeta(
    'resolution',
  );
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
    'resolution',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _raisedByEmailMeta = const VerificationMeta(
    'raisedByEmail',
  );
  @override
  late final GeneratedColumn<String> raisedByEmail = GeneratedColumn<String>(
    'raised_by_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    invoiceId,
    reason,
    status,
    resolution,
    raisedByEmail,
    createdAt,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_disputes';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceDispute> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('resolution')) {
      context.handle(
        _resolutionMeta,
        resolution.isAcceptableOrUnknown(data['resolution']!, _resolutionMeta),
      );
    }
    if (data.containsKey('raised_by_email')) {
      context.handle(
        _raisedByEmailMeta,
        raisedByEmail.isAcceptableOrUnknown(
          data['raised_by_email']!,
          _raisedByEmailMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceDispute map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceDispute(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      resolution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolution'],
      )!,
      raisedByEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raised_by_email'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
    );
  }

  @override
  $InvoiceDisputesTable createAlias(String alias) {
    return $InvoiceDisputesTable(attachedDatabase, alias);
  }
}

class InvoiceDispute extends DataClass implements Insertable<InvoiceDispute> {
  final int id;
  final int ownerUserId;
  final int invoiceId;
  final String reason;
  final String status;
  final String resolution;
  final String raisedByEmail;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  const InvoiceDispute({
    required this.id,
    required this.ownerUserId,
    required this.invoiceId,
    required this.reason,
    required this.status,
    required this.resolution,
    required this.raisedByEmail,
    required this.createdAt,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_user_id'] = Variable<int>(ownerUserId);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['reason'] = Variable<String>(reason);
    map['status'] = Variable<String>(status);
    map['resolution'] = Variable<String>(resolution);
    map['raised_by_email'] = Variable<String>(raisedByEmail);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  InvoiceDisputesCompanion toCompanion(bool nullToAbsent) {
    return InvoiceDisputesCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      invoiceId: Value(invoiceId),
      reason: Value(reason),
      status: Value(status),
      resolution: Value(resolution),
      raisedByEmail: Value(raisedByEmail),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory InvoiceDispute.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceDispute(
      id: serializer.fromJson<int>(json['id']),
      ownerUserId: serializer.fromJson<int>(json['ownerUserId']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      reason: serializer.fromJson<String>(json['reason']),
      status: serializer.fromJson<String>(json['status']),
      resolution: serializer.fromJson<String>(json['resolution']),
      raisedByEmail: serializer.fromJson<String>(json['raisedByEmail']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUserId': serializer.toJson<int>(ownerUserId),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'reason': serializer.toJson<String>(reason),
      'status': serializer.toJson<String>(status),
      'resolution': serializer.toJson<String>(resolution),
      'raisedByEmail': serializer.toJson<String>(raisedByEmail),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  InvoiceDispute copyWith({
    int? id,
    int? ownerUserId,
    int? invoiceId,
    String? reason,
    String? status,
    String? resolution,
    String? raisedByEmail,
    DateTime? createdAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
  }) => InvoiceDispute(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    invoiceId: invoiceId ?? this.invoiceId,
    reason: reason ?? this.reason,
    status: status ?? this.status,
    resolution: resolution ?? this.resolution,
    raisedByEmail: raisedByEmail ?? this.raisedByEmail,
    createdAt: createdAt ?? this.createdAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  InvoiceDispute copyWithCompanion(InvoiceDisputesCompanion data) {
    return InvoiceDispute(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      resolution: data.resolution.present
          ? data.resolution.value
          : this.resolution,
      raisedByEmail: data.raisedByEmail.present
          ? data.raisedByEmail.value
          : this.raisedByEmail,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceDispute(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('resolution: $resolution, ')
          ..write('raisedByEmail: $raisedByEmail, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    invoiceId,
    reason,
    status,
    resolution,
    raisedByEmail,
    createdAt,
    resolvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceDispute &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.invoiceId == this.invoiceId &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.resolution == this.resolution &&
          other.raisedByEmail == this.raisedByEmail &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt);
}

class InvoiceDisputesCompanion extends UpdateCompanion<InvoiceDispute> {
  final Value<int> id;
  final Value<int> ownerUserId;
  final Value<int> invoiceId;
  final Value<String> reason;
  final Value<String> status;
  final Value<String> resolution;
  final Value<String> raisedByEmail;
  final Value<DateTime> createdAt;
  final Value<DateTime?> resolvedAt;
  const InvoiceDisputesCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.resolution = const Value.absent(),
    this.raisedByEmail = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
  });
  InvoiceDisputesCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUserId,
    required int invoiceId,
    required String reason,
    this.status = const Value.absent(),
    this.resolution = const Value.absent(),
    this.raisedByEmail = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       invoiceId = Value(invoiceId),
       reason = Value(reason);
  static Insertable<InvoiceDispute> custom({
    Expression<int>? id,
    Expression<int>? ownerUserId,
    Expression<int>? invoiceId,
    Expression<String>? reason,
    Expression<String>? status,
    Expression<String>? resolution,
    Expression<String>? raisedByEmail,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? resolvedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (resolution != null) 'resolution': resolution,
      if (raisedByEmail != null) 'raised_by_email': raisedByEmail,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
    });
  }

  InvoiceDisputesCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUserId,
    Value<int>? invoiceId,
    Value<String>? reason,
    Value<String>? status,
    Value<String>? resolution,
    Value<String>? raisedByEmail,
    Value<DateTime>? createdAt,
    Value<DateTime?>? resolvedAt,
  }) {
    return InvoiceDisputesCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      invoiceId: invoiceId ?? this.invoiceId,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      resolution: resolution ?? this.resolution,
      raisedByEmail: raisedByEmail ?? this.raisedByEmail,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (raisedByEmail.present) {
      map['raised_by_email'] = Variable<String>(raisedByEmail.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceDisputesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('resolution: $resolution, ')
          ..write('raisedByEmail: $raisedByEmail, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $BusinessProfilesTable businessProfiles = $BusinessProfilesTable(
    this,
  );
  late final $InvoiceBrandingsTable invoiceBrandings = $InvoiceBrandingsTable(
    this,
  );
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final $TasksTable tasks = $TasksTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $MessageTemplatesTable messageTemplates = $MessageTemplatesTable(
    this,
  );
  late final $ContractsTable contracts = $ContractsTable(this);
  late final $AppAnalyticsTable appAnalytics = $AppAnalyticsTable(this);
  late final $TrackingEventsTable trackingEvents = $TrackingEventsTable(this);
  late final $ProjectTimeEntriesTable projectTimeEntries =
      $ProjectTimeEntriesTable(this);
  late final $ProjectClientLinksTable projectClientLinks =
      $ProjectClientLinksTable(this);
  late final $ClientMessagesTable clientMessages = $ClientMessagesTable(this);
  late final $TeamMembersTable teamMembers = $TeamMembersTable(this);
  late final $FileAttachmentsTable fileAttachments = $FileAttachmentsTable(
    this,
  );
  late final $CalendarRemindersTable calendarReminders =
      $CalendarRemindersTable(this);
  late final $ProjectMilestonesTable projectMilestones =
      $ProjectMilestonesTable(this);
  late final $ProjectReviewsTable projectReviews = $ProjectReviewsTable(this);
  late final $InvoiceDisputesTable invoiceDisputes = $InvoiceDisputesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    customers,
    projects,
    invoices,
    businessProfiles,
    invoiceBrandings,
    appSettingsTable,
    tasks,
    expenses,
    notes,
    messageTemplates,
    contracts,
    appAnalytics,
    trackingEvents,
    projectTimeEntries,
    projectClientLinks,
    clientMessages,
    teamMembers,
    fileAttachments,
    calendarReminders,
    projectMilestones,
    projectReviews,
    invoiceDisputes,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String email,
      Value<String> passwordHash,
      required String name,
      Value<String?> profilePhotoPath,
      Value<String> role,
      Value<String> accountType,
      Value<String?> googleId,
      Value<bool> emailVerified,
      Value<DateTime> createdAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> email,
      Value<String> passwordHash,
      Value<String> name,
      Value<String?> profilePhotoPath,
      Value<String> role,
      Value<String> accountType,
      Value<String?> googleId,
      Value<bool> emailVerified,
      Value<DateTime> createdAt,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CustomersTable, List<Customer>>
  _customersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customers,
    aliasName: 'users__id__customers__owner_user_id',
  );

  $$CustomersTableProcessedTableManager get customersRefs {
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_customersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectsTable, List<Project>> _projectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'users__id__projects__owner_user_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: 'users__id__invoices__owner_user_id',
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BusinessProfilesTable, List<BusinessProfile>>
  _businessProfilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.businessProfiles,
    aliasName: 'users__id__business_profiles__user_id',
  );

  $$BusinessProfilesTableProcessedTableManager get businessProfilesRefs {
    final manager = $$BusinessProfilesTableTableManager(
      $_db,
      $_db.businessProfiles,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _businessProfilesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoiceBrandingsTable, List<InvoiceBranding>>
  _invoiceBrandingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceBrandings,
    aliasName: 'users__id__invoice_brandings__user_id',
  );

  $$InvoiceBrandingsTableProcessedTableManager get invoiceBrandingsRefs {
    final manager = $$InvoiceBrandingsTableTableManager(
      $_db,
      $_db.invoiceBrandings,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _invoiceBrandingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AppSettingsTableTable, List<AppSettingsTableData>>
  _appSettingsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appSettingsTable,
    aliasName: 'users__id__app_settings_table__user_id',
  );

  $$AppSettingsTableTableProcessedTableManager get appSettingsTableRefs {
    final manager = $$AppSettingsTableTableTableManager(
      $_db,
      $_db.appSettingsTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _appSettingsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'users__id__tasks__owner_user_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'users__id__expenses__owner_user_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<Note>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: 'users__id__notes__owner_user_id',
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MessageTemplatesTable, List<MessageTemplate>>
  _messageTemplatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.messageTemplates,
    aliasName: 'users__id__message_templates__owner_user_id',
  );

  $$MessageTemplatesTableProcessedTableManager get messageTemplatesRefs {
    final manager = $$MessageTemplatesTableTableManager(
      $_db,
      $_db.messageTemplates,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _messageTemplatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContractsTable, List<Contract>>
  _contractsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contracts,
    aliasName: 'users__id__contracts__owner_user_id',
  );

  $$ContractsTableProcessedTableManager get contractsRefs {
    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contractsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrackingEventsTable, List<TrackingEvent>>
  _trackingEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trackingEvents,
    aliasName: 'users__id__tracking_events__owner_user_id',
  );

  $$TrackingEventsTableProcessedTableManager get trackingEventsRefs {
    final manager = $$TrackingEventsTableTableManager(
      $_db,
      $_db.trackingEvents,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackingEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectTimeEntriesTable, List<ProjectTimeEntry>>
  _projectTimeEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectTimeEntries,
        aliasName: 'users__id__project_time_entries__owner_user_id',
      );

  $$ProjectTimeEntriesTableProcessedTableManager get projectTimeEntriesRefs {
    final manager = $$ProjectTimeEntriesTableTableManager(
      $_db,
      $_db.projectTimeEntries,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectTimeEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TeamMembersTable, List<TeamMember>>
  _teamMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.teamMembers,
    aliasName: 'users__id__team_members__owner_user_id',
  );

  $$TeamMembersTableProcessedTableManager get teamMembersRefs {
    final manager = $$TeamMembersTableTableManager(
      $_db,
      $_db.teamMembers,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_teamMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FileAttachmentsTable, List<FileAttachment>>
  _fileAttachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fileAttachments,
    aliasName: 'users__id__file_attachments__owner_user_id',
  );

  $$FileAttachmentsTableProcessedTableManager get fileAttachmentsRefs {
    final manager = $$FileAttachmentsTableTableManager(
      $_db,
      $_db.fileAttachments,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _fileAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CalendarRemindersTable, List<CalendarReminder>>
  _calendarRemindersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.calendarReminders,
        aliasName: 'users__id__calendar_reminders__owner_user_id',
      );

  $$CalendarRemindersTableProcessedTableManager get calendarRemindersRefs {
    final manager = $$CalendarRemindersTableTableManager(
      $_db,
      $_db.calendarReminders,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _calendarRemindersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectMilestonesTable, List<ProjectMilestone>>
  _projectMilestonesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectMilestones,
        aliasName: 'users__id__project_milestones__owner_user_id',
      );

  $$ProjectMilestonesTableProcessedTableManager get projectMilestonesRefs {
    final manager = $$ProjectMilestonesTableTableManager(
      $_db,
      $_db.projectMilestones,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectMilestonesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectReviewsTable, List<ProjectReview>>
  _projectReviewsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projectReviews,
    aliasName: 'users__id__project_reviews__owner_user_id',
  );

  $$ProjectReviewsTableProcessedTableManager get projectReviewsRefs {
    final manager = $$ProjectReviewsTableTableManager(
      $_db,
      $_db.projectReviews,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectReviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoiceDisputesTable, List<InvoiceDispute>>
  _invoiceDisputesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceDisputes,
    aliasName: 'users__id__invoice_disputes__owner_user_id',
  );

  $$InvoiceDisputesTableProcessedTableManager get invoiceDisputesRefs {
    final manager = $$InvoiceDisputesTableTableManager(
      $_db,
      $_db.invoiceDisputes,
    ).filter((f) => f.ownerUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _invoiceDisputesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profilePhotoPath => $composableBuilder(
    column: $table.profilePhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleId => $composableBuilder(
    column: $table.googleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customersRefs(
    Expression<bool> Function($$CustomersTableFilterComposer f) f,
  ) {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> businessProfilesRefs(
    Expression<bool> Function($$BusinessProfilesTableFilterComposer f) f,
  ) {
    final $$BusinessProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.businessProfiles,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BusinessProfilesTableFilterComposer(
            $db: $db,
            $table: $db.businessProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoiceBrandingsRefs(
    Expression<bool> Function($$InvoiceBrandingsTableFilterComposer f) f,
  ) {
    final $$InvoiceBrandingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceBrandings,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceBrandingsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceBrandings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> appSettingsTableRefs(
    Expression<bool> Function($$AppSettingsTableTableFilterComposer f) f,
  ) {
    final $$AppSettingsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appSettingsTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppSettingsTableTableFilterComposer(
            $db: $db,
            $table: $db.appSettingsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> messageTemplatesRefs(
    Expression<bool> Function($$MessageTemplatesTableFilterComposer f) f,
  ) {
    final $$MessageTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messageTemplates,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessageTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.messageTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contractsRefs(
    Expression<bool> Function($$ContractsTableFilterComposer f) f,
  ) {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trackingEventsRefs(
    Expression<bool> Function($$TrackingEventsTableFilterComposer f) f,
  ) {
    final $$TrackingEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackingEvents,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackingEventsTableFilterComposer(
            $db: $db,
            $table: $db.trackingEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectTimeEntriesRefs(
    Expression<bool> Function($$ProjectTimeEntriesTableFilterComposer f) f,
  ) {
    final $$ProjectTimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectTimeEntries,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectTimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.projectTimeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> teamMembersRefs(
    Expression<bool> Function($$TeamMembersTableFilterComposer f) f,
  ) {
    final $$TeamMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamMembers,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamMembersTableFilterComposer(
            $db: $db,
            $table: $db.teamMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fileAttachmentsRefs(
    Expression<bool> Function($$FileAttachmentsTableFilterComposer f) f,
  ) {
    final $$FileAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fileAttachments,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FileAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.fileAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> calendarRemindersRefs(
    Expression<bool> Function($$CalendarRemindersTableFilterComposer f) f,
  ) {
    final $$CalendarRemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.calendarReminders,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarRemindersTableFilterComposer(
            $db: $db,
            $table: $db.calendarReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectMilestonesRefs(
    Expression<bool> Function($$ProjectMilestonesTableFilterComposer f) f,
  ) {
    final $$ProjectMilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectMilestones,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectMilestonesTableFilterComposer(
            $db: $db,
            $table: $db.projectMilestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectReviewsRefs(
    Expression<bool> Function($$ProjectReviewsTableFilterComposer f) f,
  ) {
    final $$ProjectReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectReviews,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectReviewsTableFilterComposer(
            $db: $db,
            $table: $db.projectReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoiceDisputesRefs(
    Expression<bool> Function($$InvoiceDisputesTableFilterComposer f) f,
  ) {
    final $$InvoiceDisputesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceDisputes,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceDisputesTableFilterComposer(
            $db: $db,
            $table: $db.invoiceDisputes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profilePhotoPath => $composableBuilder(
    column: $table.profilePhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleId => $composableBuilder(
    column: $table.googleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get profilePhotoPath => $composableBuilder(
    column: $table.profilePhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get googleId =>
      $composableBuilder(column: $table.googleId, builder: (column) => column);

  GeneratedColumn<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> customersRefs<T extends Object>(
    Expression<T> Function($$CustomersTableAnnotationComposer a) f,
  ) {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> businessProfilesRefs<T extends Object>(
    Expression<T> Function($$BusinessProfilesTableAnnotationComposer a) f,
  ) {
    final $$BusinessProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.businessProfiles,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BusinessProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.businessProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> invoiceBrandingsRefs<T extends Object>(
    Expression<T> Function($$InvoiceBrandingsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceBrandingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceBrandings,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceBrandingsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceBrandings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> appSettingsTableRefs<T extends Object>(
    Expression<T> Function($$AppSettingsTableTableAnnotationComposer a) f,
  ) {
    final $$AppSettingsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appSettingsTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppSettingsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.appSettingsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> messageTemplatesRefs<T extends Object>(
    Expression<T> Function($$MessageTemplatesTableAnnotationComposer a) f,
  ) {
    final $$MessageTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messageTemplates,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessageTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.messageTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contractsRefs<T extends Object>(
    Expression<T> Function($$ContractsTableAnnotationComposer a) f,
  ) {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trackingEventsRefs<T extends Object>(
    Expression<T> Function($$TrackingEventsTableAnnotationComposer a) f,
  ) {
    final $$TrackingEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackingEvents,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackingEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackingEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectTimeEntriesRefs<T extends Object>(
    Expression<T> Function($$ProjectTimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$ProjectTimeEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectTimeEntries,
          getReferencedColumn: (t) => t.ownerUserId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectTimeEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.projectTimeEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> teamMembersRefs<T extends Object>(
    Expression<T> Function($$TeamMembersTableAnnotationComposer a) f,
  ) {
    final $$TeamMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamMembers,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.teamMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fileAttachmentsRefs<T extends Object>(
    Expression<T> Function($$FileAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$FileAttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fileAttachments,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FileAttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.fileAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> calendarRemindersRefs<T extends Object>(
    Expression<T> Function($$CalendarRemindersTableAnnotationComposer a) f,
  ) {
    final $$CalendarRemindersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.calendarReminders,
          getReferencedColumn: (t) => t.ownerUserId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CalendarRemindersTableAnnotationComposer(
                $db: $db,
                $table: $db.calendarReminders,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> projectMilestonesRefs<T extends Object>(
    Expression<T> Function($$ProjectMilestonesTableAnnotationComposer a) f,
  ) {
    final $$ProjectMilestonesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectMilestones,
          getReferencedColumn: (t) => t.ownerUserId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectMilestonesTableAnnotationComposer(
                $db: $db,
                $table: $db.projectMilestones,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> projectReviewsRefs<T extends Object>(
    Expression<T> Function($$ProjectReviewsTableAnnotationComposer a) f,
  ) {
    final $$ProjectReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectReviews,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.projectReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> invoiceDisputesRefs<T extends Object>(
    Expression<T> Function($$InvoiceDisputesTableAnnotationComposer a) f,
  ) {
    final $$InvoiceDisputesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceDisputes,
      getReferencedColumn: (t) => t.ownerUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceDisputesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceDisputes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({
            bool customersRefs,
            bool projectsRefs,
            bool invoicesRefs,
            bool businessProfilesRefs,
            bool invoiceBrandingsRefs,
            bool appSettingsTableRefs,
            bool tasksRefs,
            bool expensesRefs,
            bool notesRefs,
            bool messageTemplatesRefs,
            bool contractsRefs,
            bool trackingEventsRefs,
            bool projectTimeEntriesRefs,
            bool teamMembersRefs,
            bool fileAttachmentsRefs,
            bool calendarRemindersRefs,
            bool projectMilestonesRefs,
            bool projectReviewsRefs,
            bool invoiceDisputesRefs,
          })
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> profilePhotoPath = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<String?> googleId = const Value.absent(),
                Value<bool> emailVerified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                passwordHash: passwordHash,
                name: name,
                profilePhotoPath: profilePhotoPath,
                role: role,
                accountType: accountType,
                googleId: googleId,
                emailVerified: emailVerified,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String email,
                Value<String> passwordHash = const Value.absent(),
                required String name,
                Value<String?> profilePhotoPath = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<String?> googleId = const Value.absent(),
                Value<bool> emailVerified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                passwordHash: passwordHash,
                name: name,
                profilePhotoPath: profilePhotoPath,
                role: role,
                accountType: accountType,
                googleId: googleId,
                emailVerified: emailVerified,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customersRefs = false,
                projectsRefs = false,
                invoicesRefs = false,
                businessProfilesRefs = false,
                invoiceBrandingsRefs = false,
                appSettingsTableRefs = false,
                tasksRefs = false,
                expensesRefs = false,
                notesRefs = false,
                messageTemplatesRefs = false,
                contractsRefs = false,
                trackingEventsRefs = false,
                projectTimeEntriesRefs = false,
                teamMembersRefs = false,
                fileAttachmentsRefs = false,
                calendarRemindersRefs = false,
                projectMilestonesRefs = false,
                projectReviewsRefs = false,
                invoiceDisputesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (customersRefs) db.customers,
                    if (projectsRefs) db.projects,
                    if (invoicesRefs) db.invoices,
                    if (businessProfilesRefs) db.businessProfiles,
                    if (invoiceBrandingsRefs) db.invoiceBrandings,
                    if (appSettingsTableRefs) db.appSettingsTable,
                    if (tasksRefs) db.tasks,
                    if (expensesRefs) db.expenses,
                    if (notesRefs) db.notes,
                    if (messageTemplatesRefs) db.messageTemplates,
                    if (contractsRefs) db.contracts,
                    if (trackingEventsRefs) db.trackingEvents,
                    if (projectTimeEntriesRefs) db.projectTimeEntries,
                    if (teamMembersRefs) db.teamMembers,
                    if (fileAttachmentsRefs) db.fileAttachments,
                    if (calendarRemindersRefs) db.calendarReminders,
                    if (projectMilestonesRefs) db.projectMilestones,
                    if (projectReviewsRefs) db.projectReviews,
                    if (invoiceDisputesRefs) db.invoiceDisputes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (customersRefs)
                        await $_getPrefetchedData<User, $UsersTable, Customer>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._customersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).customersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectsRefs)
                        await $_getPrefetchedData<User, $UsersTable, Project>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoicesRefs)
                        await $_getPrefetchedData<User, $UsersTable, Invoice>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (businessProfilesRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          BusinessProfile
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._businessProfilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).businessProfilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoiceBrandingsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          InvoiceBranding
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._invoiceBrandingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceBrandingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (appSettingsTableRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          AppSettingsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._appSettingsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).appSettingsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<User, $UsersTable, Task>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(db, table, p0).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<User, $UsersTable, Expense>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<User, $UsersTable, Note>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(db, table, p0).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (messageTemplatesRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          MessageTemplate
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._messageTemplatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).messageTemplatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (contractsRefs)
                        await $_getPrefetchedData<User, $UsersTable, Contract>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._contractsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).contractsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (trackingEventsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          TrackingEvent
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._trackingEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).trackingEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectTimeEntriesRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          ProjectTimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._projectTimeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).projectTimeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (teamMembersRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          TeamMember
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._teamMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).teamMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fileAttachmentsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          FileAttachment
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._fileAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).fileAttachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (calendarRemindersRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          CalendarReminder
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._calendarRemindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).calendarRemindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectMilestonesRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          ProjectMilestone
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._projectMilestonesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).projectMilestonesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectReviewsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          ProjectReview
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._projectReviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).projectReviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoiceDisputesRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          InvoiceDispute
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._invoiceDisputesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceDisputesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({
        bool customersRefs,
        bool projectsRefs,
        bool invoicesRefs,
        bool businessProfilesRefs,
        bool invoiceBrandingsRefs,
        bool appSettingsTableRefs,
        bool tasksRefs,
        bool expensesRefs,
        bool notesRefs,
        bool messageTemplatesRefs,
        bool contractsRefs,
        bool trackingEventsRefs,
        bool projectTimeEntriesRefs,
        bool teamMembersRefs,
        bool fileAttachmentsRefs,
        bool calendarRemindersRefs,
        bool projectMilestonesRefs,
        bool projectReviewsRefs,
        bool invoiceDisputesRefs,
      })
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required String contactPerson,
      Value<String> company,
      Value<String> emails,
      Value<String> phones,
      Value<String> whatsapp,
      Value<String> address,
      Value<String> city,
      Value<String> postalCode,
      Value<String> country,
      Value<String> notes,
      Value<String> tags,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<String> contactPerson,
      Value<String> company,
      Value<String> emails,
      Value<String> phones,
      Value<String> whatsapp,
      Value<String> address,
      Value<String> city,
      Value<String> postalCode,
      Value<String> country,
      Value<String> notes,
      Value<String> tags,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('customers__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProjectsTable, List<Project>> _projectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'customers__id__projects__customer_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: 'customers__id__invoices__customer_id',
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'customers__id__tasks__customer_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'customers__id__expenses__customer_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<Note>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: 'customers__id__notes__customer_id',
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContractsTable, List<Contract>>
  _contractsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contracts,
    aliasName: 'customers__id__contracts__customer_id',
  );

  $$ContractsTableProcessedTableManager get contractsRefs {
    final manager = $$ContractsTableTableManager(
      $_db,
      $_db.contracts,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contractsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectReviewsTable, List<ProjectReview>>
  _projectReviewsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projectReviews,
    aliasName: 'customers__id__project_reviews__customer_id',
  );

  $$ProjectReviewsTableProcessedTableManager get projectReviewsRefs {
    final manager = $$ProjectReviewsTableTableManager(
      $_db,
      $_db.projectReviews,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectReviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emails => $composableBuilder(
    column: $table.emails,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phones => $composableBuilder(
    column: $table.phones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsapp => $composableBuilder(
    column: $table.whatsapp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contractsRefs(
    Expression<bool> Function($$ContractsTableFilterComposer f) f,
  ) {
    final $$ContractsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableFilterComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectReviewsRefs(
    Expression<bool> Function($$ProjectReviewsTableFilterComposer f) f,
  ) {
    final $$ProjectReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectReviews,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectReviewsTableFilterComposer(
            $db: $db,
            $table: $db.projectReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emails => $composableBuilder(
    column: $table.emails,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phones => $composableBuilder(
    column: $table.phones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsapp => $composableBuilder(
    column: $table.whatsapp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get emails =>
      $composableBuilder(column: $table.emails, builder: (column) => column);

  GeneratedColumn<String> get phones =>
      $composableBuilder(column: $table.phones, builder: (column) => column);

  GeneratedColumn<String> get whatsapp =>
      $composableBuilder(column: $table.whatsapp, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get postalCode => $composableBuilder(
    column: $table.postalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contractsRefs<T extends Object>(
    Expression<T> Function($$ContractsTableAnnotationComposer a) f,
  ) {
    final $$ContractsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contracts,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContractsTableAnnotationComposer(
            $db: $db,
            $table: $db.contracts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectReviewsRefs<T extends Object>(
    Expression<T> Function($$ProjectReviewsTableAnnotationComposer a) f,
  ) {
    final $$ProjectReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectReviews,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.projectReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({
            bool ownerUserId,
            bool projectsRefs,
            bool invoicesRefs,
            bool tasksRefs,
            bool expensesRefs,
            bool notesRefs,
            bool contractsRefs,
            bool projectReviewsRefs,
          })
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<String> contactPerson = const Value.absent(),
                Value<String> company = const Value.absent(),
                Value<String> emails = const Value.absent(),
                Value<String> phones = const Value.absent(),
                Value<String> whatsapp = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> postalCode = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                ownerUserId: ownerUserId,
                contactPerson: contactPerson,
                company: company,
                emails: emails,
                phones: phones,
                whatsapp: whatsapp,
                address: address,
                city: city,
                postalCode: postalCode,
                country: country,
                notes: notes,
                tags: tags,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required String contactPerson,
                Value<String> company = const Value.absent(),
                Value<String> emails = const Value.absent(),
                Value<String> phones = const Value.absent(),
                Value<String> whatsapp = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> postalCode = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                contactPerson: contactPerson,
                company: company,
                emails: emails,
                phones: phones,
                whatsapp: whatsapp,
                address: address,
                city: city,
                postalCode: postalCode,
                country: country,
                notes: notes,
                tags: tags,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ownerUserId = false,
                projectsRefs = false,
                invoicesRefs = false,
                tasksRefs = false,
                expensesRefs = false,
                notesRefs = false,
                contractsRefs = false,
                projectReviewsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (projectsRefs) db.projects,
                    if (invoicesRefs) db.invoices,
                    if (tasksRefs) db.tasks,
                    if (expensesRefs) db.expenses,
                    if (notesRefs) db.notes,
                    if (contractsRefs) db.contracts,
                    if (projectReviewsRefs) db.projectReviews,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ownerUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ownerUserId,
                                    referencedTable: $$CustomersTableReferences
                                        ._ownerUserIdTable(db),
                                    referencedColumn: $$CustomersTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (projectsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Project
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoicesRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Invoice
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Task
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Expense
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Note
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (contractsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Contract
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._contractsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).contractsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectReviewsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          ProjectReview
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._projectReviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).projectReviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({
        bool ownerUserId,
        bool projectsRefs,
        bool invoicesRefs,
        bool tasksRefs,
        bool expensesRefs,
        bool notesRefs,
        bool contractsRefs,
        bool projectReviewsRefs,
      })
    >;
typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required int customerId,
      required String name,
      Value<String> description,
      Value<double> budget,
      Value<String> currency,
      Value<String> pricingType,
      Value<DateTime?> startDate,
      Value<DateTime?> deadline,
      Value<String> priority,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<int> customerId,
      Value<String> name,
      Value<String> description,
      Value<double> budget,
      Value<String> currency,
      Value<String> pricingType,
      Value<DateTime?> startDate,
      Value<DateTime?> deadline,
      Value<String> priority,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('projects__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('projects__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: 'projects__id__invoices__project_id',
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'projects__id__tasks__project_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'projects__id__expenses__project_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<Note>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: 'projects__id__notes__project_id',
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectTimeEntriesTable, List<ProjectTimeEntry>>
  _projectTimeEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectTimeEntries,
        aliasName: 'projects__id__project_time_entries__project_id',
      );

  $$ProjectTimeEntriesTableProcessedTableManager get projectTimeEntriesRefs {
    final manager = $$ProjectTimeEntriesTableTableManager(
      $_db,
      $_db.projectTimeEntries,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectTimeEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectClientLinksTable, List<ProjectClientLink>>
  _projectClientLinksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectClientLinks,
        aliasName: 'projects__id__project_client_links__project_id',
      );

  $$ProjectClientLinksTableProcessedTableManager get projectClientLinksRefs {
    final manager = $$ProjectClientLinksTableTableManager(
      $_db,
      $_db.projectClientLinks,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectClientLinksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClientMessagesTable, List<ClientMessage>>
  _clientMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.clientMessages,
    aliasName: 'projects__id__client_messages__project_id',
  );

  $$ClientMessagesTableProcessedTableManager get clientMessagesRefs {
    final manager = $$ClientMessagesTableTableManager(
      $_db,
      $_db.clientMessages,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_clientMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectMilestonesTable, List<ProjectMilestone>>
  _projectMilestonesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectMilestones,
        aliasName: 'projects__id__project_milestones__project_id',
      );

  $$ProjectMilestonesTableProcessedTableManager get projectMilestonesRefs {
    final manager = $$ProjectMilestonesTableTableManager(
      $_db,
      $_db.projectMilestones,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectMilestonesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectReviewsTable, List<ProjectReview>>
  _projectReviewsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projectReviews,
    aliasName: 'projects__id__project_reviews__project_id',
  );

  $$ProjectReviewsTableProcessedTableManager get projectReviewsRefs {
    final manager = $$ProjectReviewsTableTableManager(
      $_db,
      $_db.projectReviews,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectReviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pricingType => $composableBuilder(
    column: $table.pricingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectTimeEntriesRefs(
    Expression<bool> Function($$ProjectTimeEntriesTableFilterComposer f) f,
  ) {
    final $$ProjectTimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectTimeEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectTimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.projectTimeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectClientLinksRefs(
    Expression<bool> Function($$ProjectClientLinksTableFilterComposer f) f,
  ) {
    final $$ProjectClientLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectClientLinks,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectClientLinksTableFilterComposer(
            $db: $db,
            $table: $db.projectClientLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> clientMessagesRefs(
    Expression<bool> Function($$ClientMessagesTableFilterComposer f) f,
  ) {
    final $$ClientMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientMessages,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientMessagesTableFilterComposer(
            $db: $db,
            $table: $db.clientMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectMilestonesRefs(
    Expression<bool> Function($$ProjectMilestonesTableFilterComposer f) f,
  ) {
    final $$ProjectMilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectMilestones,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectMilestonesTableFilterComposer(
            $db: $db,
            $table: $db.projectMilestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectReviewsRefs(
    Expression<bool> Function($$ProjectReviewsTableFilterComposer f) f,
  ) {
    final $$ProjectReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectReviews,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectReviewsTableFilterComposer(
            $db: $db,
            $table: $db.projectReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pricingType => $composableBuilder(
    column: $table.pricingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get pricingType => $composableBuilder(
    column: $table.pricingType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectTimeEntriesRefs<T extends Object>(
    Expression<T> Function($$ProjectTimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$ProjectTimeEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectTimeEntries,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectTimeEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.projectTimeEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> projectClientLinksRefs<T extends Object>(
    Expression<T> Function($$ProjectClientLinksTableAnnotationComposer a) f,
  ) {
    final $$ProjectClientLinksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectClientLinks,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectClientLinksTableAnnotationComposer(
                $db: $db,
                $table: $db.projectClientLinks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> clientMessagesRefs<T extends Object>(
    Expression<T> Function($$ClientMessagesTableAnnotationComposer a) f,
  ) {
    final $$ClientMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientMessages,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectMilestonesRefs<T extends Object>(
    Expression<T> Function($$ProjectMilestonesTableAnnotationComposer a) f,
  ) {
    final $$ProjectMilestonesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectMilestones,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectMilestonesTableAnnotationComposer(
                $db: $db,
                $table: $db.projectMilestones,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> projectReviewsRefs<T extends Object>(
    Expression<T> Function($$ProjectReviewsTableAnnotationComposer a) f,
  ) {
    final $$ProjectReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectReviews,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.projectReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({
            bool ownerUserId,
            bool customerId,
            bool invoicesRefs,
            bool tasksRefs,
            bool expensesRefs,
            bool notesRefs,
            bool projectTimeEntriesRefs,
            bool projectClientLinksRefs,
            bool clientMessagesRefs,
            bool projectMilestonesRefs,
            bool projectReviewsRefs,
          })
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<int> customerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> budget = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> pricingType = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                ownerUserId: ownerUserId,
                customerId: customerId,
                name: name,
                description: description,
                budget: budget,
                currency: currency,
                pricingType: pricingType,
                startDate: startDate,
                deadline: deadline,
                priority: priority,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required int customerId,
                required String name,
                Value<String> description = const Value.absent(),
                Value<double> budget = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> pricingType = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                customerId: customerId,
                name: name,
                description: description,
                budget: budget,
                currency: currency,
                pricingType: pricingType,
                startDate: startDate,
                deadline: deadline,
                priority: priority,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ownerUserId = false,
                customerId = false,
                invoicesRefs = false,
                tasksRefs = false,
                expensesRefs = false,
                notesRefs = false,
                projectTimeEntriesRefs = false,
                projectClientLinksRefs = false,
                clientMessagesRefs = false,
                projectMilestonesRefs = false,
                projectReviewsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoicesRefs) db.invoices,
                    if (tasksRefs) db.tasks,
                    if (expensesRefs) db.expenses,
                    if (notesRefs) db.notes,
                    if (projectTimeEntriesRefs) db.projectTimeEntries,
                    if (projectClientLinksRefs) db.projectClientLinks,
                    if (clientMessagesRefs) db.clientMessages,
                    if (projectMilestonesRefs) db.projectMilestones,
                    if (projectReviewsRefs) db.projectReviews,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ownerUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ownerUserId,
                                    referencedTable: $$ProjectsTableReferences
                                        ._ownerUserIdTable(db),
                                    referencedColumn: $$ProjectsTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$ProjectsTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$ProjectsTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoicesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Invoice
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Task
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Expense
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Note
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectTimeEntriesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          ProjectTimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._projectTimeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectTimeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectClientLinksRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          ProjectClientLink
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._projectClientLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectClientLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (clientMessagesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          ClientMessage
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._clientMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).clientMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectMilestonesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          ProjectMilestone
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._projectMilestonesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectMilestonesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectReviewsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          ProjectReview
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._projectReviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectReviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({
        bool ownerUserId,
        bool customerId,
        bool invoicesRefs,
        bool tasksRefs,
        bool expensesRefs,
        bool notesRefs,
        bool projectTimeEntriesRefs,
        bool projectClientLinksRefs,
        bool clientMessagesRefs,
        bool projectMilestonesRefs,
        bool projectReviewsRefs,
      })
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required String invoiceNumber,
      required int customerId,
      Value<int?> projectId,
      Value<String> status,
      Value<double> subtotal,
      Value<double> taxRate,
      Value<double> discount,
      Value<double> total,
      Value<String> currency,
      Value<String> lineItems,
      Value<DateTime> issueDate,
      Value<DateTime?> dueDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<String> invoiceNumber,
      Value<int> customerId,
      Value<int?> projectId,
      Value<String> status,
      Value<double> subtotal,
      Value<double> taxRate,
      Value<double> discount,
      Value<double> total,
      Value<String> currency,
      Value<String> lineItems,
      Value<DateTime> issueDate,
      Value<DateTime?> dueDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, Invoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('invoices__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('invoices__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('invoices__project_id__projects__id');

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<int>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProjectMilestonesTable, List<ProjectMilestone>>
  _projectMilestonesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectMilestones,
        aliasName: 'invoices__id__project_milestones__invoice_id',
      );

  $$ProjectMilestonesTableProcessedTableManager get projectMilestonesRefs {
    final manager = $$ProjectMilestonesTableTableManager(
      $_db,
      $_db.projectMilestones,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectMilestonesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoiceDisputesTable, List<InvoiceDispute>>
  _invoiceDisputesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceDisputes,
    aliasName: 'invoices__id__invoice_disputes__invoice_id',
  );

  $$InvoiceDisputesTableProcessedTableManager get invoiceDisputesRefs {
    final manager = $$InvoiceDisputesTableTableManager(
      $_db,
      $_db.invoiceDisputes,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _invoiceDisputesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lineItems => $composableBuilder(
    column: $table.lineItems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> projectMilestonesRefs(
    Expression<bool> Function($$ProjectMilestonesTableFilterComposer f) f,
  ) {
    final $$ProjectMilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectMilestones,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectMilestonesTableFilterComposer(
            $db: $db,
            $table: $db.projectMilestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoiceDisputesRefs(
    Expression<bool> Function($$InvoiceDisputesTableFilterComposer f) f,
  ) {
    final $$InvoiceDisputesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceDisputes,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceDisputesTableFilterComposer(
            $db: $db,
            $table: $db.invoiceDisputes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lineItems => $composableBuilder(
    column: $table.lineItems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get lineItems =>
      $composableBuilder(column: $table.lineItems, builder: (column) => column);

  GeneratedColumn<DateTime> get issueDate =>
      $composableBuilder(column: $table.issueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> projectMilestonesRefs<T extends Object>(
    Expression<T> Function($$ProjectMilestonesTableAnnotationComposer a) f,
  ) {
    final $$ProjectMilestonesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectMilestones,
          getReferencedColumn: (t) => t.invoiceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectMilestonesTableAnnotationComposer(
                $db: $db,
                $table: $db.projectMilestones,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> invoiceDisputesRefs<T extends Object>(
    Expression<T> Function($$InvoiceDisputesTableAnnotationComposer a) f,
  ) {
    final $$InvoiceDisputesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceDisputes,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceDisputesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceDisputes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, $$InvoicesTableReferences),
          Invoice,
          PrefetchHooks Function({
            bool ownerUserId,
            bool customerId,
            bool projectId,
            bool projectMilestonesRefs,
            bool invoiceDisputesRefs,
          })
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<int> customerId = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> lineItems = const Value.absent(),
                Value<DateTime> issueDate = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                ownerUserId: ownerUserId,
                invoiceNumber: invoiceNumber,
                customerId: customerId,
                projectId: projectId,
                status: status,
                subtotal: subtotal,
                taxRate: taxRate,
                discount: discount,
                total: total,
                currency: currency,
                lineItems: lineItems,
                issueDate: issueDate,
                dueDate: dueDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required String invoiceNumber,
                required int customerId,
                Value<int?> projectId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> lineItems = const Value.absent(),
                Value<DateTime> issueDate = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                invoiceNumber: invoiceNumber,
                customerId: customerId,
                projectId: projectId,
                status: status,
                subtotal: subtotal,
                taxRate: taxRate,
                discount: discount,
                total: total,
                currency: currency,
                lineItems: lineItems,
                issueDate: issueDate,
                dueDate: dueDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ownerUserId = false,
                customerId = false,
                projectId = false,
                projectMilestonesRefs = false,
                invoiceDisputesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (projectMilestonesRefs) db.projectMilestones,
                    if (invoiceDisputesRefs) db.invoiceDisputes,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ownerUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ownerUserId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._ownerUserIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (projectMilestonesRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          ProjectMilestone
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._projectMilestonesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).projectMilestonesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoiceDisputesRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          InvoiceDispute
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._invoiceDisputesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceDisputesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, $$InvoicesTableReferences),
      Invoice,
      PrefetchHooks Function({
        bool ownerUserId,
        bool customerId,
        bool projectId,
        bool projectMilestonesRefs,
        bool invoiceDisputesRefs,
      })
    >;
typedef $$BusinessProfilesTableCreateCompanionBuilder =
    BusinessProfilesCompanion Function({
      Value<int> userId,
      Value<String?> logoPath,
      Value<String> businessName,
      Value<String> businessEmail,
      Value<String> businessPhone,
      Value<String> ownerName,
      Value<String?> ownerPhotoPath,
      Value<String> businessAddress,
      Value<String> businessCity,
      Value<String> businessPostalCode,
      Value<String> businessCountry,
      Value<String> skills,
      Value<String> bio,
      Value<String> clientCompany,
      Value<String> clientIndustry,
      Value<String> clientWebsite,
      Value<DateTime> memberSince,
    });
typedef $$BusinessProfilesTableUpdateCompanionBuilder =
    BusinessProfilesCompanion Function({
      Value<int> userId,
      Value<String?> logoPath,
      Value<String> businessName,
      Value<String> businessEmail,
      Value<String> businessPhone,
      Value<String> ownerName,
      Value<String?> ownerPhotoPath,
      Value<String> businessAddress,
      Value<String> businessCity,
      Value<String> businessPostalCode,
      Value<String> businessCountry,
      Value<String> skills,
      Value<String> bio,
      Value<String> clientCompany,
      Value<String> clientIndustry,
      Value<String> clientWebsite,
      Value<DateTime> memberSince,
    });

final class $$BusinessProfilesTableReferences
    extends
        BaseReferences<_$AppDatabase, $BusinessProfilesTable, BusinessProfile> {
  $$BusinessProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('business_profiles__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BusinessProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessEmail => $composableBuilder(
    column: $table.businessEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessPhone => $composableBuilder(
    column: $table.businessPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerPhotoPath => $composableBuilder(
    column: $table.ownerPhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessAddress => $composableBuilder(
    column: $table.businessAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessCity => $composableBuilder(
    column: $table.businessCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessPostalCode => $composableBuilder(
    column: $table.businessPostalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessCountry => $composableBuilder(
    column: $table.businessCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skills => $composableBuilder(
    column: $table.skills,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientCompany => $composableBuilder(
    column: $table.clientCompany,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientIndustry => $composableBuilder(
    column: $table.clientIndustry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientWebsite => $composableBuilder(
    column: $table.clientWebsite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get memberSince => $composableBuilder(
    column: $table.memberSince,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BusinessProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessEmail => $composableBuilder(
    column: $table.businessEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessPhone => $composableBuilder(
    column: $table.businessPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerPhotoPath => $composableBuilder(
    column: $table.ownerPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessAddress => $composableBuilder(
    column: $table.businessAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessCity => $composableBuilder(
    column: $table.businessCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessPostalCode => $composableBuilder(
    column: $table.businessPostalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessCountry => $composableBuilder(
    column: $table.businessCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skills => $composableBuilder(
    column: $table.skills,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientCompany => $composableBuilder(
    column: $table.clientCompany,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientIndustry => $composableBuilder(
    column: $table.clientIndustry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientWebsite => $composableBuilder(
    column: $table.clientWebsite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get memberSince => $composableBuilder(
    column: $table.memberSince,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BusinessProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessEmail => $composableBuilder(
    column: $table.businessEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessPhone => $composableBuilder(
    column: $table.businessPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerName =>
      $composableBuilder(column: $table.ownerName, builder: (column) => column);

  GeneratedColumn<String> get ownerPhotoPath => $composableBuilder(
    column: $table.ownerPhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessAddress => $composableBuilder(
    column: $table.businessAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessCity => $composableBuilder(
    column: $table.businessCity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessPostalCode => $composableBuilder(
    column: $table.businessPostalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessCountry => $composableBuilder(
    column: $table.businessCountry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get skills =>
      $composableBuilder(column: $table.skills, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get clientCompany => $composableBuilder(
    column: $table.clientCompany,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientIndustry => $composableBuilder(
    column: $table.clientIndustry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientWebsite => $composableBuilder(
    column: $table.clientWebsite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get memberSince => $composableBuilder(
    column: $table.memberSince,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BusinessProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BusinessProfilesTable,
          BusinessProfile,
          $$BusinessProfilesTableFilterComposer,
          $$BusinessProfilesTableOrderingComposer,
          $$BusinessProfilesTableAnnotationComposer,
          $$BusinessProfilesTableCreateCompanionBuilder,
          $$BusinessProfilesTableUpdateCompanionBuilder,
          (BusinessProfile, $$BusinessProfilesTableReferences),
          BusinessProfile,
          PrefetchHooks Function({bool userId})
        > {
  $$BusinessProfilesTableTableManager(
    _$AppDatabase db,
    $BusinessProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> userId = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String> businessName = const Value.absent(),
                Value<String> businessEmail = const Value.absent(),
                Value<String> businessPhone = const Value.absent(),
                Value<String> ownerName = const Value.absent(),
                Value<String?> ownerPhotoPath = const Value.absent(),
                Value<String> businessAddress = const Value.absent(),
                Value<String> businessCity = const Value.absent(),
                Value<String> businessPostalCode = const Value.absent(),
                Value<String> businessCountry = const Value.absent(),
                Value<String> skills = const Value.absent(),
                Value<String> bio = const Value.absent(),
                Value<String> clientCompany = const Value.absent(),
                Value<String> clientIndustry = const Value.absent(),
                Value<String> clientWebsite = const Value.absent(),
                Value<DateTime> memberSince = const Value.absent(),
              }) => BusinessProfilesCompanion(
                userId: userId,
                logoPath: logoPath,
                businessName: businessName,
                businessEmail: businessEmail,
                businessPhone: businessPhone,
                ownerName: ownerName,
                ownerPhotoPath: ownerPhotoPath,
                businessAddress: businessAddress,
                businessCity: businessCity,
                businessPostalCode: businessPostalCode,
                businessCountry: businessCountry,
                skills: skills,
                bio: bio,
                clientCompany: clientCompany,
                clientIndustry: clientIndustry,
                clientWebsite: clientWebsite,
                memberSince: memberSince,
              ),
          createCompanionCallback:
              ({
                Value<int> userId = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String> businessName = const Value.absent(),
                Value<String> businessEmail = const Value.absent(),
                Value<String> businessPhone = const Value.absent(),
                Value<String> ownerName = const Value.absent(),
                Value<String?> ownerPhotoPath = const Value.absent(),
                Value<String> businessAddress = const Value.absent(),
                Value<String> businessCity = const Value.absent(),
                Value<String> businessPostalCode = const Value.absent(),
                Value<String> businessCountry = const Value.absent(),
                Value<String> skills = const Value.absent(),
                Value<String> bio = const Value.absent(),
                Value<String> clientCompany = const Value.absent(),
                Value<String> clientIndustry = const Value.absent(),
                Value<String> clientWebsite = const Value.absent(),
                Value<DateTime> memberSince = const Value.absent(),
              }) => BusinessProfilesCompanion.insert(
                userId: userId,
                logoPath: logoPath,
                businessName: businessName,
                businessEmail: businessEmail,
                businessPhone: businessPhone,
                ownerName: ownerName,
                ownerPhotoPath: ownerPhotoPath,
                businessAddress: businessAddress,
                businessCity: businessCity,
                businessPostalCode: businessPostalCode,
                businessCountry: businessCountry,
                skills: skills,
                bio: bio,
                clientCompany: clientCompany,
                clientIndustry: clientIndustry,
                clientWebsite: clientWebsite,
                memberSince: memberSince,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BusinessProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$BusinessProfilesTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$BusinessProfilesTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BusinessProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BusinessProfilesTable,
      BusinessProfile,
      $$BusinessProfilesTableFilterComposer,
      $$BusinessProfilesTableOrderingComposer,
      $$BusinessProfilesTableAnnotationComposer,
      $$BusinessProfilesTableCreateCompanionBuilder,
      $$BusinessProfilesTableUpdateCompanionBuilder,
      (BusinessProfile, $$BusinessProfilesTableReferences),
      BusinessProfile,
      PrefetchHooks Function({bool userId})
    >;
typedef $$InvoiceBrandingsTableCreateCompanionBuilder =
    InvoiceBrandingsCompanion Function({
      Value<int> userId,
      Value<String> accentColor,
      Value<String> templateStyle,
      Value<bool> showLogo,
    });
typedef $$InvoiceBrandingsTableUpdateCompanionBuilder =
    InvoiceBrandingsCompanion Function({
      Value<int> userId,
      Value<String> accentColor,
      Value<String> templateStyle,
      Value<bool> showLogo,
    });

final class $$InvoiceBrandingsTableReferences
    extends
        BaseReferences<_$AppDatabase, $InvoiceBrandingsTable, InvoiceBranding> {
  $$InvoiceBrandingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('invoice_brandings__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoiceBrandingsTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceBrandingsTable> {
  $$InvoiceBrandingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateStyle => $composableBuilder(
    column: $table.templateStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showLogo => $composableBuilder(
    column: $table.showLogo,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceBrandingsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceBrandingsTable> {
  $$InvoiceBrandingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateStyle => $composableBuilder(
    column: $table.templateStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showLogo => $composableBuilder(
    column: $table.showLogo,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceBrandingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceBrandingsTable> {
  $$InvoiceBrandingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get templateStyle => $composableBuilder(
    column: $table.templateStyle,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showLogo =>
      $composableBuilder(column: $table.showLogo, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceBrandingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceBrandingsTable,
          InvoiceBranding,
          $$InvoiceBrandingsTableFilterComposer,
          $$InvoiceBrandingsTableOrderingComposer,
          $$InvoiceBrandingsTableAnnotationComposer,
          $$InvoiceBrandingsTableCreateCompanionBuilder,
          $$InvoiceBrandingsTableUpdateCompanionBuilder,
          (InvoiceBranding, $$InvoiceBrandingsTableReferences),
          InvoiceBranding,
          PrefetchHooks Function({bool userId})
        > {
  $$InvoiceBrandingsTableTableManager(
    _$AppDatabase db,
    $InvoiceBrandingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceBrandingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceBrandingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceBrandingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> userId = const Value.absent(),
                Value<String> accentColor = const Value.absent(),
                Value<String> templateStyle = const Value.absent(),
                Value<bool> showLogo = const Value.absent(),
              }) => InvoiceBrandingsCompanion(
                userId: userId,
                accentColor: accentColor,
                templateStyle: templateStyle,
                showLogo: showLogo,
              ),
          createCompanionCallback:
              ({
                Value<int> userId = const Value.absent(),
                Value<String> accentColor = const Value.absent(),
                Value<String> templateStyle = const Value.absent(),
                Value<bool> showLogo = const Value.absent(),
              }) => InvoiceBrandingsCompanion.insert(
                userId: userId,
                accentColor: accentColor,
                templateStyle: templateStyle,
                showLogo: showLogo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoiceBrandingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$InvoiceBrandingsTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$InvoiceBrandingsTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvoiceBrandingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceBrandingsTable,
      InvoiceBranding,
      $$InvoiceBrandingsTableFilterComposer,
      $$InvoiceBrandingsTableOrderingComposer,
      $$InvoiceBrandingsTableAnnotationComposer,
      $$InvoiceBrandingsTableCreateCompanionBuilder,
      $$InvoiceBrandingsTableUpdateCompanionBuilder,
      (InvoiceBranding, $$InvoiceBrandingsTableReferences),
      InvoiceBranding,
      PrefetchHooks Function({bool userId})
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> userId,
      Value<String> themeMode,
      Value<String> currency,
      Value<String> timezone,
      Value<String> subscriptionPlan,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> userId,
      Value<String> themeMode,
      Value<String> currency,
      Value<String> timezone,
      Value<String> subscriptionPlan,
    });

final class $$AppSettingsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData
        > {
  $$AppSettingsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('app_settings_table__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionPlan => $composableBuilder(
    column: $table.subscriptionPlan,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionPlan => $composableBuilder(
    column: $table.subscriptionPlan,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<String> get subscriptionPlan => $composableBuilder(
    column: $table.subscriptionPlan,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (AppSettingsTableData, $$AppSettingsTableTableReferences),
          AppSettingsTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> userId = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<String> subscriptionPlan = const Value.absent(),
              }) => AppSettingsTableCompanion(
                userId: userId,
                themeMode: themeMode,
                currency: currency,
                timezone: timezone,
                subscriptionPlan: subscriptionPlan,
              ),
          createCompanionCallback:
              ({
                Value<int> userId = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<String> subscriptionPlan = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                userId: userId,
                themeMode: themeMode,
                currency: currency,
                timezone: timezone,
                subscriptionPlan: subscriptionPlan,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AppSettingsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$AppSettingsTableTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$AppSettingsTableTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsTableData,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (AppSettingsTableData, $$AppSettingsTableTableReferences),
      AppSettingsTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required String title,
      Value<String> description,
      Value<int?> projectId,
      Value<int?> customerId,
      Value<String> priority,
      Value<String> status,
      Value<DateTime?> dueDate,
      Value<bool> completed,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<String> title,
      Value<String> description,
      Value<int?> projectId,
      Value<int?> customerId,
      Value<String> priority,
      Value<String> status,
      Value<DateTime?> dueDate,
      Value<bool> completed,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('tasks__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('tasks__project_id__projects__id');

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<int>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('tasks__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({
            bool ownerUserId,
            bool projectId,
            bool customerId,
          })
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                ownerUserId: ownerUserId,
                title: title,
                description: description,
                projectId: projectId,
                customerId: customerId,
                priority: priority,
                status: status,
                dueDate: dueDate,
                completed: completed,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required String title,
                Value<String> description = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                title: title,
                description: description,
                projectId: projectId,
                customerId: customerId,
                priority: priority,
                status: status,
                dueDate: dueDate,
                completed: completed,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TasksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({ownerUserId = false, projectId = false, customerId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ownerUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ownerUserId,
                                    referencedTable: $$TasksTableReferences
                                        ._ownerUserIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$TasksTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$TasksTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({
        bool ownerUserId,
        bool projectId,
        bool customerId,
      })
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required String title,
      required double amount,
      Value<String> currency,
      Value<String> category,
      Value<String> paymentMethod,
      Value<int?> projectId,
      Value<int?> customerId,
      Value<String> vendor,
      Value<String> notes,
      Value<DateTime> expenseDate,
      Value<DateTime> createdAt,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<String> title,
      Value<double> amount,
      Value<String> currency,
      Value<String> category,
      Value<String> paymentMethod,
      Value<int?> projectId,
      Value<int?> customerId,
      Value<String> vendor,
      Value<String> notes,
      Value<DateTime> expenseDate,
      Value<DateTime> createdAt,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('expenses__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('expenses__project_id__projects__id');

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<int>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('expenses__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendor => $composableBuilder(
    column: $table.vendor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendor => $composableBuilder(
    column: $table.vendor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vendor =>
      $composableBuilder(column: $table.vendor, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({
            bool ownerUserId,
            bool projectId,
            bool customerId,
          })
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<String> vendor = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> expenseDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                ownerUserId: ownerUserId,
                title: title,
                amount: amount,
                currency: currency,
                category: category,
                paymentMethod: paymentMethod,
                projectId: projectId,
                customerId: customerId,
                vendor: vendor,
                notes: notes,
                expenseDate: expenseDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required String title,
                required double amount,
                Value<String> currency = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<String> vendor = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> expenseDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                title: title,
                amount: amount,
                currency: currency,
                category: category,
                paymentMethod: paymentMethod,
                projectId: projectId,
                customerId: customerId,
                vendor: vendor,
                notes: notes,
                expenseDate: expenseDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({ownerUserId = false, projectId = false, customerId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ownerUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ownerUserId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._ownerUserIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({
        bool ownerUserId,
        bool projectId,
        bool customerId,
      })
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required String title,
      Value<String> content,
      Value<String> type,
      Value<int?> projectId,
      Value<int?> customerId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<String> title,
      Value<String> content,
      Value<String> type,
      Value<int?> projectId,
      Value<int?> customerId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, Note> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('notes__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('notes__project_id__projects__id');

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<int>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('notes__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, $$NotesTableReferences),
          Note,
          PrefetchHooks Function({
            bool ownerUserId,
            bool projectId,
            bool customerId,
          })
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                ownerUserId: ownerUserId,
                title: title,
                content: content,
                type: type,
                projectId: projectId,
                customerId: customerId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required String title,
                Value<String> content = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                title: title,
                content: content,
                type: type,
                projectId: projectId,
                customerId: customerId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NotesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({ownerUserId = false, projectId = false, customerId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ownerUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ownerUserId,
                                    referencedTable: $$NotesTableReferences
                                        ._ownerUserIdTable(db),
                                    referencedColumn: $$NotesTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$NotesTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$NotesTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$NotesTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$NotesTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, $$NotesTableReferences),
      Note,
      PrefetchHooks Function({
        bool ownerUserId,
        bool projectId,
        bool customerId,
      })
    >;
typedef $$MessageTemplatesTableCreateCompanionBuilder =
    MessageTemplatesCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required String name,
      Value<String> type,
      Value<String> category,
      Value<String> subject,
      Value<String> body,
      Value<DateTime> createdAt,
    });
typedef $$MessageTemplatesTableUpdateCompanionBuilder =
    MessageTemplatesCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<String> name,
      Value<String> type,
      Value<String> category,
      Value<String> subject,
      Value<String> body,
      Value<DateTime> createdAt,
    });

final class $$MessageTemplatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $MessageTemplatesTable, MessageTemplate> {
  $$MessageTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('message_templates__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MessageTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $MessageTemplatesTable> {
  $$MessageTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessageTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageTemplatesTable> {
  $$MessageTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessageTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageTemplatesTable> {
  $$MessageTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessageTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessageTemplatesTable,
          MessageTemplate,
          $$MessageTemplatesTableFilterComposer,
          $$MessageTemplatesTableOrderingComposer,
          $$MessageTemplatesTableAnnotationComposer,
          $$MessageTemplatesTableCreateCompanionBuilder,
          $$MessageTemplatesTableUpdateCompanionBuilder,
          (MessageTemplate, $$MessageTemplatesTableReferences),
          MessageTemplate,
          PrefetchHooks Function({bool ownerUserId})
        > {
  $$MessageTemplatesTableTableManager(
    _$AppDatabase db,
    $MessageTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MessageTemplatesCompanion(
                id: id,
                ownerUserId: ownerUserId,
                name: name,
                type: type,
                category: category,
                subject: subject,
                body: body,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required String name,
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MessageTemplatesCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                name: name,
                type: type,
                category: category,
                subject: subject,
                body: body,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MessageTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerUserId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ownerUserId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ownerUserId,
                                referencedTable:
                                    $$MessageTemplatesTableReferences
                                        ._ownerUserIdTable(db),
                                referencedColumn:
                                    $$MessageTemplatesTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MessageTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessageTemplatesTable,
      MessageTemplate,
      $$MessageTemplatesTableFilterComposer,
      $$MessageTemplatesTableOrderingComposer,
      $$MessageTemplatesTableAnnotationComposer,
      $$MessageTemplatesTableCreateCompanionBuilder,
      $$MessageTemplatesTableUpdateCompanionBuilder,
      (MessageTemplate, $$MessageTemplatesTableReferences),
      MessageTemplate,
      PrefetchHooks Function({bool ownerUserId})
    >;
typedef $$ContractsTableCreateCompanionBuilder =
    ContractsCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required int customerId,
      required String title,
      Value<String> status,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ContractsTableUpdateCompanionBuilder =
    ContractsCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<int> customerId,
      Value<String> title,
      Value<String> status,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ContractsTableReferences
    extends BaseReferences<_$AppDatabase, $ContractsTable, Contract> {
  $$ContractsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('contracts__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('contracts__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContractsTableFilterComposer
    extends Composer<_$AppDatabase, $ContractsTable> {
  $$ContractsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractsTable> {
  $$ContractsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractsTable> {
  $$ContractsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContractsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContractsTable,
          Contract,
          $$ContractsTableFilterComposer,
          $$ContractsTableOrderingComposer,
          $$ContractsTableAnnotationComposer,
          $$ContractsTableCreateCompanionBuilder,
          $$ContractsTableUpdateCompanionBuilder,
          (Contract, $$ContractsTableReferences),
          Contract,
          PrefetchHooks Function({bool ownerUserId, bool customerId})
        > {
  $$ContractsTableTableManager(_$AppDatabase db, $ContractsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContractsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<int> customerId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ContractsCompanion(
                id: id,
                ownerUserId: ownerUserId,
                customerId: customerId,
                title: title,
                status: status,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required int customerId,
                required String title,
                Value<String> status = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ContractsCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                customerId: customerId,
                title: title,
                status: status,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContractsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerUserId = false, customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ownerUserId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ownerUserId,
                                referencedTable: $$ContractsTableReferences
                                    ._ownerUserIdTable(db),
                                referencedColumn: $$ContractsTableReferences
                                    ._ownerUserIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (customerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.customerId,
                                referencedTable: $$ContractsTableReferences
                                    ._customerIdTable(db),
                                referencedColumn: $$ContractsTableReferences
                                    ._customerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContractsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContractsTable,
      Contract,
      $$ContractsTableFilterComposer,
      $$ContractsTableOrderingComposer,
      $$ContractsTableAnnotationComposer,
      $$ContractsTableCreateCompanionBuilder,
      $$ContractsTableUpdateCompanionBuilder,
      (Contract, $$ContractsTableReferences),
      Contract,
      PrefetchHooks Function({bool ownerUserId, bool customerId})
    >;
typedef $$AppAnalyticsTableCreateCompanionBuilder =
    AppAnalyticsCompanion Function({
      Value<int> id,
      required String eventType,
      Value<String> userEmail,
      Value<String> userName,
      Value<String> plan,
      Value<double> amount,
      Value<String> deviceId,
      Value<String> payload,
      Value<bool> synced,
      Value<DateTime> createdAt,
    });
typedef $$AppAnalyticsTableUpdateCompanionBuilder =
    AppAnalyticsCompanion Function({
      Value<int> id,
      Value<String> eventType,
      Value<String> userEmail,
      Value<String> userName,
      Value<String> plan,
      Value<double> amount,
      Value<String> deviceId,
      Value<String> payload,
      Value<bool> synced,
      Value<DateTime> createdAt,
    });

class $$AppAnalyticsTableFilterComposer
    extends Composer<_$AppDatabase, $AppAnalyticsTable> {
  $$AppAnalyticsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userEmail => $composableBuilder(
    column: $table.userEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppAnalyticsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppAnalyticsTable> {
  $$AppAnalyticsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userEmail => $composableBuilder(
    column: $table.userEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppAnalyticsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppAnalyticsTable> {
  $$AppAnalyticsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get userEmail =>
      $composableBuilder(column: $table.userEmail, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AppAnalyticsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppAnalyticsTable,
          AppAnalytic,
          $$AppAnalyticsTableFilterComposer,
          $$AppAnalyticsTableOrderingComposer,
          $$AppAnalyticsTableAnnotationComposer,
          $$AppAnalyticsTableCreateCompanionBuilder,
          $$AppAnalyticsTableUpdateCompanionBuilder,
          (
            AppAnalytic,
            BaseReferences<_$AppDatabase, $AppAnalyticsTable, AppAnalytic>,
          ),
          AppAnalytic,
          PrefetchHooks Function()
        > {
  $$AppAnalyticsTableTableManager(_$AppDatabase db, $AppAnalyticsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppAnalyticsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppAnalyticsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppAnalyticsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> userEmail = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> plan = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppAnalyticsCompanion(
                id: id,
                eventType: eventType,
                userEmail: userEmail,
                userName: userName,
                plan: plan,
                amount: amount,
                deviceId: deviceId,
                payload: payload,
                synced: synced,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventType,
                Value<String> userEmail = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> plan = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppAnalyticsCompanion.insert(
                id: id,
                eventType: eventType,
                userEmail: userEmail,
                userName: userName,
                plan: plan,
                amount: amount,
                deviceId: deviceId,
                payload: payload,
                synced: synced,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppAnalyticsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppAnalyticsTable,
      AppAnalytic,
      $$AppAnalyticsTableFilterComposer,
      $$AppAnalyticsTableOrderingComposer,
      $$AppAnalyticsTableAnnotationComposer,
      $$AppAnalyticsTableCreateCompanionBuilder,
      $$AppAnalyticsTableUpdateCompanionBuilder,
      (
        AppAnalytic,
        BaseReferences<_$AppDatabase, $AppAnalyticsTable, AppAnalytic>,
      ),
      AppAnalytic,
      PrefetchHooks Function()
    >;
typedef $$TrackingEventsTableCreateCompanionBuilder =
    TrackingEventsCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required String entityType,
      required int entityId,
      required String status,
      Value<String> note,
      Value<DateTime> createdAt,
    });
typedef $$TrackingEventsTableUpdateCompanionBuilder =
    TrackingEventsCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<String> entityType,
      Value<int> entityId,
      Value<String> status,
      Value<String> note,
      Value<DateTime> createdAt,
    });

final class $$TrackingEventsTableReferences
    extends BaseReferences<_$AppDatabase, $TrackingEventsTable, TrackingEvent> {
  $$TrackingEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('tracking_events__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackingEventsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackingEventsTable> {
  $$TrackingEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackingEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackingEventsTable> {
  $$TrackingEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackingEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackingEventsTable> {
  $$TrackingEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackingEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackingEventsTable,
          TrackingEvent,
          $$TrackingEventsTableFilterComposer,
          $$TrackingEventsTableOrderingComposer,
          $$TrackingEventsTableAnnotationComposer,
          $$TrackingEventsTableCreateCompanionBuilder,
          $$TrackingEventsTableUpdateCompanionBuilder,
          (TrackingEvent, $$TrackingEventsTableReferences),
          TrackingEvent,
          PrefetchHooks Function({bool ownerUserId})
        > {
  $$TrackingEventsTableTableManager(
    _$AppDatabase db,
    $TrackingEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackingEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackingEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackingEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TrackingEventsCompanion(
                id: id,
                ownerUserId: ownerUserId,
                entityType: entityType,
                entityId: entityId,
                status: status,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required String entityType,
                required int entityId,
                required String status,
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TrackingEventsCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                entityType: entityType,
                entityId: entityId,
                status: status,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackingEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerUserId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ownerUserId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ownerUserId,
                                referencedTable: $$TrackingEventsTableReferences
                                    ._ownerUserIdTable(db),
                                referencedColumn:
                                    $$TrackingEventsTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrackingEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackingEventsTable,
      TrackingEvent,
      $$TrackingEventsTableFilterComposer,
      $$TrackingEventsTableOrderingComposer,
      $$TrackingEventsTableAnnotationComposer,
      $$TrackingEventsTableCreateCompanionBuilder,
      $$TrackingEventsTableUpdateCompanionBuilder,
      (TrackingEvent, $$TrackingEventsTableReferences),
      TrackingEvent,
      PrefetchHooks Function({bool ownerUserId})
    >;
typedef $$ProjectTimeEntriesTableCreateCompanionBuilder =
    ProjectTimeEntriesCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required int projectId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> durationSeconds,
      Value<String> note,
    });
typedef $$ProjectTimeEntriesTableUpdateCompanionBuilder =
    ProjectTimeEntriesCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<int> projectId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> durationSeconds,
      Value<String> note,
    });

final class $$ProjectTimeEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProjectTimeEntriesTable,
          ProjectTimeEntry
        > {
  $$ProjectTimeEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('project_time_entries__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('project_time_entries__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectTimeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectTimeEntriesTable> {
  $$ProjectTimeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectTimeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectTimeEntriesTable> {
  $$ProjectTimeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectTimeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectTimeEntriesTable> {
  $$ProjectTimeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectTimeEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectTimeEntriesTable,
          ProjectTimeEntry,
          $$ProjectTimeEntriesTableFilterComposer,
          $$ProjectTimeEntriesTableOrderingComposer,
          $$ProjectTimeEntriesTableAnnotationComposer,
          $$ProjectTimeEntriesTableCreateCompanionBuilder,
          $$ProjectTimeEntriesTableUpdateCompanionBuilder,
          (ProjectTimeEntry, $$ProjectTimeEntriesTableReferences),
          ProjectTimeEntry,
          PrefetchHooks Function({bool ownerUserId, bool projectId})
        > {
  $$ProjectTimeEntriesTableTableManager(
    _$AppDatabase db,
    $ProjectTimeEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectTimeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectTimeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectTimeEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => ProjectTimeEntriesCompanion(
                id: id,
                ownerUserId: ownerUserId,
                projectId: projectId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required int projectId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => ProjectTimeEntriesCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                projectId: projectId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectTimeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerUserId = false, projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ownerUserId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ownerUserId,
                                referencedTable:
                                    $$ProjectTimeEntriesTableReferences
                                        ._ownerUserIdTable(db),
                                referencedColumn:
                                    $$ProjectTimeEntriesTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable:
                                    $$ProjectTimeEntriesTableReferences
                                        ._projectIdTable(db),
                                referencedColumn:
                                    $$ProjectTimeEntriesTableReferences
                                        ._projectIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProjectTimeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectTimeEntriesTable,
      ProjectTimeEntry,
      $$ProjectTimeEntriesTableFilterComposer,
      $$ProjectTimeEntriesTableOrderingComposer,
      $$ProjectTimeEntriesTableAnnotationComposer,
      $$ProjectTimeEntriesTableCreateCompanionBuilder,
      $$ProjectTimeEntriesTableUpdateCompanionBuilder,
      (ProjectTimeEntry, $$ProjectTimeEntriesTableReferences),
      ProjectTimeEntry,
      PrefetchHooks Function({bool ownerUserId, bool projectId})
    >;
typedef $$ProjectClientLinksTableCreateCompanionBuilder =
    ProjectClientLinksCompanion Function({
      Value<int> id,
      required int projectId,
      required int freelancerUserId,
      required String clientEmail,
      Value<int?> clientUserId,
      Value<DateTime> createdAt,
    });
typedef $$ProjectClientLinksTableUpdateCompanionBuilder =
    ProjectClientLinksCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<int> freelancerUserId,
      Value<String> clientEmail,
      Value<int?> clientUserId,
      Value<DateTime> createdAt,
    });

final class $$ProjectClientLinksTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProjectClientLinksTable,
          ProjectClientLink
        > {
  $$ProjectClientLinksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('project_client_links__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _freelancerUserIdTable(_$AppDatabase db) => db.users
      .createAlias('project_client_links__freelancer_user_id__users__id');

  $$UsersTableProcessedTableManager get freelancerUserId {
    final $_column = $_itemColumn<int>('freelancer_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_freelancerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _clientUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('project_client_links__client_user_id__users__id');

  $$UsersTableProcessedTableManager? get clientUserId {
    final $_column = $_itemColumn<int>('client_user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectClientLinksTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectClientLinksTable> {
  $$ProjectClientLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientEmail => $composableBuilder(
    column: $table.clientEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get freelancerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.freelancerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get clientUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectClientLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectClientLinksTable> {
  $$ProjectClientLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientEmail => $composableBuilder(
    column: $table.clientEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get freelancerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.freelancerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get clientUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectClientLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectClientLinksTable> {
  $$ProjectClientLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientEmail => $composableBuilder(
    column: $table.clientEmail,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get freelancerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.freelancerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get clientUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectClientLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectClientLinksTable,
          ProjectClientLink,
          $$ProjectClientLinksTableFilterComposer,
          $$ProjectClientLinksTableOrderingComposer,
          $$ProjectClientLinksTableAnnotationComposer,
          $$ProjectClientLinksTableCreateCompanionBuilder,
          $$ProjectClientLinksTableUpdateCompanionBuilder,
          (ProjectClientLink, $$ProjectClientLinksTableReferences),
          ProjectClientLink,
          PrefetchHooks Function({
            bool projectId,
            bool freelancerUserId,
            bool clientUserId,
          })
        > {
  $$ProjectClientLinksTableTableManager(
    _$AppDatabase db,
    $ProjectClientLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectClientLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectClientLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectClientLinksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<int> freelancerUserId = const Value.absent(),
                Value<String> clientEmail = const Value.absent(),
                Value<int?> clientUserId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProjectClientLinksCompanion(
                id: id,
                projectId: projectId,
                freelancerUserId: freelancerUserId,
                clientEmail: clientEmail,
                clientUserId: clientUserId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required int freelancerUserId,
                required String clientEmail,
                Value<int?> clientUserId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProjectClientLinksCompanion.insert(
                id: id,
                projectId: projectId,
                freelancerUserId: freelancerUserId,
                clientEmail: clientEmail,
                clientUserId: clientUserId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectClientLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                projectId = false,
                freelancerUserId = false,
                clientUserId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable:
                                        $$ProjectClientLinksTableReferences
                                            ._projectIdTable(db),
                                    referencedColumn:
                                        $$ProjectClientLinksTableReferences
                                            ._projectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (freelancerUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.freelancerUserId,
                                    referencedTable:
                                        $$ProjectClientLinksTableReferences
                                            ._freelancerUserIdTable(db),
                                    referencedColumn:
                                        $$ProjectClientLinksTableReferences
                                            ._freelancerUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (clientUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clientUserId,
                                    referencedTable:
                                        $$ProjectClientLinksTableReferences
                                            ._clientUserIdTable(db),
                                    referencedColumn:
                                        $$ProjectClientLinksTableReferences
                                            ._clientUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectClientLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectClientLinksTable,
      ProjectClientLink,
      $$ProjectClientLinksTableFilterComposer,
      $$ProjectClientLinksTableOrderingComposer,
      $$ProjectClientLinksTableAnnotationComposer,
      $$ProjectClientLinksTableCreateCompanionBuilder,
      $$ProjectClientLinksTableUpdateCompanionBuilder,
      (ProjectClientLink, $$ProjectClientLinksTableReferences),
      ProjectClientLink,
      PrefetchHooks Function({
        bool projectId,
        bool freelancerUserId,
        bool clientUserId,
      })
    >;
typedef $$ClientMessagesTableCreateCompanionBuilder =
    ClientMessagesCompanion Function({
      Value<int> id,
      required int fromUserId,
      required int toUserId,
      Value<int?> projectId,
      Value<String> subject,
      required String body,
      Value<bool> isRead,
      Value<DateTime> createdAt,
    });
typedef $$ClientMessagesTableUpdateCompanionBuilder =
    ClientMessagesCompanion Function({
      Value<int> id,
      Value<int> fromUserId,
      Value<int> toUserId,
      Value<int?> projectId,
      Value<String> subject,
      Value<String> body,
      Value<bool> isRead,
      Value<DateTime> createdAt,
    });

final class $$ClientMessagesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientMessagesTable, ClientMessage> {
  $$ClientMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _fromUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('client_messages__from_user_id__users__id');

  $$UsersTableProcessedTableManager get fromUserId {
    final $_column = $_itemColumn<int>('from_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _toUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('client_messages__to_user_id__users__id');

  $$UsersTableProcessedTableManager get toUserId {
    final $_column = $_itemColumn<int>('to_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('client_messages__project_id__projects__id');

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<int>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClientMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientMessagesTable> {
  $$ClientMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get fromUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get toUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientMessagesTable> {
  $$ClientMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get fromUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get toUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientMessagesTable> {
  $$ClientMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get fromUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get toUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientMessagesTable,
          ClientMessage,
          $$ClientMessagesTableFilterComposer,
          $$ClientMessagesTableOrderingComposer,
          $$ClientMessagesTableAnnotationComposer,
          $$ClientMessagesTableCreateCompanionBuilder,
          $$ClientMessagesTableUpdateCompanionBuilder,
          (ClientMessage, $$ClientMessagesTableReferences),
          ClientMessage,
          PrefetchHooks Function({
            bool fromUserId,
            bool toUserId,
            bool projectId,
          })
        > {
  $$ClientMessagesTableTableManager(
    _$AppDatabase db,
    $ClientMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> fromUserId = const Value.absent(),
                Value<int> toUserId = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ClientMessagesCompanion(
                id: id,
                fromUserId: fromUserId,
                toUserId: toUserId,
                projectId: projectId,
                subject: subject,
                body: body,
                isRead: isRead,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fromUserId,
                required int toUserId,
                Value<int?> projectId = const Value.absent(),
                Value<String> subject = const Value.absent(),
                required String body,
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ClientMessagesCompanion.insert(
                id: id,
                fromUserId: fromUserId,
                toUserId: toUserId,
                projectId: projectId,
                subject: subject,
                body: body,
                isRead: isRead,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({fromUserId = false, toUserId = false, projectId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (fromUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fromUserId,
                                    referencedTable:
                                        $$ClientMessagesTableReferences
                                            ._fromUserIdTable(db),
                                    referencedColumn:
                                        $$ClientMessagesTableReferences
                                            ._fromUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (toUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.toUserId,
                                    referencedTable:
                                        $$ClientMessagesTableReferences
                                            ._toUserIdTable(db),
                                    referencedColumn:
                                        $$ClientMessagesTableReferences
                                            ._toUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable:
                                        $$ClientMessagesTableReferences
                                            ._projectIdTable(db),
                                    referencedColumn:
                                        $$ClientMessagesTableReferences
                                            ._projectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ClientMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientMessagesTable,
      ClientMessage,
      $$ClientMessagesTableFilterComposer,
      $$ClientMessagesTableOrderingComposer,
      $$ClientMessagesTableAnnotationComposer,
      $$ClientMessagesTableCreateCompanionBuilder,
      $$ClientMessagesTableUpdateCompanionBuilder,
      (ClientMessage, $$ClientMessagesTableReferences),
      ClientMessage,
      PrefetchHooks Function({bool fromUserId, bool toUserId, bool projectId})
    >;
typedef $$TeamMembersTableCreateCompanionBuilder =
    TeamMembersCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required String name,
      required String email,
      Value<String> role,
      Value<DateTime> createdAt,
    });
typedef $$TeamMembersTableUpdateCompanionBuilder =
    TeamMembersCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<String> name,
      Value<String> email,
      Value<String> role,
      Value<DateTime> createdAt,
    });

final class $$TeamMembersTableReferences
    extends BaseReferences<_$AppDatabase, $TeamMembersTable, TeamMember> {
  $$TeamMembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('team_members__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TeamMembersTableFilterComposer
    extends Composer<_$AppDatabase, $TeamMembersTable> {
  $$TeamMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamMembersTable> {
  $$TeamMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamMembersTable> {
  $$TeamMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamMembersTable,
          TeamMember,
          $$TeamMembersTableFilterComposer,
          $$TeamMembersTableOrderingComposer,
          $$TeamMembersTableAnnotationComposer,
          $$TeamMembersTableCreateCompanionBuilder,
          $$TeamMembersTableUpdateCompanionBuilder,
          (TeamMember, $$TeamMembersTableReferences),
          TeamMember,
          PrefetchHooks Function({bool ownerUserId})
        > {
  $$TeamMembersTableTableManager(_$AppDatabase db, $TeamMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TeamMembersCompanion(
                id: id,
                ownerUserId: ownerUserId,
                name: name,
                email: email,
                role: role,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required String name,
                required String email,
                Value<String> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TeamMembersCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                name: name,
                email: email,
                role: role,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TeamMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerUserId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ownerUserId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ownerUserId,
                                referencedTable: $$TeamMembersTableReferences
                                    ._ownerUserIdTable(db),
                                referencedColumn: $$TeamMembersTableReferences
                                    ._ownerUserIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TeamMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamMembersTable,
      TeamMember,
      $$TeamMembersTableFilterComposer,
      $$TeamMembersTableOrderingComposer,
      $$TeamMembersTableAnnotationComposer,
      $$TeamMembersTableCreateCompanionBuilder,
      $$TeamMembersTableUpdateCompanionBuilder,
      (TeamMember, $$TeamMembersTableReferences),
      TeamMember,
      PrefetchHooks Function({bool ownerUserId})
    >;
typedef $$FileAttachmentsTableCreateCompanionBuilder =
    FileAttachmentsCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required String entityType,
      required int entityId,
      required String fileName,
      required String localPath,
      Value<String> mimeType,
      Value<int> sizeBytes,
      Value<DateTime> createdAt,
    });
typedef $$FileAttachmentsTableUpdateCompanionBuilder =
    FileAttachmentsCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<String> entityType,
      Value<int> entityId,
      Value<String> fileName,
      Value<String> localPath,
      Value<String> mimeType,
      Value<int> sizeBytes,
      Value<DateTime> createdAt,
    });

final class $$FileAttachmentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $FileAttachmentsTable, FileAttachment> {
  $$FileAttachmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('file_attachments__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FileAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $FileAttachmentsTable> {
  $$FileAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FileAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $FileAttachmentsTable> {
  $$FileAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FileAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FileAttachmentsTable> {
  $$FileAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FileAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FileAttachmentsTable,
          FileAttachment,
          $$FileAttachmentsTableFilterComposer,
          $$FileAttachmentsTableOrderingComposer,
          $$FileAttachmentsTableAnnotationComposer,
          $$FileAttachmentsTableCreateCompanionBuilder,
          $$FileAttachmentsTableUpdateCompanionBuilder,
          (FileAttachment, $$FileAttachmentsTableReferences),
          FileAttachment,
          PrefetchHooks Function({bool ownerUserId})
        > {
  $$FileAttachmentsTableTableManager(
    _$AppDatabase db,
    $FileAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FileAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FileAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FileAttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FileAttachmentsCompanion(
                id: id,
                ownerUserId: ownerUserId,
                entityType: entityType,
                entityId: entityId,
                fileName: fileName,
                localPath: localPath,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required String entityType,
                required int entityId,
                required String fileName,
                required String localPath,
                Value<String> mimeType = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FileAttachmentsCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                entityType: entityType,
                entityId: entityId,
                fileName: fileName,
                localPath: localPath,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FileAttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerUserId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ownerUserId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ownerUserId,
                                referencedTable:
                                    $$FileAttachmentsTableReferences
                                        ._ownerUserIdTable(db),
                                referencedColumn:
                                    $$FileAttachmentsTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FileAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FileAttachmentsTable,
      FileAttachment,
      $$FileAttachmentsTableFilterComposer,
      $$FileAttachmentsTableOrderingComposer,
      $$FileAttachmentsTableAnnotationComposer,
      $$FileAttachmentsTableCreateCompanionBuilder,
      $$FileAttachmentsTableUpdateCompanionBuilder,
      (FileAttachment, $$FileAttachmentsTableReferences),
      FileAttachment,
      PrefetchHooks Function({bool ownerUserId})
    >;
typedef $$CalendarRemindersTableCreateCompanionBuilder =
    CalendarRemindersCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required String title,
      Value<String> notes,
      required DateTime scheduledAt,
      Value<String> kind,
      Value<int?> linkedEntityId,
      Value<String> linkedEntityType,
      Value<bool> completed,
      Value<DateTime> createdAt,
    });
typedef $$CalendarRemindersTableUpdateCompanionBuilder =
    CalendarRemindersCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<String> title,
      Value<String> notes,
      Value<DateTime> scheduledAt,
      Value<String> kind,
      Value<int?> linkedEntityId,
      Value<String> linkedEntityType,
      Value<bool> completed,
      Value<DateTime> createdAt,
    });

final class $$CalendarRemindersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CalendarRemindersTable,
          CalendarReminder
        > {
  $$CalendarRemindersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('calendar_reminders__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CalendarRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarRemindersTable> {
  $$CalendarRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get linkedEntityId => $composableBuilder(
    column: $table.linkedEntityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedEntityType => $composableBuilder(
    column: $table.linkedEntityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarRemindersTable> {
  $$CalendarRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get linkedEntityId => $composableBuilder(
    column: $table.linkedEntityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedEntityType => $composableBuilder(
    column: $table.linkedEntityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarRemindersTable> {
  $$CalendarRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get linkedEntityId => $composableBuilder(
    column: $table.linkedEntityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedEntityType => $composableBuilder(
    column: $table.linkedEntityType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarRemindersTable,
          CalendarReminder,
          $$CalendarRemindersTableFilterComposer,
          $$CalendarRemindersTableOrderingComposer,
          $$CalendarRemindersTableAnnotationComposer,
          $$CalendarRemindersTableCreateCompanionBuilder,
          $$CalendarRemindersTableUpdateCompanionBuilder,
          (CalendarReminder, $$CalendarRemindersTableReferences),
          CalendarReminder,
          PrefetchHooks Function({bool ownerUserId})
        > {
  $$CalendarRemindersTableTableManager(
    _$AppDatabase db,
    $CalendarRemindersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarRemindersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> linkedEntityId = const Value.absent(),
                Value<String> linkedEntityType = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CalendarRemindersCompanion(
                id: id,
                ownerUserId: ownerUserId,
                title: title,
                notes: notes,
                scheduledAt: scheduledAt,
                kind: kind,
                linkedEntityId: linkedEntityId,
                linkedEntityType: linkedEntityType,
                completed: completed,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required String title,
                Value<String> notes = const Value.absent(),
                required DateTime scheduledAt,
                Value<String> kind = const Value.absent(),
                Value<int?> linkedEntityId = const Value.absent(),
                Value<String> linkedEntityType = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CalendarRemindersCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                title: title,
                notes: notes,
                scheduledAt: scheduledAt,
                kind: kind,
                linkedEntityId: linkedEntityId,
                linkedEntityType: linkedEntityType,
                completed: completed,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CalendarRemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerUserId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ownerUserId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ownerUserId,
                                referencedTable:
                                    $$CalendarRemindersTableReferences
                                        ._ownerUserIdTable(db),
                                referencedColumn:
                                    $$CalendarRemindersTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CalendarRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarRemindersTable,
      CalendarReminder,
      $$CalendarRemindersTableFilterComposer,
      $$CalendarRemindersTableOrderingComposer,
      $$CalendarRemindersTableAnnotationComposer,
      $$CalendarRemindersTableCreateCompanionBuilder,
      $$CalendarRemindersTableUpdateCompanionBuilder,
      (CalendarReminder, $$CalendarRemindersTableReferences),
      CalendarReminder,
      PrefetchHooks Function({bool ownerUserId})
    >;
typedef $$ProjectMilestonesTableCreateCompanionBuilder =
    ProjectMilestonesCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required int projectId,
      required String title,
      Value<String> description,
      Value<double> amount,
      Value<String> currency,
      Value<String> status,
      Value<int> sortOrder,
      Value<DateTime?> dueDate,
      Value<int?> invoiceId,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ProjectMilestonesTableUpdateCompanionBuilder =
    ProjectMilestonesCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<int> projectId,
      Value<String> title,
      Value<String> description,
      Value<double> amount,
      Value<String> currency,
      Value<String> status,
      Value<int> sortOrder,
      Value<DateTime?> dueDate,
      Value<int?> invoiceId,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ProjectMilestonesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProjectMilestonesTable,
          ProjectMilestone
        > {
  $$ProjectMilestonesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('project_milestones__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('project_milestones__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('project_milestones__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager? get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id');
    if ($_column == null) return null;
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectMilestonesTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectMilestonesTable> {
  $$ProjectMilestonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectMilestonesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectMilestonesTable> {
  $$ProjectMilestonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectMilestonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectMilestonesTable> {
  $$ProjectMilestonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectMilestonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectMilestonesTable,
          ProjectMilestone,
          $$ProjectMilestonesTableFilterComposer,
          $$ProjectMilestonesTableOrderingComposer,
          $$ProjectMilestonesTableAnnotationComposer,
          $$ProjectMilestonesTableCreateCompanionBuilder,
          $$ProjectMilestonesTableUpdateCompanionBuilder,
          (ProjectMilestone, $$ProjectMilestonesTableReferences),
          ProjectMilestone,
          PrefetchHooks Function({
            bool ownerUserId,
            bool projectId,
            bool invoiceId,
          })
        > {
  $$ProjectMilestonesTableTableManager(
    _$AppDatabase db,
    $ProjectMilestonesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectMilestonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectMilestonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectMilestonesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int?> invoiceId = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProjectMilestonesCompanion(
                id: id,
                ownerUserId: ownerUserId,
                projectId: projectId,
                title: title,
                description: description,
                amount: amount,
                currency: currency,
                status: status,
                sortOrder: sortOrder,
                dueDate: dueDate,
                invoiceId: invoiceId,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required int projectId,
                required String title,
                Value<String> description = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int?> invoiceId = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProjectMilestonesCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                projectId: projectId,
                title: title,
                description: description,
                amount: amount,
                currency: currency,
                status: status,
                sortOrder: sortOrder,
                dueDate: dueDate,
                invoiceId: invoiceId,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectMilestonesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({ownerUserId = false, projectId = false, invoiceId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ownerUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ownerUserId,
                                    referencedTable:
                                        $$ProjectMilestonesTableReferences
                                            ._ownerUserIdTable(db),
                                    referencedColumn:
                                        $$ProjectMilestonesTableReferences
                                            ._ownerUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable:
                                        $$ProjectMilestonesTableReferences
                                            ._projectIdTable(db),
                                    referencedColumn:
                                        $$ProjectMilestonesTableReferences
                                            ._projectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (invoiceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.invoiceId,
                                    referencedTable:
                                        $$ProjectMilestonesTableReferences
                                            ._invoiceIdTable(db),
                                    referencedColumn:
                                        $$ProjectMilestonesTableReferences
                                            ._invoiceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectMilestonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectMilestonesTable,
      ProjectMilestone,
      $$ProjectMilestonesTableFilterComposer,
      $$ProjectMilestonesTableOrderingComposer,
      $$ProjectMilestonesTableAnnotationComposer,
      $$ProjectMilestonesTableCreateCompanionBuilder,
      $$ProjectMilestonesTableUpdateCompanionBuilder,
      (ProjectMilestone, $$ProjectMilestonesTableReferences),
      ProjectMilestone,
      PrefetchHooks Function({bool ownerUserId, bool projectId, bool invoiceId})
    >;
typedef $$ProjectReviewsTableCreateCompanionBuilder =
    ProjectReviewsCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required int projectId,
      Value<int?> customerId,
      Value<String> clientEmail,
      Value<int> rating,
      Value<String> comment,
      Value<bool> fromClient,
      Value<DateTime> createdAt,
    });
typedef $$ProjectReviewsTableUpdateCompanionBuilder =
    ProjectReviewsCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<int> projectId,
      Value<int?> customerId,
      Value<String> clientEmail,
      Value<int> rating,
      Value<String> comment,
      Value<bool> fromClient,
      Value<DateTime> createdAt,
    });

final class $$ProjectReviewsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectReviewsTable, ProjectReview> {
  $$ProjectReviewsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('project_reviews__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('project_reviews__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('project_reviews__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectReviewsTable> {
  $$ProjectReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientEmail => $composableBuilder(
    column: $table.clientEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fromClient => $composableBuilder(
    column: $table.fromClient,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectReviewsTable> {
  $$ProjectReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientEmail => $composableBuilder(
    column: $table.clientEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fromClient => $composableBuilder(
    column: $table.fromClient,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectReviewsTable> {
  $$ProjectReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientEmail => $composableBuilder(
    column: $table.clientEmail,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<bool> get fromClient => $composableBuilder(
    column: $table.fromClient,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectReviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectReviewsTable,
          ProjectReview,
          $$ProjectReviewsTableFilterComposer,
          $$ProjectReviewsTableOrderingComposer,
          $$ProjectReviewsTableAnnotationComposer,
          $$ProjectReviewsTableCreateCompanionBuilder,
          $$ProjectReviewsTableUpdateCompanionBuilder,
          (ProjectReview, $$ProjectReviewsTableReferences),
          ProjectReview,
          PrefetchHooks Function({
            bool ownerUserId,
            bool projectId,
            bool customerId,
          })
        > {
  $$ProjectReviewsTableTableManager(
    _$AppDatabase db,
    $ProjectReviewsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<String> clientEmail = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<String> comment = const Value.absent(),
                Value<bool> fromClient = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProjectReviewsCompanion(
                id: id,
                ownerUserId: ownerUserId,
                projectId: projectId,
                customerId: customerId,
                clientEmail: clientEmail,
                rating: rating,
                comment: comment,
                fromClient: fromClient,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required int projectId,
                Value<int?> customerId = const Value.absent(),
                Value<String> clientEmail = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<String> comment = const Value.absent(),
                Value<bool> fromClient = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProjectReviewsCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                projectId: projectId,
                customerId: customerId,
                clientEmail: clientEmail,
                rating: rating,
                comment: comment,
                fromClient: fromClient,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectReviewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({ownerUserId = false, projectId = false, customerId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ownerUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ownerUserId,
                                    referencedTable:
                                        $$ProjectReviewsTableReferences
                                            ._ownerUserIdTable(db),
                                    referencedColumn:
                                        $$ProjectReviewsTableReferences
                                            ._ownerUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable:
                                        $$ProjectReviewsTableReferences
                                            ._projectIdTable(db),
                                    referencedColumn:
                                        $$ProjectReviewsTableReferences
                                            ._projectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable:
                                        $$ProjectReviewsTableReferences
                                            ._customerIdTable(db),
                                    referencedColumn:
                                        $$ProjectReviewsTableReferences
                                            ._customerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectReviewsTable,
      ProjectReview,
      $$ProjectReviewsTableFilterComposer,
      $$ProjectReviewsTableOrderingComposer,
      $$ProjectReviewsTableAnnotationComposer,
      $$ProjectReviewsTableCreateCompanionBuilder,
      $$ProjectReviewsTableUpdateCompanionBuilder,
      (ProjectReview, $$ProjectReviewsTableReferences),
      ProjectReview,
      PrefetchHooks Function({
        bool ownerUserId,
        bool projectId,
        bool customerId,
      })
    >;
typedef $$InvoiceDisputesTableCreateCompanionBuilder =
    InvoiceDisputesCompanion Function({
      Value<int> id,
      required int ownerUserId,
      required int invoiceId,
      required String reason,
      Value<String> status,
      Value<String> resolution,
      Value<String> raisedByEmail,
      Value<DateTime> createdAt,
      Value<DateTime?> resolvedAt,
    });
typedef $$InvoiceDisputesTableUpdateCompanionBuilder =
    InvoiceDisputesCompanion Function({
      Value<int> id,
      Value<int> ownerUserId,
      Value<int> invoiceId,
      Value<String> reason,
      Value<String> status,
      Value<String> resolution,
      Value<String> raisedByEmail,
      Value<DateTime> createdAt,
      Value<DateTime?> resolvedAt,
    });

final class $$InvoiceDisputesTableReferences
    extends
        BaseReferences<_$AppDatabase, $InvoiceDisputesTable, InvoiceDispute> {
  $$InvoiceDisputesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _ownerUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('invoice_disputes__owner_user_id__users__id');

  $$UsersTableProcessedTableManager get ownerUserId {
    final $_column = $_itemColumn<int>('owner_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('invoice_disputes__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoiceDisputesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceDisputesTable> {
  $$InvoiceDisputesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get raisedByEmail => $composableBuilder(
    column: $table.raisedByEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceDisputesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceDisputesTable> {
  $$InvoiceDisputesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get raisedByEmail => $composableBuilder(
    column: $table.raisedByEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceDisputesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceDisputesTable> {
  $$InvoiceDisputesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => column,
  );

  GeneratedColumn<String> get raisedByEmail => $composableBuilder(
    column: $table.raisedByEmail,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get ownerUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceDisputesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceDisputesTable,
          InvoiceDispute,
          $$InvoiceDisputesTableFilterComposer,
          $$InvoiceDisputesTableOrderingComposer,
          $$InvoiceDisputesTableAnnotationComposer,
          $$InvoiceDisputesTableCreateCompanionBuilder,
          $$InvoiceDisputesTableUpdateCompanionBuilder,
          (InvoiceDispute, $$InvoiceDisputesTableReferences),
          InvoiceDispute,
          PrefetchHooks Function({bool ownerUserId, bool invoiceId})
        > {
  $$InvoiceDisputesTableTableManager(
    _$AppDatabase db,
    $InvoiceDisputesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceDisputesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceDisputesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceDisputesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUserId = const Value.absent(),
                Value<int> invoiceId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> resolution = const Value.absent(),
                Value<String> raisedByEmail = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
              }) => InvoiceDisputesCompanion(
                id: id,
                ownerUserId: ownerUserId,
                invoiceId: invoiceId,
                reason: reason,
                status: status,
                resolution: resolution,
                raisedByEmail: raisedByEmail,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUserId,
                required int invoiceId,
                required String reason,
                Value<String> status = const Value.absent(),
                Value<String> resolution = const Value.absent(),
                Value<String> raisedByEmail = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
              }) => InvoiceDisputesCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                invoiceId: invoiceId,
                reason: reason,
                status: status,
                resolution: resolution,
                raisedByEmail: raisedByEmail,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoiceDisputesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerUserId = false, invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ownerUserId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ownerUserId,
                                referencedTable:
                                    $$InvoiceDisputesTableReferences
                                        ._ownerUserIdTable(db),
                                referencedColumn:
                                    $$InvoiceDisputesTableReferences
                                        ._ownerUserIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable:
                                    $$InvoiceDisputesTableReferences
                                        ._invoiceIdTable(db),
                                referencedColumn:
                                    $$InvoiceDisputesTableReferences
                                        ._invoiceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvoiceDisputesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceDisputesTable,
      InvoiceDispute,
      $$InvoiceDisputesTableFilterComposer,
      $$InvoiceDisputesTableOrderingComposer,
      $$InvoiceDisputesTableAnnotationComposer,
      $$InvoiceDisputesTableCreateCompanionBuilder,
      $$InvoiceDisputesTableUpdateCompanionBuilder,
      (InvoiceDispute, $$InvoiceDisputesTableReferences),
      InvoiceDispute,
      PrefetchHooks Function({bool ownerUserId, bool invoiceId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$BusinessProfilesTableTableManager get businessProfiles =>
      $$BusinessProfilesTableTableManager(_db, _db.businessProfiles);
  $$InvoiceBrandingsTableTableManager get invoiceBrandings =>
      $$InvoiceBrandingsTableTableManager(_db, _db.invoiceBrandings);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$MessageTemplatesTableTableManager get messageTemplates =>
      $$MessageTemplatesTableTableManager(_db, _db.messageTemplates);
  $$ContractsTableTableManager get contracts =>
      $$ContractsTableTableManager(_db, _db.contracts);
  $$AppAnalyticsTableTableManager get appAnalytics =>
      $$AppAnalyticsTableTableManager(_db, _db.appAnalytics);
  $$TrackingEventsTableTableManager get trackingEvents =>
      $$TrackingEventsTableTableManager(_db, _db.trackingEvents);
  $$ProjectTimeEntriesTableTableManager get projectTimeEntries =>
      $$ProjectTimeEntriesTableTableManager(_db, _db.projectTimeEntries);
  $$ProjectClientLinksTableTableManager get projectClientLinks =>
      $$ProjectClientLinksTableTableManager(_db, _db.projectClientLinks);
  $$ClientMessagesTableTableManager get clientMessages =>
      $$ClientMessagesTableTableManager(_db, _db.clientMessages);
  $$TeamMembersTableTableManager get teamMembers =>
      $$TeamMembersTableTableManager(_db, _db.teamMembers);
  $$FileAttachmentsTableTableManager get fileAttachments =>
      $$FileAttachmentsTableTableManager(_db, _db.fileAttachments);
  $$CalendarRemindersTableTableManager get calendarReminders =>
      $$CalendarRemindersTableTableManager(_db, _db.calendarReminders);
  $$ProjectMilestonesTableTableManager get projectMilestones =>
      $$ProjectMilestonesTableTableManager(_db, _db.projectMilestones);
  $$ProjectReviewsTableTableManager get projectReviews =>
      $$ProjectReviewsTableTableManager(_db, _db.projectReviews);
  $$InvoiceDisputesTableTableManager get invoiceDisputes =>
      $$InvoiceDisputesTableTableManager(_db, _db.invoiceDisputes);
}
