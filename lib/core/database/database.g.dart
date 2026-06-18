// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ImportBatchesTable extends ImportBatches
    with TableInfo<$ImportBatchesTable, ImportBatchEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileTypeMeta =
      const VerificationMeta('fileType');
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
      'file_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> importedAt =
      GeneratedColumn<int>('imported_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($ImportBatchesTable.$converterimportedAtn);
  static const VerificationMeta _parserVersionMeta =
      const VerificationMeta('parserVersion');
  @override
  late final GeneratedColumn<String> parserVersion = GeneratedColumn<String>(
      'parser_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalRowsMeta =
      const VerificationMeta('totalRows');
  @override
  late final GeneratedColumn<int> totalRows = GeneratedColumn<int>(
      'total_rows', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _importedCountMeta =
      const VerificationMeta('importedCount');
  @override
  late final GeneratedColumn<int> importedCount = GeneratedColumn<int>(
      'imported_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _duplicateCountMeta =
      const VerificationMeta('duplicateCount');
  @override
  late final GeneratedColumn<int> duplicateCount = GeneratedColumn<int>(
      'duplicate_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _failedCountMeta =
      const VerificationMeta('failedCount');
  @override
  late final GeneratedColumn<int> failedCount = GeneratedColumn<int>(
      'failed_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reviewCountMeta =
      const VerificationMeta('reviewCount');
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
      'review_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fileName,
        fileType,
        importedAt,
        parserVersion,
        status,
        totalRows,
        importedCount,
        duplicateCount,
        failedCount,
        reviewCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_batches';
  @override
  VerificationContext validateIntegrity(Insertable<ImportBatchEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(_fileTypeMeta,
          fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta));
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('parser_version')) {
      context.handle(
          _parserVersionMeta,
          parserVersion.isAcceptableOrUnknown(
              data['parser_version']!, _parserVersionMeta));
    } else if (isInserting) {
      context.missing(_parserVersionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('total_rows')) {
      context.handle(_totalRowsMeta,
          totalRows.isAcceptableOrUnknown(data['total_rows']!, _totalRowsMeta));
    }
    if (data.containsKey('imported_count')) {
      context.handle(
          _importedCountMeta,
          importedCount.isAcceptableOrUnknown(
              data['imported_count']!, _importedCountMeta));
    }
    if (data.containsKey('duplicate_count')) {
      context.handle(
          _duplicateCountMeta,
          duplicateCount.isAcceptableOrUnknown(
              data['duplicate_count']!, _duplicateCountMeta));
    }
    if (data.containsKey('failed_count')) {
      context.handle(
          _failedCountMeta,
          failedCount.isAcceptableOrUnknown(
              data['failed_count']!, _failedCountMeta));
    }
    if (data.containsKey('review_count')) {
      context.handle(
          _reviewCountMeta,
          reviewCount.isAcceptableOrUnknown(
              data['review_count']!, _reviewCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportBatchEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportBatchEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      fileType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_type'])!,
      importedAt: $ImportBatchesTable.$converterimportedAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}imported_at'])),
      parserVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parser_version'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      totalRows: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_rows'])!,
      importedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}imported_count'])!,
      duplicateCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duplicate_count'])!,
      failedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}failed_count'])!,
      reviewCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}review_count'])!,
    );
  }

  @override
  $ImportBatchesTable createAlias(String alias) {
    return $ImportBatchesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterimportedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterimportedAtn =
      NullAwareTypeConverter.wrap($converterimportedAt);
}

class ImportBatchEntry extends DataClass
    implements Insertable<ImportBatchEntry> {
  final String id;
  final String fileName;
  final String fileType;
  final DateTime? importedAt;
  final String parserVersion;
  final String status;
  final int totalRows;
  final int importedCount;
  final int duplicateCount;
  final int failedCount;
  final int reviewCount;
  const ImportBatchEntry(
      {required this.id,
      required this.fileName,
      required this.fileType,
      this.importedAt,
      required this.parserVersion,
      required this.status,
      required this.totalRows,
      required this.importedCount,
      required this.duplicateCount,
      required this.failedCount,
      required this.reviewCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['file_name'] = Variable<String>(fileName);
    map['file_type'] = Variable<String>(fileType);
    if (!nullToAbsent || importedAt != null) {
      map['imported_at'] = Variable<int>(
          $ImportBatchesTable.$converterimportedAtn.toSql(importedAt));
    }
    map['parser_version'] = Variable<String>(parserVersion);
    map['status'] = Variable<String>(status);
    map['total_rows'] = Variable<int>(totalRows);
    map['imported_count'] = Variable<int>(importedCount);
    map['duplicate_count'] = Variable<int>(duplicateCount);
    map['failed_count'] = Variable<int>(failedCount);
    map['review_count'] = Variable<int>(reviewCount);
    return map;
  }

  ImportBatchesCompanion toCompanion(bool nullToAbsent) {
    return ImportBatchesCompanion(
      id: Value(id),
      fileName: Value(fileName),
      fileType: Value(fileType),
      importedAt: importedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(importedAt),
      parserVersion: Value(parserVersion),
      status: Value(status),
      totalRows: Value(totalRows),
      importedCount: Value(importedCount),
      duplicateCount: Value(duplicateCount),
      failedCount: Value(failedCount),
      reviewCount: Value(reviewCount),
    );
  }

  factory ImportBatchEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportBatchEntry(
      id: serializer.fromJson<String>(json['id']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileType: serializer.fromJson<String>(json['fileType']),
      importedAt: serializer.fromJson<DateTime?>(json['importedAt']),
      parserVersion: serializer.fromJson<String>(json['parserVersion']),
      status: serializer.fromJson<String>(json['status']),
      totalRows: serializer.fromJson<int>(json['totalRows']),
      importedCount: serializer.fromJson<int>(json['importedCount']),
      duplicateCount: serializer.fromJson<int>(json['duplicateCount']),
      failedCount: serializer.fromJson<int>(json['failedCount']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fileName': serializer.toJson<String>(fileName),
      'fileType': serializer.toJson<String>(fileType),
      'importedAt': serializer.toJson<DateTime?>(importedAt),
      'parserVersion': serializer.toJson<String>(parserVersion),
      'status': serializer.toJson<String>(status),
      'totalRows': serializer.toJson<int>(totalRows),
      'importedCount': serializer.toJson<int>(importedCount),
      'duplicateCount': serializer.toJson<int>(duplicateCount),
      'failedCount': serializer.toJson<int>(failedCount),
      'reviewCount': serializer.toJson<int>(reviewCount),
    };
  }

  ImportBatchEntry copyWith(
          {String? id,
          String? fileName,
          String? fileType,
          Value<DateTime?> importedAt = const Value.absent(),
          String? parserVersion,
          String? status,
          int? totalRows,
          int? importedCount,
          int? duplicateCount,
          int? failedCount,
          int? reviewCount}) =>
      ImportBatchEntry(
        id: id ?? this.id,
        fileName: fileName ?? this.fileName,
        fileType: fileType ?? this.fileType,
        importedAt: importedAt.present ? importedAt.value : this.importedAt,
        parserVersion: parserVersion ?? this.parserVersion,
        status: status ?? this.status,
        totalRows: totalRows ?? this.totalRows,
        importedCount: importedCount ?? this.importedCount,
        duplicateCount: duplicateCount ?? this.duplicateCount,
        failedCount: failedCount ?? this.failedCount,
        reviewCount: reviewCount ?? this.reviewCount,
      );
  ImportBatchEntry copyWithCompanion(ImportBatchesCompanion data) {
    return ImportBatchEntry(
      id: data.id.present ? data.id.value : this.id,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      importedAt:
          data.importedAt.present ? data.importedAt.value : this.importedAt,
      parserVersion: data.parserVersion.present
          ? data.parserVersion.value
          : this.parserVersion,
      status: data.status.present ? data.status.value : this.status,
      totalRows: data.totalRows.present ? data.totalRows.value : this.totalRows,
      importedCount: data.importedCount.present
          ? data.importedCount.value
          : this.importedCount,
      duplicateCount: data.duplicateCount.present
          ? data.duplicateCount.value
          : this.duplicateCount,
      failedCount:
          data.failedCount.present ? data.failedCount.value : this.failedCount,
      reviewCount:
          data.reviewCount.present ? data.reviewCount.value : this.reviewCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchEntry(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('fileType: $fileType, ')
          ..write('importedAt: $importedAt, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('status: $status, ')
          ..write('totalRows: $totalRows, ')
          ..write('importedCount: $importedCount, ')
          ..write('duplicateCount: $duplicateCount, ')
          ..write('failedCount: $failedCount, ')
          ..write('reviewCount: $reviewCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      fileName,
      fileType,
      importedAt,
      parserVersion,
      status,
      totalRows,
      importedCount,
      duplicateCount,
      failedCount,
      reviewCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportBatchEntry &&
          other.id == this.id &&
          other.fileName == this.fileName &&
          other.fileType == this.fileType &&
          other.importedAt == this.importedAt &&
          other.parserVersion == this.parserVersion &&
          other.status == this.status &&
          other.totalRows == this.totalRows &&
          other.importedCount == this.importedCount &&
          other.duplicateCount == this.duplicateCount &&
          other.failedCount == this.failedCount &&
          other.reviewCount == this.reviewCount);
}

class ImportBatchesCompanion extends UpdateCompanion<ImportBatchEntry> {
  final Value<String> id;
  final Value<String> fileName;
  final Value<String> fileType;
  final Value<DateTime?> importedAt;
  final Value<String> parserVersion;
  final Value<String> status;
  final Value<int> totalRows;
  final Value<int> importedCount;
  final Value<int> duplicateCount;
  final Value<int> failedCount;
  final Value<int> reviewCount;
  final Value<int> rowid;
  const ImportBatchesCompanion({
    this.id = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileType = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.parserVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.totalRows = const Value.absent(),
    this.importedCount = const Value.absent(),
    this.duplicateCount = const Value.absent(),
    this.failedCount = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportBatchesCompanion.insert({
    this.id = const Value.absent(),
    required String fileName,
    required String fileType,
    this.importedAt = const Value.absent(),
    required String parserVersion,
    required String status,
    this.totalRows = const Value.absent(),
    this.importedCount = const Value.absent(),
    this.duplicateCount = const Value.absent(),
    this.failedCount = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : fileName = Value(fileName),
        fileType = Value(fileType),
        parserVersion = Value(parserVersion),
        status = Value(status);
  static Insertable<ImportBatchEntry> custom({
    Expression<String>? id,
    Expression<String>? fileName,
    Expression<String>? fileType,
    Expression<int>? importedAt,
    Expression<String>? parserVersion,
    Expression<String>? status,
    Expression<int>? totalRows,
    Expression<int>? importedCount,
    Expression<int>? duplicateCount,
    Expression<int>? failedCount,
    Expression<int>? reviewCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileName != null) 'file_name': fileName,
      if (fileType != null) 'file_type': fileType,
      if (importedAt != null) 'imported_at': importedAt,
      if (parserVersion != null) 'parser_version': parserVersion,
      if (status != null) 'status': status,
      if (totalRows != null) 'total_rows': totalRows,
      if (importedCount != null) 'imported_count': importedCount,
      if (duplicateCount != null) 'duplicate_count': duplicateCount,
      if (failedCount != null) 'failed_count': failedCount,
      if (reviewCount != null) 'review_count': reviewCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportBatchesCompanion copyWith(
      {Value<String>? id,
      Value<String>? fileName,
      Value<String>? fileType,
      Value<DateTime?>? importedAt,
      Value<String>? parserVersion,
      Value<String>? status,
      Value<int>? totalRows,
      Value<int>? importedCount,
      Value<int>? duplicateCount,
      Value<int>? failedCount,
      Value<int>? reviewCount,
      Value<int>? rowid}) {
    return ImportBatchesCompanion(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      importedAt: importedAt ?? this.importedAt,
      parserVersion: parserVersion ?? this.parserVersion,
      status: status ?? this.status,
      totalRows: totalRows ?? this.totalRows,
      importedCount: importedCount ?? this.importedCount,
      duplicateCount: duplicateCount ?? this.duplicateCount,
      failedCount: failedCount ?? this.failedCount,
      reviewCount: reviewCount ?? this.reviewCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<int>(
          $ImportBatchesTable.$converterimportedAtn.toSql(importedAt.value));
    }
    if (parserVersion.present) {
      map['parser_version'] = Variable<String>(parserVersion.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalRows.present) {
      map['total_rows'] = Variable<int>(totalRows.value);
    }
    if (importedCount.present) {
      map['imported_count'] = Variable<int>(importedCount.value);
    }
    if (duplicateCount.present) {
      map['duplicate_count'] = Variable<int>(duplicateCount.value);
    }
    if (failedCount.present) {
      map['failed_count'] = Variable<int>(failedCount.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchesCompanion(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('fileType: $fileType, ')
          ..write('importedAt: $importedAt, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('status: $status, ')
          ..write('totalRows: $totalRows, ')
          ..write('importedCount: $importedCount, ')
          ..write('duplicateCount: $duplicateCount, ')
          ..write('failedCount: $failedCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _parentCategoryIdMeta =
      const VerificationMeta('parentCategoryId');
  @override
  late final GeneratedColumn<String> parentCategoryId = GeneratedColumn<String>(
      'parent_category_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<int> isSystem = GeneratedColumn<int>(
      'is_system', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($CategoriesTable.$convertercreatedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($CategoriesTable.$converterupdatedAtn);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, parentCategoryId, icon, type, isSystem, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_category_id')) {
      context.handle(
          _parentCategoryIdMeta,
          parentCategoryId.isAcceptableOrUnknown(
              data['parent_category_id']!, _parentCategoryIdMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentCategoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}parent_category_id']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_system'])!,
      createdAt: $CategoriesTable.$convertercreatedAtn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
      updatedAt: $CategoriesTable.$converterupdatedAtn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterupdatedAtn =
      NullAwareTypeConverter.wrap($converterupdatedAt);
}

class CategoryEntry extends DataClass implements Insertable<CategoryEntry> {
  final String id;
  final String name;
  final String? parentCategoryId;
  final String icon;
  final String type;
  final int isSystem;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const CategoryEntry(
      {required this.id,
      required this.name,
      this.parentCategoryId,
      required this.icon,
      required this.type,
      required this.isSystem,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentCategoryId != null) {
      map['parent_category_id'] = Variable<String>(parentCategoryId);
    }
    map['icon'] = Variable<String>(icon);
    map['type'] = Variable<String>(type);
    map['is_system'] = Variable<int>(isSystem);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] =
          Variable<int>($CategoriesTable.$convertercreatedAtn.toSql(createdAt));
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] =
          Variable<int>($CategoriesTable.$converterupdatedAtn.toSql(updatedAt));
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentCategoryId: parentCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentCategoryId),
      icon: Value(icon),
      type: Value(type),
      isSystem: Value(isSystem),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory CategoryEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentCategoryId: serializer.fromJson<String?>(json['parentCategoryId']),
      icon: serializer.fromJson<String>(json['icon']),
      type: serializer.fromJson<String>(json['type']),
      isSystem: serializer.fromJson<int>(json['isSystem']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentCategoryId': serializer.toJson<String?>(parentCategoryId),
      'icon': serializer.toJson<String>(icon),
      'type': serializer.toJson<String>(type),
      'isSystem': serializer.toJson<int>(isSystem),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  CategoryEntry copyWith(
          {String? id,
          String? name,
          Value<String?> parentCategoryId = const Value.absent(),
          String? icon,
          String? type,
          int? isSystem,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      CategoryEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        parentCategoryId: parentCategoryId.present
            ? parentCategoryId.value
            : this.parentCategoryId,
        icon: icon ?? this.icon,
        type: type ?? this.type,
        isSystem: isSystem ?? this.isSystem,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  CategoryEntry copyWithCompanion(CategoriesCompanion data) {
    return CategoryEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentCategoryId: data.parentCategoryId.present
          ? data.parentCategoryId.value
          : this.parentCategoryId,
      icon: data.icon.present ? data.icon.value : this.icon,
      type: data.type.present ? data.type.value : this.type,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentCategoryId: $parentCategoryId, ')
          ..write('icon: $icon, ')
          ..write('type: $type, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, parentCategoryId, icon, type, isSystem, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentCategoryId == this.parentCategoryId &&
          other.icon == this.icon &&
          other.type == this.type &&
          other.isSystem == this.isSystem &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoryEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentCategoryId;
  final Value<String> icon;
  final Value<String> type;
  final Value<int> isSystem;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentCategoryId = const Value.absent(),
    this.icon = const Value.absent(),
    this.type = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentCategoryId = const Value.absent(),
    required String icon,
    required String type,
    this.isSystem = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        icon = Value(icon),
        type = Value(type);
  static Insertable<CategoryEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentCategoryId,
    Expression<String>? icon,
    Expression<String>? type,
    Expression<int>? isSystem,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentCategoryId != null) 'parent_category_id': parentCategoryId,
      if (icon != null) 'icon': icon,
      if (type != null) 'type': type,
      if (isSystem != null) 'is_system': isSystem,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? parentCategoryId,
      Value<String>? icon,
      Value<String>? type,
      Value<int>? isSystem,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentCategoryId.present) {
      map['parent_category_id'] = Variable<String>(parentCategoryId.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<int>(isSystem.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $CategoriesTable.$convertercreatedAtn.toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
          $CategoriesTable.$converterupdatedAtn.toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentCategoryId: $parentCategoryId, ')
          ..write('icon: $icon, ')
          ..write('type: $type, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _importBatchIdMeta =
      const VerificationMeta('importBatchId');
  @override
  late final GeneratedColumn<String> importBatchId = GeneratedColumn<String>(
      'import_batch_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES import_batches (id)'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> transactionDate =
      GeneratedColumn<int>('transaction_date', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $TransactionsTable.$convertertransactionDaten);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> postedDate =
      GeneratedColumn<int>('posted_date', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($TransactionsTable.$converterpostedDaten);
  static const VerificationMeta _rawDescriptionMeta =
      const VerificationMeta('rawDescription');
  @override
  late final GeneratedColumn<String> rawDescription = GeneratedColumn<String>(
      'raw_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _merchantNameMeta =
      const VerificationMeta('merchantName');
  @override
  late final GeneratedColumn<String> merchantName = GeneratedColumn<String>(
      'merchant_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _directionMeta =
      const VerificationMeta('direction');
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
      'direction', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('INR'));
  static const VerificationMeta _balanceAfterMeta =
      const VerificationMeta('balanceAfter');
  @override
  late final GeneratedColumn<double> balanceAfter = GeneratedColumn<double>(
      'balance_after', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categorizationConfidenceMeta =
      const VerificationMeta('categorizationConfidence');
  @override
  late final GeneratedColumn<double> categorizationConfidence =
      GeneratedColumn<double>('categorization_confidence', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _categorizationExplanationMeta =
      const VerificationMeta('categorizationExplanation');
  @override
  late final GeneratedColumn<String> categorizationExplanation =
      GeneratedColumn<String>('categorization_explanation', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>('tags', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<String>>($TransactionsTable.$convertertags);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> labelIds =
      GeneratedColumn<String>('label_ids', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<String>>($TransactionsTable.$converterlabelIds);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fingerprintMeta =
      const VerificationMeta('fingerprint');
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
      'fingerprint', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDuplicateMeta =
      const VerificationMeta('isDuplicate');
  @override
  late final GeneratedColumn<int> isDuplicate = GeneratedColumn<int>(
      'is_duplicate', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _needsReviewMeta =
      const VerificationMeta('needsReview');
  @override
  late final GeneratedColumn<int> needsReview = GeneratedColumn<int>(
      'needs_review', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($TransactionsTable.$convertercreatedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($TransactionsTable.$converterupdatedAtn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        importBatchId,
        accountId,
        transactionDate,
        postedDate,
        rawDescription,
        merchantName,
        amount,
        direction,
        currency,
        balanceAfter,
        categoryId,
        categoryName,
        categorizationConfidence,
        categorizationExplanation,
        tags,
        labelIds,
        notes,
        fingerprint,
        isDuplicate,
        needsReview,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('import_batch_id')) {
      context.handle(
          _importBatchIdMeta,
          importBatchId.isAcceptableOrUnknown(
              data['import_batch_id']!, _importBatchIdMeta));
    } else if (isInserting) {
      context.missing(_importBatchIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('raw_description')) {
      context.handle(
          _rawDescriptionMeta,
          rawDescription.isAcceptableOrUnknown(
              data['raw_description']!, _rawDescriptionMeta));
    } else if (isInserting) {
      context.missing(_rawDescriptionMeta);
    }
    if (data.containsKey('merchant_name')) {
      context.handle(
          _merchantNameMeta,
          merchantName.isAcceptableOrUnknown(
              data['merchant_name']!, _merchantNameMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction']!, _directionMeta));
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('balance_after')) {
      context.handle(
          _balanceAfterMeta,
          balanceAfter.isAcceptableOrUnknown(
              data['balance_after']!, _balanceAfterMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    }
    if (data.containsKey('categorization_confidence')) {
      context.handle(
          _categorizationConfidenceMeta,
          categorizationConfidence.isAcceptableOrUnknown(
              data['categorization_confidence']!,
              _categorizationConfidenceMeta));
    }
    if (data.containsKey('categorization_explanation')) {
      context.handle(
          _categorizationExplanationMeta,
          categorizationExplanation.isAcceptableOrUnknown(
              data['categorization_explanation']!,
              _categorizationExplanationMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
          _fingerprintMeta,
          fingerprint.isAcceptableOrUnknown(
              data['fingerprint']!, _fingerprintMeta));
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('is_duplicate')) {
      context.handle(
          _isDuplicateMeta,
          isDuplicate.isAcceptableOrUnknown(
              data['is_duplicate']!, _isDuplicateMeta));
    }
    if (data.containsKey('needs_review')) {
      context.handle(
          _needsReviewMeta,
          needsReview.isAcceptableOrUnknown(
              data['needs_review']!, _needsReviewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      importBatchId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}import_batch_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      transactionDate: $TransactionsTable.$convertertransactionDaten.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}transaction_date'])),
      postedDate: $TransactionsTable.$converterpostedDaten.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}posted_date'])),
      rawDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}raw_description'])!,
      merchantName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant_name']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      direction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direction'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      balanceAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance_after']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name']),
      categorizationConfidence: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}categorization_confidence'])!,
      categorizationExplanation: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}categorization_explanation']),
      tags: $TransactionsTable.$convertertags.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!),
      labelIds: $TransactionsTable.$converterlabelIds.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_ids'])!),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      fingerprint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fingerprint'])!,
      isDuplicate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_duplicate'])!,
      needsReview: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}needs_review'])!,
      createdAt: $TransactionsTable.$convertercreatedAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
      updatedAt: $TransactionsTable.$converterupdatedAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertertransactionDate =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertertransactionDaten =
      NullAwareTypeConverter.wrap($convertertransactionDate);
  static TypeConverter<DateTime, int> $converterpostedDate =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterpostedDaten =
      NullAwareTypeConverter.wrap($converterpostedDate);
  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
  static TypeConverter<List<String>, String> $converterlabelIds =
      const StringListConverter();
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterupdatedAtn =
      NullAwareTypeConverter.wrap($converterupdatedAt);
}

class TransactionEntry extends DataClass
    implements Insertable<TransactionEntry> {
  final String id;
  final String importBatchId;
  final String? accountId;
  final DateTime? transactionDate;
  final DateTime? postedDate;
  final String rawDescription;
  final String? merchantName;
  final double amount;
  final String direction;
  final String currency;
  final double? balanceAfter;
  final String? categoryId;
  final String? categoryName;
  final double categorizationConfidence;
  final String? categorizationExplanation;
  final List<String> tags;
  final List<String> labelIds;
  final String? notes;
  final String fingerprint;
  final int isDuplicate;
  final int needsReview;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const TransactionEntry(
      {required this.id,
      required this.importBatchId,
      this.accountId,
      this.transactionDate,
      this.postedDate,
      required this.rawDescription,
      this.merchantName,
      required this.amount,
      required this.direction,
      required this.currency,
      this.balanceAfter,
      this.categoryId,
      this.categoryName,
      required this.categorizationConfidence,
      this.categorizationExplanation,
      required this.tags,
      required this.labelIds,
      this.notes,
      required this.fingerprint,
      required this.isDuplicate,
      required this.needsReview,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['import_batch_id'] = Variable<String>(importBatchId);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || transactionDate != null) {
      map['transaction_date'] = Variable<int>(
          $TransactionsTable.$convertertransactionDaten.toSql(transactionDate));
    }
    if (!nullToAbsent || postedDate != null) {
      map['posted_date'] = Variable<int>(
          $TransactionsTable.$converterpostedDaten.toSql(postedDate));
    }
    map['raw_description'] = Variable<String>(rawDescription);
    if (!nullToAbsent || merchantName != null) {
      map['merchant_name'] = Variable<String>(merchantName);
    }
    map['amount'] = Variable<double>(amount);
    map['direction'] = Variable<String>(direction);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || balanceAfter != null) {
      map['balance_after'] = Variable<double>(balanceAfter);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    map['categorization_confidence'] =
        Variable<double>(categorizationConfidence);
    if (!nullToAbsent || categorizationExplanation != null) {
      map['categorization_explanation'] =
          Variable<String>(categorizationExplanation);
    }
    {
      map['tags'] =
          Variable<String>($TransactionsTable.$convertertags.toSql(tags));
    }
    {
      map['label_ids'] = Variable<String>(
          $TransactionsTable.$converterlabelIds.toSql(labelIds));
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['fingerprint'] = Variable<String>(fingerprint);
    map['is_duplicate'] = Variable<int>(isDuplicate);
    map['needs_review'] = Variable<int>(needsReview);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(
          $TransactionsTable.$convertercreatedAtn.toSql(createdAt));
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(
          $TransactionsTable.$converterupdatedAtn.toSql(updatedAt));
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      importBatchId: Value(importBatchId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      transactionDate: transactionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionDate),
      postedDate: postedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(postedDate),
      rawDescription: Value(rawDescription),
      merchantName: merchantName == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantName),
      amount: Value(amount),
      direction: Value(direction),
      currency: Value(currency),
      balanceAfter: balanceAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(balanceAfter),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      categorizationConfidence: Value(categorizationConfidence),
      categorizationExplanation:
          categorizationExplanation == null && nullToAbsent
              ? const Value.absent()
              : Value(categorizationExplanation),
      tags: Value(tags),
      labelIds: Value(labelIds),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      fingerprint: Value(fingerprint),
      isDuplicate: Value(isDuplicate),
      needsReview: Value(needsReview),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory TransactionEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionEntry(
      id: serializer.fromJson<String>(json['id']),
      importBatchId: serializer.fromJson<String>(json['importBatchId']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      transactionDate: serializer.fromJson<DateTime?>(json['transactionDate']),
      postedDate: serializer.fromJson<DateTime?>(json['postedDate']),
      rawDescription: serializer.fromJson<String>(json['rawDescription']),
      merchantName: serializer.fromJson<String?>(json['merchantName']),
      amount: serializer.fromJson<double>(json['amount']),
      direction: serializer.fromJson<String>(json['direction']),
      currency: serializer.fromJson<String>(json['currency']),
      balanceAfter: serializer.fromJson<double?>(json['balanceAfter']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      categorizationConfidence:
          serializer.fromJson<double>(json['categorizationConfidence']),
      categorizationExplanation:
          serializer.fromJson<String?>(json['categorizationExplanation']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      labelIds: serializer.fromJson<List<String>>(json['labelIds']),
      notes: serializer.fromJson<String?>(json['notes']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      isDuplicate: serializer.fromJson<int>(json['isDuplicate']),
      needsReview: serializer.fromJson<int>(json['needsReview']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'importBatchId': serializer.toJson<String>(importBatchId),
      'accountId': serializer.toJson<String?>(accountId),
      'transactionDate': serializer.toJson<DateTime?>(transactionDate),
      'postedDate': serializer.toJson<DateTime?>(postedDate),
      'rawDescription': serializer.toJson<String>(rawDescription),
      'merchantName': serializer.toJson<String?>(merchantName),
      'amount': serializer.toJson<double>(amount),
      'direction': serializer.toJson<String>(direction),
      'currency': serializer.toJson<String>(currency),
      'balanceAfter': serializer.toJson<double?>(balanceAfter),
      'categoryId': serializer.toJson<String?>(categoryId),
      'categoryName': serializer.toJson<String?>(categoryName),
      'categorizationConfidence':
          serializer.toJson<double>(categorizationConfidence),
      'categorizationExplanation':
          serializer.toJson<String?>(categorizationExplanation),
      'tags': serializer.toJson<List<String>>(tags),
      'labelIds': serializer.toJson<List<String>>(labelIds),
      'notes': serializer.toJson<String?>(notes),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'isDuplicate': serializer.toJson<int>(isDuplicate),
      'needsReview': serializer.toJson<int>(needsReview),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  TransactionEntry copyWith(
          {String? id,
          String? importBatchId,
          Value<String?> accountId = const Value.absent(),
          Value<DateTime?> transactionDate = const Value.absent(),
          Value<DateTime?> postedDate = const Value.absent(),
          String? rawDescription,
          Value<String?> merchantName = const Value.absent(),
          double? amount,
          String? direction,
          String? currency,
          Value<double?> balanceAfter = const Value.absent(),
          Value<String?> categoryId = const Value.absent(),
          Value<String?> categoryName = const Value.absent(),
          double? categorizationConfidence,
          Value<String?> categorizationExplanation = const Value.absent(),
          List<String>? tags,
          List<String>? labelIds,
          Value<String?> notes = const Value.absent(),
          String? fingerprint,
          int? isDuplicate,
          int? needsReview,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      TransactionEntry(
        id: id ?? this.id,
        importBatchId: importBatchId ?? this.importBatchId,
        accountId: accountId.present ? accountId.value : this.accountId,
        transactionDate: transactionDate.present
            ? transactionDate.value
            : this.transactionDate,
        postedDate: postedDate.present ? postedDate.value : this.postedDate,
        rawDescription: rawDescription ?? this.rawDescription,
        merchantName:
            merchantName.present ? merchantName.value : this.merchantName,
        amount: amount ?? this.amount,
        direction: direction ?? this.direction,
        currency: currency ?? this.currency,
        balanceAfter:
            balanceAfter.present ? balanceAfter.value : this.balanceAfter,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        categoryName:
            categoryName.present ? categoryName.value : this.categoryName,
        categorizationConfidence:
            categorizationConfidence ?? this.categorizationConfidence,
        categorizationExplanation: categorizationExplanation.present
            ? categorizationExplanation.value
            : this.categorizationExplanation,
        tags: tags ?? this.tags,
        labelIds: labelIds ?? this.labelIds,
        notes: notes.present ? notes.value : this.notes,
        fingerprint: fingerprint ?? this.fingerprint,
        isDuplicate: isDuplicate ?? this.isDuplicate,
        needsReview: needsReview ?? this.needsReview,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  TransactionEntry copyWithCompanion(TransactionsCompanion data) {
    return TransactionEntry(
      id: data.id.present ? data.id.value : this.id,
      importBatchId: data.importBatchId.present
          ? data.importBatchId.value
          : this.importBatchId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      postedDate:
          data.postedDate.present ? data.postedDate.value : this.postedDate,
      rawDescription: data.rawDescription.present
          ? data.rawDescription.value
          : this.rawDescription,
      merchantName: data.merchantName.present
          ? data.merchantName.value
          : this.merchantName,
      amount: data.amount.present ? data.amount.value : this.amount,
      direction: data.direction.present ? data.direction.value : this.direction,
      currency: data.currency.present ? data.currency.value : this.currency,
      balanceAfter: data.balanceAfter.present
          ? data.balanceAfter.value
          : this.balanceAfter,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      categorizationConfidence: data.categorizationConfidence.present
          ? data.categorizationConfidence.value
          : this.categorizationConfidence,
      categorizationExplanation: data.categorizationExplanation.present
          ? data.categorizationExplanation.value
          : this.categorizationExplanation,
      tags: data.tags.present ? data.tags.value : this.tags,
      labelIds: data.labelIds.present ? data.labelIds.value : this.labelIds,
      notes: data.notes.present ? data.notes.value : this.notes,
      fingerprint:
          data.fingerprint.present ? data.fingerprint.value : this.fingerprint,
      isDuplicate:
          data.isDuplicate.present ? data.isDuplicate.value : this.isDuplicate,
      needsReview:
          data.needsReview.present ? data.needsReview.value : this.needsReview,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionEntry(')
          ..write('id: $id, ')
          ..write('importBatchId: $importBatchId, ')
          ..write('accountId: $accountId, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('postedDate: $postedDate, ')
          ..write('rawDescription: $rawDescription, ')
          ..write('merchantName: $merchantName, ')
          ..write('amount: $amount, ')
          ..write('direction: $direction, ')
          ..write('currency: $currency, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('categorizationConfidence: $categorizationConfidence, ')
          ..write('categorizationExplanation: $categorizationExplanation, ')
          ..write('tags: $tags, ')
          ..write('labelIds: $labelIds, ')
          ..write('notes: $notes, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('isDuplicate: $isDuplicate, ')
          ..write('needsReview: $needsReview, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        importBatchId,
        accountId,
        transactionDate,
        postedDate,
        rawDescription,
        merchantName,
        amount,
        direction,
        currency,
        balanceAfter,
        categoryId,
        categoryName,
        categorizationConfidence,
        categorizationExplanation,
        tags,
        labelIds,
        notes,
        fingerprint,
        isDuplicate,
        needsReview,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionEntry &&
          other.id == this.id &&
          other.importBatchId == this.importBatchId &&
          other.accountId == this.accountId &&
          other.transactionDate == this.transactionDate &&
          other.postedDate == this.postedDate &&
          other.rawDescription == this.rawDescription &&
          other.merchantName == this.merchantName &&
          other.amount == this.amount &&
          other.direction == this.direction &&
          other.currency == this.currency &&
          other.balanceAfter == this.balanceAfter &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.categorizationConfidence == this.categorizationConfidence &&
          other.categorizationExplanation == this.categorizationExplanation &&
          other.tags == this.tags &&
          other.labelIds == this.labelIds &&
          other.notes == this.notes &&
          other.fingerprint == this.fingerprint &&
          other.isDuplicate == this.isDuplicate &&
          other.needsReview == this.needsReview &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionEntry> {
  final Value<String> id;
  final Value<String> importBatchId;
  final Value<String?> accountId;
  final Value<DateTime?> transactionDate;
  final Value<DateTime?> postedDate;
  final Value<String> rawDescription;
  final Value<String?> merchantName;
  final Value<double> amount;
  final Value<String> direction;
  final Value<String> currency;
  final Value<double?> balanceAfter;
  final Value<String?> categoryId;
  final Value<String?> categoryName;
  final Value<double> categorizationConfidence;
  final Value<String?> categorizationExplanation;
  final Value<List<String>> tags;
  final Value<List<String>> labelIds;
  final Value<String?> notes;
  final Value<String> fingerprint;
  final Value<int> isDuplicate;
  final Value<int> needsReview;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.importBatchId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.postedDate = const Value.absent(),
    this.rawDescription = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.amount = const Value.absent(),
    this.direction = const Value.absent(),
    this.currency = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.categorizationConfidence = const Value.absent(),
    this.categorizationExplanation = const Value.absent(),
    this.tags = const Value.absent(),
    this.labelIds = const Value.absent(),
    this.notes = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.isDuplicate = const Value.absent(),
    this.needsReview = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String importBatchId,
    this.accountId = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.postedDate = const Value.absent(),
    required String rawDescription,
    this.merchantName = const Value.absent(),
    required double amount,
    required String direction,
    this.currency = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.categorizationConfidence = const Value.absent(),
    this.categorizationExplanation = const Value.absent(),
    this.tags = const Value.absent(),
    this.labelIds = const Value.absent(),
    this.notes = const Value.absent(),
    required String fingerprint,
    this.isDuplicate = const Value.absent(),
    this.needsReview = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : importBatchId = Value(importBatchId),
        rawDescription = Value(rawDescription),
        amount = Value(amount),
        direction = Value(direction),
        fingerprint = Value(fingerprint);
  static Insertable<TransactionEntry> custom({
    Expression<String>? id,
    Expression<String>? importBatchId,
    Expression<String>? accountId,
    Expression<int>? transactionDate,
    Expression<int>? postedDate,
    Expression<String>? rawDescription,
    Expression<String>? merchantName,
    Expression<double>? amount,
    Expression<String>? direction,
    Expression<String>? currency,
    Expression<double>? balanceAfter,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<double>? categorizationConfidence,
    Expression<String>? categorizationExplanation,
    Expression<String>? tags,
    Expression<String>? labelIds,
    Expression<String>? notes,
    Expression<String>? fingerprint,
    Expression<int>? isDuplicate,
    Expression<int>? needsReview,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (importBatchId != null) 'import_batch_id': importBatchId,
      if (accountId != null) 'account_id': accountId,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (postedDate != null) 'posted_date': postedDate,
      if (rawDescription != null) 'raw_description': rawDescription,
      if (merchantName != null) 'merchant_name': merchantName,
      if (amount != null) 'amount': amount,
      if (direction != null) 'direction': direction,
      if (currency != null) 'currency': currency,
      if (balanceAfter != null) 'balance_after': balanceAfter,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (categorizationConfidence != null)
        'categorization_confidence': categorizationConfidence,
      if (categorizationExplanation != null)
        'categorization_explanation': categorizationExplanation,
      if (tags != null) 'tags': tags,
      if (labelIds != null) 'label_ids': labelIds,
      if (notes != null) 'notes': notes,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (isDuplicate != null) 'is_duplicate': isDuplicate,
      if (needsReview != null) 'needs_review': needsReview,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? importBatchId,
      Value<String?>? accountId,
      Value<DateTime?>? transactionDate,
      Value<DateTime?>? postedDate,
      Value<String>? rawDescription,
      Value<String?>? merchantName,
      Value<double>? amount,
      Value<String>? direction,
      Value<String>? currency,
      Value<double?>? balanceAfter,
      Value<String?>? categoryId,
      Value<String?>? categoryName,
      Value<double>? categorizationConfidence,
      Value<String?>? categorizationExplanation,
      Value<List<String>>? tags,
      Value<List<String>>? labelIds,
      Value<String?>? notes,
      Value<String>? fingerprint,
      Value<int>? isDuplicate,
      Value<int>? needsReview,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      importBatchId: importBatchId ?? this.importBatchId,
      accountId: accountId ?? this.accountId,
      transactionDate: transactionDate ?? this.transactionDate,
      postedDate: postedDate ?? this.postedDate,
      rawDescription: rawDescription ?? this.rawDescription,
      merchantName: merchantName ?? this.merchantName,
      amount: amount ?? this.amount,
      direction: direction ?? this.direction,
      currency: currency ?? this.currency,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categorizationConfidence:
          categorizationConfidence ?? this.categorizationConfidence,
      categorizationExplanation:
          categorizationExplanation ?? this.categorizationExplanation,
      tags: tags ?? this.tags,
      labelIds: labelIds ?? this.labelIds,
      notes: notes ?? this.notes,
      fingerprint: fingerprint ?? this.fingerprint,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      needsReview: needsReview ?? this.needsReview,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (importBatchId.present) {
      map['import_batch_id'] = Variable<String>(importBatchId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<int>($TransactionsTable
          .$convertertransactionDaten
          .toSql(transactionDate.value));
    }
    if (postedDate.present) {
      map['posted_date'] = Variable<int>(
          $TransactionsTable.$converterpostedDaten.toSql(postedDate.value));
    }
    if (rawDescription.present) {
      map['raw_description'] = Variable<String>(rawDescription.value);
    }
    if (merchantName.present) {
      map['merchant_name'] = Variable<String>(merchantName.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (balanceAfter.present) {
      map['balance_after'] = Variable<double>(balanceAfter.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (categorizationConfidence.present) {
      map['categorization_confidence'] =
          Variable<double>(categorizationConfidence.value);
    }
    if (categorizationExplanation.present) {
      map['categorization_explanation'] =
          Variable<String>(categorizationExplanation.value);
    }
    if (tags.present) {
      map['tags'] =
          Variable<String>($TransactionsTable.$convertertags.toSql(tags.value));
    }
    if (labelIds.present) {
      map['label_ids'] = Variable<String>(
          $TransactionsTable.$converterlabelIds.toSql(labelIds.value));
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (isDuplicate.present) {
      map['is_duplicate'] = Variable<int>(isDuplicate.value);
    }
    if (needsReview.present) {
      map['needs_review'] = Variable<int>(needsReview.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $TransactionsTable.$convertercreatedAtn.toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
          $TransactionsTable.$converterupdatedAtn.toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('importBatchId: $importBatchId, ')
          ..write('accountId: $accountId, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('postedDate: $postedDate, ')
          ..write('rawDescription: $rawDescription, ')
          ..write('merchantName: $merchantName, ')
          ..write('amount: $amount, ')
          ..write('direction: $direction, ')
          ..write('currency: $currency, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('categorizationConfidence: $categorizationConfidence, ')
          ..write('categorizationExplanation: $categorizationExplanation, ')
          ..write('tags: $tags, ')
          ..write('labelIds: $labelIds, ')
          ..write('notes: $notes, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('isDuplicate: $isDuplicate, ')
          ..write('needsReview: $needsReview, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategorizationRulesTable extends CategorizationRules
    with TableInfo<$CategorizationRulesTable, CategorizationRuleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategorizationRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _patternMeta =
      const VerificationMeta('pattern');
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
      'pattern', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _matchTypeMeta =
      const VerificationMeta('matchType');
  @override
  late final GeneratedColumn<String> matchType = GeneratedColumn<String>(
      'match_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _merchantNameMeta =
      const VerificationMeta('merchantName');
  @override
  late final GeneratedColumn<String> merchantName = GeneratedColumn<String>(
      'merchant_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdByUserMeta =
      const VerificationMeta('createdByUser');
  @override
  late final GeneratedColumn<int> createdByUser = GeneratedColumn<int>(
      'created_by_user', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _usageCountMeta =
      const VerificationMeta('usageCount');
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
      'usage_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $CategorizationRulesTable.$convertercreatedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $CategorizationRulesTable.$converterupdatedAtn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pattern,
        matchType,
        categoryId,
        categoryName,
        merchantName,
        priority,
        createdByUser,
        usageCount,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorization_rules';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategorizationRuleEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pattern')) {
      context.handle(_patternMeta,
          pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta));
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('match_type')) {
      context.handle(_matchTypeMeta,
          matchType.isAcceptableOrUnknown(data['match_type']!, _matchTypeMeta));
    } else if (isInserting) {
      context.missing(_matchTypeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    }
    if (data.containsKey('merchant_name')) {
      context.handle(
          _merchantNameMeta,
          merchantName.isAcceptableOrUnknown(
              data['merchant_name']!, _merchantNameMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('created_by_user')) {
      context.handle(
          _createdByUserMeta,
          createdByUser.isAcceptableOrUnknown(
              data['created_by_user']!, _createdByUserMeta));
    }
    if (data.containsKey('usage_count')) {
      context.handle(
          _usageCountMeta,
          usageCount.isAcceptableOrUnknown(
              data['usage_count']!, _usageCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategorizationRuleEntry map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategorizationRuleEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      pattern: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pattern'])!,
      matchType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}match_type'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name']),
      merchantName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant_name']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      createdByUser: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by_user'])!,
      usageCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usage_count'])!,
      createdAt: $CategorizationRulesTable.$convertercreatedAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
      updatedAt: $CategorizationRulesTable.$converterupdatedAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])),
    );
  }

  @override
  $CategorizationRulesTable createAlias(String alias) {
    return $CategorizationRulesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterupdatedAtn =
      NullAwareTypeConverter.wrap($converterupdatedAt);
}

class CategorizationRuleEntry extends DataClass
    implements Insertable<CategorizationRuleEntry> {
  final String id;
  final String pattern;
  final String matchType;
  final String categoryId;
  final String? categoryName;
  final String? merchantName;
  final int priority;
  final int createdByUser;
  final int usageCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const CategorizationRuleEntry(
      {required this.id,
      required this.pattern,
      required this.matchType,
      required this.categoryId,
      this.categoryName,
      this.merchantName,
      required this.priority,
      required this.createdByUser,
      required this.usageCount,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pattern'] = Variable<String>(pattern);
    map['match_type'] = Variable<String>(matchType);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    if (!nullToAbsent || merchantName != null) {
      map['merchant_name'] = Variable<String>(merchantName);
    }
    map['priority'] = Variable<int>(priority);
    map['created_by_user'] = Variable<int>(createdByUser);
    map['usage_count'] = Variable<int>(usageCount);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(
          $CategorizationRulesTable.$convertercreatedAtn.toSql(createdAt));
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(
          $CategorizationRulesTable.$converterupdatedAtn.toSql(updatedAt));
    }
    return map;
  }

  CategorizationRulesCompanion toCompanion(bool nullToAbsent) {
    return CategorizationRulesCompanion(
      id: Value(id),
      pattern: Value(pattern),
      matchType: Value(matchType),
      categoryId: Value(categoryId),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      merchantName: merchantName == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantName),
      priority: Value(priority),
      createdByUser: Value(createdByUser),
      usageCount: Value(usageCount),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory CategorizationRuleEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategorizationRuleEntry(
      id: serializer.fromJson<String>(json['id']),
      pattern: serializer.fromJson<String>(json['pattern']),
      matchType: serializer.fromJson<String>(json['matchType']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      merchantName: serializer.fromJson<String?>(json['merchantName']),
      priority: serializer.fromJson<int>(json['priority']),
      createdByUser: serializer.fromJson<int>(json['createdByUser']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pattern': serializer.toJson<String>(pattern),
      'matchType': serializer.toJson<String>(matchType),
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryName': serializer.toJson<String?>(categoryName),
      'merchantName': serializer.toJson<String?>(merchantName),
      'priority': serializer.toJson<int>(priority),
      'createdByUser': serializer.toJson<int>(createdByUser),
      'usageCount': serializer.toJson<int>(usageCount),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  CategorizationRuleEntry copyWith(
          {String? id,
          String? pattern,
          String? matchType,
          String? categoryId,
          Value<String?> categoryName = const Value.absent(),
          Value<String?> merchantName = const Value.absent(),
          int? priority,
          int? createdByUser,
          int? usageCount,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      CategorizationRuleEntry(
        id: id ?? this.id,
        pattern: pattern ?? this.pattern,
        matchType: matchType ?? this.matchType,
        categoryId: categoryId ?? this.categoryId,
        categoryName:
            categoryName.present ? categoryName.value : this.categoryName,
        merchantName:
            merchantName.present ? merchantName.value : this.merchantName,
        priority: priority ?? this.priority,
        createdByUser: createdByUser ?? this.createdByUser,
        usageCount: usageCount ?? this.usageCount,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  CategorizationRuleEntry copyWithCompanion(CategorizationRulesCompanion data) {
    return CategorizationRuleEntry(
      id: data.id.present ? data.id.value : this.id,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      matchType: data.matchType.present ? data.matchType.value : this.matchType,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      merchantName: data.merchantName.present
          ? data.merchantName.value
          : this.merchantName,
      priority: data.priority.present ? data.priority.value : this.priority,
      createdByUser: data.createdByUser.present
          ? data.createdByUser.value
          : this.createdByUser,
      usageCount:
          data.usageCount.present ? data.usageCount.value : this.usageCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategorizationRuleEntry(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('matchType: $matchType, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('merchantName: $merchantName, ')
          ..write('priority: $priority, ')
          ..write('createdByUser: $createdByUser, ')
          ..write('usageCount: $usageCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      pattern,
      matchType,
      categoryId,
      categoryName,
      merchantName,
      priority,
      createdByUser,
      usageCount,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategorizationRuleEntry &&
          other.id == this.id &&
          other.pattern == this.pattern &&
          other.matchType == this.matchType &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.merchantName == this.merchantName &&
          other.priority == this.priority &&
          other.createdByUser == this.createdByUser &&
          other.usageCount == this.usageCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategorizationRulesCompanion
    extends UpdateCompanion<CategorizationRuleEntry> {
  final Value<String> id;
  final Value<String> pattern;
  final Value<String> matchType;
  final Value<String> categoryId;
  final Value<String?> categoryName;
  final Value<String?> merchantName;
  final Value<int> priority;
  final Value<int> createdByUser;
  final Value<int> usageCount;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const CategorizationRulesCompanion({
    this.id = const Value.absent(),
    this.pattern = const Value.absent(),
    this.matchType = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.priority = const Value.absent(),
    this.createdByUser = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategorizationRulesCompanion.insert({
    this.id = const Value.absent(),
    required String pattern,
    required String matchType,
    required String categoryId,
    this.categoryName = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.priority = const Value.absent(),
    this.createdByUser = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : pattern = Value(pattern),
        matchType = Value(matchType),
        categoryId = Value(categoryId);
  static Insertable<CategorizationRuleEntry> custom({
    Expression<String>? id,
    Expression<String>? pattern,
    Expression<String>? matchType,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? merchantName,
    Expression<int>? priority,
    Expression<int>? createdByUser,
    Expression<int>? usageCount,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pattern != null) 'pattern': pattern,
      if (matchType != null) 'match_type': matchType,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (merchantName != null) 'merchant_name': merchantName,
      if (priority != null) 'priority': priority,
      if (createdByUser != null) 'created_by_user': createdByUser,
      if (usageCount != null) 'usage_count': usageCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategorizationRulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? pattern,
      Value<String>? matchType,
      Value<String>? categoryId,
      Value<String?>? categoryName,
      Value<String?>? merchantName,
      Value<int>? priority,
      Value<int>? createdByUser,
      Value<int>? usageCount,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return CategorizationRulesCompanion(
      id: id ?? this.id,
      pattern: pattern ?? this.pattern,
      matchType: matchType ?? this.matchType,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      merchantName: merchantName ?? this.merchantName,
      priority: priority ?? this.priority,
      createdByUser: createdByUser ?? this.createdByUser,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (matchType.present) {
      map['match_type'] = Variable<String>(matchType.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (merchantName.present) {
      map['merchant_name'] = Variable<String>(merchantName.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (createdByUser.present) {
      map['created_by_user'] = Variable<int>(createdByUser.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>($CategorizationRulesTable
          .$convertercreatedAtn
          .toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>($CategorizationRulesTable
          .$converterupdatedAtn
          .toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategorizationRulesCompanion(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('matchType: $matchType, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('merchantName: $merchantName, ')
          ..write('priority: $priority, ')
          ..write('createdByUser: $createdByUser, ')
          ..write('usageCount: $usageCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _spentMeta = const VerificationMeta('spent');
  @override
  late final GeneratedColumn<double> spent = GeneratedColumn<double>(
      'spent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('INR'));
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($BudgetsTable.$convertercreatedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($BudgetsTable.$converterupdatedAtn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        categoryId,
        categoryName,
        month,
        year,
        amount,
        spent,
        currency,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(Insertable<BudgetEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('spent')) {
      context.handle(
          _spentMeta, spent.isAcceptableOrUnknown(data['spent']!, _spentMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name']),
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      spent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}spent'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      createdAt: $BudgetsTable.$convertercreatedAtn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
      updatedAt: $BudgetsTable.$converterupdatedAtn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])),
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterupdatedAtn =
      NullAwareTypeConverter.wrap($converterupdatedAt);
}

class BudgetEntry extends DataClass implements Insertable<BudgetEntry> {
  final String id;
  final String categoryId;
  final String? categoryName;
  final int month;
  final int year;
  final double amount;
  final double spent;
  final String currency;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const BudgetEntry(
      {required this.id,
      required this.categoryId,
      this.categoryName,
      required this.month,
      required this.year,
      required this.amount,
      required this.spent,
      required this.currency,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    map['amount'] = Variable<double>(amount);
    map['spent'] = Variable<double>(spent);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] =
          Variable<int>($BudgetsTable.$convertercreatedAtn.toSql(createdAt));
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] =
          Variable<int>($BudgetsTable.$converterupdatedAtn.toSql(updatedAt));
    }
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      month: Value(month),
      year: Value(year),
      amount: Value(amount),
      spent: Value(spent),
      currency: Value(currency),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory BudgetEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetEntry(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
      amount: serializer.fromJson<double>(json['amount']),
      spent: serializer.fromJson<double>(json['spent']),
      currency: serializer.fromJson<String>(json['currency']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryName': serializer.toJson<String?>(categoryName),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
      'amount': serializer.toJson<double>(amount),
      'spent': serializer.toJson<double>(spent),
      'currency': serializer.toJson<String>(currency),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  BudgetEntry copyWith(
          {String? id,
          String? categoryId,
          Value<String?> categoryName = const Value.absent(),
          int? month,
          int? year,
          double? amount,
          double? spent,
          String? currency,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      BudgetEntry(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        categoryName:
            categoryName.present ? categoryName.value : this.categoryName,
        month: month ?? this.month,
        year: year ?? this.year,
        amount: amount ?? this.amount,
        spent: spent ?? this.spent,
        currency: currency ?? this.currency,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  BudgetEntry copyWithCompanion(BudgetsCompanion data) {
    return BudgetEntry(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      amount: data.amount.present ? data.amount.value : this.amount,
      spent: data.spent.present ? data.spent.value : this.spent,
      currency: data.currency.present ? data.currency.value : this.currency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntry(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('amount: $amount, ')
          ..write('spent: $spent, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, categoryName, month, year,
      amount, spent, currency, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetEntry &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.month == this.month &&
          other.year == this.year &&
          other.amount == this.amount &&
          other.spent == this.spent &&
          other.currency == this.currency &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsCompanion extends UpdateCompanion<BudgetEntry> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String?> categoryName;
  final Value<int> month;
  final Value<int> year;
  final Value<double> amount;
  final Value<double> spent;
  final Value<String> currency;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.amount = const Value.absent(),
    this.spent = const Value.absent(),
    this.currency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required String categoryId,
    this.categoryName = const Value.absent(),
    required int month,
    required int year,
    required double amount,
    this.spent = const Value.absent(),
    this.currency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : categoryId = Value(categoryId),
        month = Value(month),
        year = Value(year),
        amount = Value(amount);
  static Insertable<BudgetEntry> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<int>? month,
    Expression<int>? year,
    Expression<double>? amount,
    Expression<double>? spent,
    Expression<String>? currency,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (amount != null) 'amount': amount,
      if (spent != null) 'spent': spent,
      if (currency != null) 'currency': currency,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? categoryId,
      Value<String?>? categoryName,
      Value<int>? month,
      Value<int>? year,
      Value<double>? amount,
      Value<double>? spent,
      Value<String>? currency,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      month: month ?? this.month,
      year: year ?? this.year,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (spent.present) {
      map['spent'] = Variable<double>(spent.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $BudgetsTable.$convertercreatedAtn.toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
          $BudgetsTable.$converterupdatedAtn.toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('amount: $amount, ')
          ..write('spent: $spent, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringPaymentsTable extends RecurringPayments
    with TableInfo<$RecurringPaymentsTable, RecurringPaymentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _merchantNameMeta =
      const VerificationMeta('merchantName');
  @override
  late final GeneratedColumn<String> merchantName = GeneratedColumn<String>(
      'merchant_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expectedAmountMeta =
      const VerificationMeta('expectedAmount');
  @override
  late final GeneratedColumn<double> expectedAmount = GeneratedColumn<double>(
      'expected_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> nextExpectedDate =
      GeneratedColumn<int>('next_expected_date', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $RecurringPaymentsTable.$converternextExpectedDaten);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int>
      lastTransactionDate = GeneratedColumn<int>(
              'last_transaction_date', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $RecurringPaymentsTable.$converterlastTransactionDaten);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $RecurringPaymentsTable.$convertercreatedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $RecurringPaymentsTable.$converterupdatedAtn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        merchantName,
        categoryId,
        categoryName,
        expectedAmount,
        frequency,
        confidence,
        status,
        nextExpectedDate,
        lastTransactionDate,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_payments';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecurringPaymentEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('merchant_name')) {
      context.handle(
          _merchantNameMeta,
          merchantName.isAcceptableOrUnknown(
              data['merchant_name']!, _merchantNameMeta));
    } else if (isInserting) {
      context.missing(_merchantNameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    }
    if (data.containsKey('expected_amount')) {
      context.handle(
          _expectedAmountMeta,
          expectedAmount.isAcceptableOrUnknown(
              data['expected_amount']!, _expectedAmountMeta));
    } else if (isInserting) {
      context.missing(_expectedAmountMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringPaymentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringPaymentEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      merchantName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant_name'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name']),
      expectedAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}expected_amount'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      nextExpectedDate: $RecurringPaymentsTable.$converternextExpectedDaten
          .fromSql(attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}next_expected_date'])),
      lastTransactionDate: $RecurringPaymentsTable
          .$converterlastTransactionDaten
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int,
              data['${effectivePrefix}last_transaction_date'])),
      createdAt: $RecurringPaymentsTable.$convertercreatedAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
      updatedAt: $RecurringPaymentsTable.$converterupdatedAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])),
    );
  }

  @override
  $RecurringPaymentsTable createAlias(String alias) {
    return $RecurringPaymentsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converternextExpectedDate =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converternextExpectedDaten =
      NullAwareTypeConverter.wrap($converternextExpectedDate);
  static TypeConverter<DateTime, int> $converterlastTransactionDate =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterlastTransactionDaten =
      NullAwareTypeConverter.wrap($converterlastTransactionDate);
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterupdatedAtn =
      NullAwareTypeConverter.wrap($converterupdatedAt);
}

class RecurringPaymentEntry extends DataClass
    implements Insertable<RecurringPaymentEntry> {
  final String id;
  final String merchantName;
  final String? categoryId;
  final String? categoryName;
  final double expectedAmount;
  final String frequency;
  final double confidence;
  final String status;
  final DateTime? nextExpectedDate;
  final DateTime? lastTransactionDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const RecurringPaymentEntry(
      {required this.id,
      required this.merchantName,
      this.categoryId,
      this.categoryName,
      required this.expectedAmount,
      required this.frequency,
      required this.confidence,
      required this.status,
      this.nextExpectedDate,
      this.lastTransactionDate,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['merchant_name'] = Variable<String>(merchantName);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    map['expected_amount'] = Variable<double>(expectedAmount);
    map['frequency'] = Variable<String>(frequency);
    map['confidence'] = Variable<double>(confidence);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || nextExpectedDate != null) {
      map['next_expected_date'] = Variable<int>($RecurringPaymentsTable
          .$converternextExpectedDaten
          .toSql(nextExpectedDate));
    }
    if (!nullToAbsent || lastTransactionDate != null) {
      map['last_transaction_date'] = Variable<int>($RecurringPaymentsTable
          .$converterlastTransactionDaten
          .toSql(lastTransactionDate));
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(
          $RecurringPaymentsTable.$convertercreatedAtn.toSql(createdAt));
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(
          $RecurringPaymentsTable.$converterupdatedAtn.toSql(updatedAt));
    }
    return map;
  }

  RecurringPaymentsCompanion toCompanion(bool nullToAbsent) {
    return RecurringPaymentsCompanion(
      id: Value(id),
      merchantName: Value(merchantName),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      expectedAmount: Value(expectedAmount),
      frequency: Value(frequency),
      confidence: Value(confidence),
      status: Value(status),
      nextExpectedDate: nextExpectedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextExpectedDate),
      lastTransactionDate: lastTransactionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTransactionDate),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RecurringPaymentEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringPaymentEntry(
      id: serializer.fromJson<String>(json['id']),
      merchantName: serializer.fromJson<String>(json['merchantName']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      expectedAmount: serializer.fromJson<double>(json['expectedAmount']),
      frequency: serializer.fromJson<String>(json['frequency']),
      confidence: serializer.fromJson<double>(json['confidence']),
      status: serializer.fromJson<String>(json['status']),
      nextExpectedDate:
          serializer.fromJson<DateTime?>(json['nextExpectedDate']),
      lastTransactionDate:
          serializer.fromJson<DateTime?>(json['lastTransactionDate']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'merchantName': serializer.toJson<String>(merchantName),
      'categoryId': serializer.toJson<String?>(categoryId),
      'categoryName': serializer.toJson<String?>(categoryName),
      'expectedAmount': serializer.toJson<double>(expectedAmount),
      'frequency': serializer.toJson<String>(frequency),
      'confidence': serializer.toJson<double>(confidence),
      'status': serializer.toJson<String>(status),
      'nextExpectedDate': serializer.toJson<DateTime?>(nextExpectedDate),
      'lastTransactionDate': serializer.toJson<DateTime?>(lastTransactionDate),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  RecurringPaymentEntry copyWith(
          {String? id,
          String? merchantName,
          Value<String?> categoryId = const Value.absent(),
          Value<String?> categoryName = const Value.absent(),
          double? expectedAmount,
          String? frequency,
          double? confidence,
          String? status,
          Value<DateTime?> nextExpectedDate = const Value.absent(),
          Value<DateTime?> lastTransactionDate = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      RecurringPaymentEntry(
        id: id ?? this.id,
        merchantName: merchantName ?? this.merchantName,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        categoryName:
            categoryName.present ? categoryName.value : this.categoryName,
        expectedAmount: expectedAmount ?? this.expectedAmount,
        frequency: frequency ?? this.frequency,
        confidence: confidence ?? this.confidence,
        status: status ?? this.status,
        nextExpectedDate: nextExpectedDate.present
            ? nextExpectedDate.value
            : this.nextExpectedDate,
        lastTransactionDate: lastTransactionDate.present
            ? lastTransactionDate.value
            : this.lastTransactionDate,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  RecurringPaymentEntry copyWithCompanion(RecurringPaymentsCompanion data) {
    return RecurringPaymentEntry(
      id: data.id.present ? data.id.value : this.id,
      merchantName: data.merchantName.present
          ? data.merchantName.value
          : this.merchantName,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      expectedAmount: data.expectedAmount.present
          ? data.expectedAmount.value
          : this.expectedAmount,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      status: data.status.present ? data.status.value : this.status,
      nextExpectedDate: data.nextExpectedDate.present
          ? data.nextExpectedDate.value
          : this.nextExpectedDate,
      lastTransactionDate: data.lastTransactionDate.present
          ? data.lastTransactionDate.value
          : this.lastTransactionDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPaymentEntry(')
          ..write('id: $id, ')
          ..write('merchantName: $merchantName, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('frequency: $frequency, ')
          ..write('confidence: $confidence, ')
          ..write('status: $status, ')
          ..write('nextExpectedDate: $nextExpectedDate, ')
          ..write('lastTransactionDate: $lastTransactionDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      merchantName,
      categoryId,
      categoryName,
      expectedAmount,
      frequency,
      confidence,
      status,
      nextExpectedDate,
      lastTransactionDate,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringPaymentEntry &&
          other.id == this.id &&
          other.merchantName == this.merchantName &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.expectedAmount == this.expectedAmount &&
          other.frequency == this.frequency &&
          other.confidence == this.confidence &&
          other.status == this.status &&
          other.nextExpectedDate == this.nextExpectedDate &&
          other.lastTransactionDate == this.lastTransactionDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringPaymentsCompanion
    extends UpdateCompanion<RecurringPaymentEntry> {
  final Value<String> id;
  final Value<String> merchantName;
  final Value<String?> categoryId;
  final Value<String?> categoryName;
  final Value<double> expectedAmount;
  final Value<String> frequency;
  final Value<double> confidence;
  final Value<String> status;
  final Value<DateTime?> nextExpectedDate;
  final Value<DateTime?> lastTransactionDate;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const RecurringPaymentsCompanion({
    this.id = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.expectedAmount = const Value.absent(),
    this.frequency = const Value.absent(),
    this.confidence = const Value.absent(),
    this.status = const Value.absent(),
    this.nextExpectedDate = const Value.absent(),
    this.lastTransactionDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required String merchantName,
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    required double expectedAmount,
    required String frequency,
    this.confidence = const Value.absent(),
    required String status,
    this.nextExpectedDate = const Value.absent(),
    this.lastTransactionDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : merchantName = Value(merchantName),
        expectedAmount = Value(expectedAmount),
        frequency = Value(frequency),
        status = Value(status);
  static Insertable<RecurringPaymentEntry> custom({
    Expression<String>? id,
    Expression<String>? merchantName,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<double>? expectedAmount,
    Expression<String>? frequency,
    Expression<double>? confidence,
    Expression<String>? status,
    Expression<int>? nextExpectedDate,
    Expression<int>? lastTransactionDate,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (merchantName != null) 'merchant_name': merchantName,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (expectedAmount != null) 'expected_amount': expectedAmount,
      if (frequency != null) 'frequency': frequency,
      if (confidence != null) 'confidence': confidence,
      if (status != null) 'status': status,
      if (nextExpectedDate != null) 'next_expected_date': nextExpectedDate,
      if (lastTransactionDate != null)
        'last_transaction_date': lastTransactionDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringPaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? merchantName,
      Value<String?>? categoryId,
      Value<String?>? categoryName,
      Value<double>? expectedAmount,
      Value<String>? frequency,
      Value<double>? confidence,
      Value<String>? status,
      Value<DateTime?>? nextExpectedDate,
      Value<DateTime?>? lastTransactionDate,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return RecurringPaymentsCompanion(
      id: id ?? this.id,
      merchantName: merchantName ?? this.merchantName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      expectedAmount: expectedAmount ?? this.expectedAmount,
      frequency: frequency ?? this.frequency,
      confidence: confidence ?? this.confidence,
      status: status ?? this.status,
      nextExpectedDate: nextExpectedDate ?? this.nextExpectedDate,
      lastTransactionDate: lastTransactionDate ?? this.lastTransactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (merchantName.present) {
      map['merchant_name'] = Variable<String>(merchantName.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (expectedAmount.present) {
      map['expected_amount'] = Variable<double>(expectedAmount.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (nextExpectedDate.present) {
      map['next_expected_date'] = Variable<int>($RecurringPaymentsTable
          .$converternextExpectedDaten
          .toSql(nextExpectedDate.value));
    }
    if (lastTransactionDate.present) {
      map['last_transaction_date'] = Variable<int>($RecurringPaymentsTable
          .$converterlastTransactionDaten
          .toSql(lastTransactionDate.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $RecurringPaymentsTable.$convertercreatedAtn.toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
          $RecurringPaymentsTable.$converterupdatedAtn.toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('merchantName: $merchantName, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('frequency: $frequency, ')
          ..write('confidence: $confidence, ')
          ..write('status: $status, ')
          ..write('nextExpectedDate: $nextExpectedDate, ')
          ..write('lastTransactionDate: $lastTransactionDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewItemsTable extends ReviewItems
    with TableInfo<$ReviewItemsTable, ReviewItemsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _suggestedCategoryIdMeta =
      const VerificationMeta('suggestedCategoryId');
  @override
  late final GeneratedColumn<String> suggestedCategoryId =
      GeneratedColumn<String>('suggested_category_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _suggestedCategoryNameMeta =
      const VerificationMeta('suggestedCategoryName');
  @override
  late final GeneratedColumn<String> suggestedCategoryName =
      GeneratedColumn<String>('suggested_category_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _suggestedMerchantMeta =
      const VerificationMeta('suggestedMerchant');
  @override
  late final GeneratedColumn<String> suggestedMerchant =
      GeneratedColumn<String>('suggested_merchant', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($ReviewItemsTable.$convertercreatedAtn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transactionId,
        reason,
        suggestedCategoryId,
        suggestedCategoryName,
        suggestedMerchant,
        confidence,
        explanation,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_items';
  @override
  VerificationContext validateIntegrity(Insertable<ReviewItemsEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('suggested_category_id')) {
      context.handle(
          _suggestedCategoryIdMeta,
          suggestedCategoryId.isAcceptableOrUnknown(
              data['suggested_category_id']!, _suggestedCategoryIdMeta));
    }
    if (data.containsKey('suggested_category_name')) {
      context.handle(
          _suggestedCategoryNameMeta,
          suggestedCategoryName.isAcceptableOrUnknown(
              data['suggested_category_name']!, _suggestedCategoryNameMeta));
    }
    if (data.containsKey('suggested_merchant')) {
      context.handle(
          _suggestedMerchantMeta,
          suggestedMerchant.isAcceptableOrUnknown(
              data['suggested_merchant']!, _suggestedMerchantMeta));
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewItemsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewItemsEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      suggestedCategoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}suggested_category_id']),
      suggestedCategoryName: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}suggested_category_name']),
      suggestedMerchant: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}suggested_merchant']),
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation']),
      createdAt: $ReviewItemsTable.$convertercreatedAtn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
    );
  }

  @override
  $ReviewItemsTable createAlias(String alias) {
    return $ReviewItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
}

class ReviewItemsEntry extends DataClass
    implements Insertable<ReviewItemsEntry> {
  final String id;
  final String transactionId;
  final String reason;
  final String? suggestedCategoryId;
  final String? suggestedCategoryName;
  final String? suggestedMerchant;
  final double confidence;
  final String? explanation;
  final DateTime? createdAt;
  const ReviewItemsEntry(
      {required this.id,
      required this.transactionId,
      required this.reason,
      this.suggestedCategoryId,
      this.suggestedCategoryName,
      this.suggestedMerchant,
      required this.confidence,
      this.explanation,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || suggestedCategoryId != null) {
      map['suggested_category_id'] = Variable<String>(suggestedCategoryId);
    }
    if (!nullToAbsent || suggestedCategoryName != null) {
      map['suggested_category_name'] = Variable<String>(suggestedCategoryName);
    }
    if (!nullToAbsent || suggestedMerchant != null) {
      map['suggested_merchant'] = Variable<String>(suggestedMerchant);
    }
    map['confidence'] = Variable<double>(confidence);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(
          $ReviewItemsTable.$convertercreatedAtn.toSql(createdAt));
    }
    return map;
  }

  ReviewItemsCompanion toCompanion(bool nullToAbsent) {
    return ReviewItemsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      reason: Value(reason),
      suggestedCategoryId: suggestedCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedCategoryId),
      suggestedCategoryName: suggestedCategoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedCategoryName),
      suggestedMerchant: suggestedMerchant == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedMerchant),
      confidence: Value(confidence),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory ReviewItemsEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewItemsEntry(
      id: serializer.fromJson<String>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      reason: serializer.fromJson<String>(json['reason']),
      suggestedCategoryId:
          serializer.fromJson<String?>(json['suggestedCategoryId']),
      suggestedCategoryName:
          serializer.fromJson<String?>(json['suggestedCategoryName']),
      suggestedMerchant:
          serializer.fromJson<String?>(json['suggestedMerchant']),
      confidence: serializer.fromJson<double>(json['confidence']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'reason': serializer.toJson<String>(reason),
      'suggestedCategoryId': serializer.toJson<String?>(suggestedCategoryId),
      'suggestedCategoryName':
          serializer.toJson<String?>(suggestedCategoryName),
      'suggestedMerchant': serializer.toJson<String?>(suggestedMerchant),
      'confidence': serializer.toJson<double>(confidence),
      'explanation': serializer.toJson<String?>(explanation),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  ReviewItemsEntry copyWith(
          {String? id,
          String? transactionId,
          String? reason,
          Value<String?> suggestedCategoryId = const Value.absent(),
          Value<String?> suggestedCategoryName = const Value.absent(),
          Value<String?> suggestedMerchant = const Value.absent(),
          double? confidence,
          Value<String?> explanation = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent()}) =>
      ReviewItemsEntry(
        id: id ?? this.id,
        transactionId: transactionId ?? this.transactionId,
        reason: reason ?? this.reason,
        suggestedCategoryId: suggestedCategoryId.present
            ? suggestedCategoryId.value
            : this.suggestedCategoryId,
        suggestedCategoryName: suggestedCategoryName.present
            ? suggestedCategoryName.value
            : this.suggestedCategoryName,
        suggestedMerchant: suggestedMerchant.present
            ? suggestedMerchant.value
            : this.suggestedMerchant,
        confidence: confidence ?? this.confidence,
        explanation: explanation.present ? explanation.value : this.explanation,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  ReviewItemsEntry copyWithCompanion(ReviewItemsCompanion data) {
    return ReviewItemsEntry(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      reason: data.reason.present ? data.reason.value : this.reason,
      suggestedCategoryId: data.suggestedCategoryId.present
          ? data.suggestedCategoryId.value
          : this.suggestedCategoryId,
      suggestedCategoryName: data.suggestedCategoryName.present
          ? data.suggestedCategoryName.value
          : this.suggestedCategoryName,
      suggestedMerchant: data.suggestedMerchant.present
          ? data.suggestedMerchant.value
          : this.suggestedMerchant,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewItemsEntry(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('reason: $reason, ')
          ..write('suggestedCategoryId: $suggestedCategoryId, ')
          ..write('suggestedCategoryName: $suggestedCategoryName, ')
          ..write('suggestedMerchant: $suggestedMerchant, ')
          ..write('confidence: $confidence, ')
          ..write('explanation: $explanation, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      transactionId,
      reason,
      suggestedCategoryId,
      suggestedCategoryName,
      suggestedMerchant,
      confidence,
      explanation,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewItemsEntry &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.reason == this.reason &&
          other.suggestedCategoryId == this.suggestedCategoryId &&
          other.suggestedCategoryName == this.suggestedCategoryName &&
          other.suggestedMerchant == this.suggestedMerchant &&
          other.confidence == this.confidence &&
          other.explanation == this.explanation &&
          other.createdAt == this.createdAt);
}

class ReviewItemsCompanion extends UpdateCompanion<ReviewItemsEntry> {
  final Value<String> id;
  final Value<String> transactionId;
  final Value<String> reason;
  final Value<String?> suggestedCategoryId;
  final Value<String?> suggestedCategoryName;
  final Value<String?> suggestedMerchant;
  final Value<double> confidence;
  final Value<String?> explanation;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const ReviewItemsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.reason = const Value.absent(),
    this.suggestedCategoryId = const Value.absent(),
    this.suggestedCategoryName = const Value.absent(),
    this.suggestedMerchant = const Value.absent(),
    this.confidence = const Value.absent(),
    this.explanation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewItemsCompanion.insert({
    this.id = const Value.absent(),
    required String transactionId,
    required String reason,
    this.suggestedCategoryId = const Value.absent(),
    this.suggestedCategoryName = const Value.absent(),
    this.suggestedMerchant = const Value.absent(),
    this.confidence = const Value.absent(),
    this.explanation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : transactionId = Value(transactionId),
        reason = Value(reason);
  static Insertable<ReviewItemsEntry> custom({
    Expression<String>? id,
    Expression<String>? transactionId,
    Expression<String>? reason,
    Expression<String>? suggestedCategoryId,
    Expression<String>? suggestedCategoryName,
    Expression<String>? suggestedMerchant,
    Expression<double>? confidence,
    Expression<String>? explanation,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (reason != null) 'reason': reason,
      if (suggestedCategoryId != null)
        'suggested_category_id': suggestedCategoryId,
      if (suggestedCategoryName != null)
        'suggested_category_name': suggestedCategoryName,
      if (suggestedMerchant != null) 'suggested_merchant': suggestedMerchant,
      if (confidence != null) 'confidence': confidence,
      if (explanation != null) 'explanation': explanation,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? transactionId,
      Value<String>? reason,
      Value<String?>? suggestedCategoryId,
      Value<String?>? suggestedCategoryName,
      Value<String?>? suggestedMerchant,
      Value<double>? confidence,
      Value<String?>? explanation,
      Value<DateTime?>? createdAt,
      Value<int>? rowid}) {
    return ReviewItemsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      reason: reason ?? this.reason,
      suggestedCategoryId: suggestedCategoryId ?? this.suggestedCategoryId,
      suggestedCategoryName:
          suggestedCategoryName ?? this.suggestedCategoryName,
      suggestedMerchant: suggestedMerchant ?? this.suggestedMerchant,
      confidence: confidence ?? this.confidence,
      explanation: explanation ?? this.explanation,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (suggestedCategoryId.present) {
      map['suggested_category_id'] =
          Variable<String>(suggestedCategoryId.value);
    }
    if (suggestedCategoryName.present) {
      map['suggested_category_name'] =
          Variable<String>(suggestedCategoryName.value);
    }
    if (suggestedMerchant.present) {
      map['suggested_merchant'] = Variable<String>(suggestedMerchant.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $ReviewItemsTable.$convertercreatedAtn.toSql(createdAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewItemsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('reason: $reason, ')
          ..write('suggestedCategoryId: $suggestedCategoryId, ')
          ..write('suggestedCategoryName: $suggestedCategoryName, ')
          ..write('suggestedMerchant: $suggestedMerchant, ')
          ..write('confidence: $confidence, ')
          ..write('explanation: $explanation, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AgentActionLogsTable extends AgentActionLogs
    with TableInfo<$AgentActionLogsTable, AgentActionLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgentActionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _agentNameMeta =
      const VerificationMeta('agentName');
  @override
  late final GeneratedColumn<String> agentName = GeneratedColumn<String>(
      'agent_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionTypeMeta =
      const VerificationMeta('actionType');
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
      'action_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inputSummaryMeta =
      const VerificationMeta('inputSummary');
  @override
  late final GeneratedColumn<String> inputSummary = GeneratedColumn<String>(
      'input_summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _outputSummaryMeta =
      const VerificationMeta('outputSummary');
  @override
  late final GeneratedColumn<String> outputSummary = GeneratedColumn<String>(
      'output_summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _relatedTransactionIdMeta =
      const VerificationMeta('relatedTransactionId');
  @override
  late final GeneratedColumn<String> relatedTransactionId =
      GeneratedColumn<String>('related_transaction_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _relatedImportBatchIdMeta =
      const VerificationMeta('relatedImportBatchId');
  @override
  late final GeneratedColumn<String> relatedImportBatchId =
      GeneratedColumn<String>('related_import_batch_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($AgentActionLogsTable.$convertercreatedAtn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        agentName,
        actionType,
        inputSummary,
        outputSummary,
        confidence,
        explanation,
        relatedTransactionId,
        relatedImportBatchId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agent_action_logs';
  @override
  VerificationContext validateIntegrity(
      Insertable<AgentActionLogEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('agent_name')) {
      context.handle(_agentNameMeta,
          agentName.isAcceptableOrUnknown(data['agent_name']!, _agentNameMeta));
    } else if (isInserting) {
      context.missing(_agentNameMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
          _actionTypeMeta,
          actionType.isAcceptableOrUnknown(
              data['action_type']!, _actionTypeMeta));
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('input_summary')) {
      context.handle(
          _inputSummaryMeta,
          inputSummary.isAcceptableOrUnknown(
              data['input_summary']!, _inputSummaryMeta));
    }
    if (data.containsKey('output_summary')) {
      context.handle(
          _outputSummaryMeta,
          outputSummary.isAcceptableOrUnknown(
              data['output_summary']!, _outputSummaryMeta));
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    }
    if (data.containsKey('related_transaction_id')) {
      context.handle(
          _relatedTransactionIdMeta,
          relatedTransactionId.isAcceptableOrUnknown(
              data['related_transaction_id']!, _relatedTransactionIdMeta));
    }
    if (data.containsKey('related_import_batch_id')) {
      context.handle(
          _relatedImportBatchIdMeta,
          relatedImportBatchId.isAcceptableOrUnknown(
              data['related_import_batch_id']!, _relatedImportBatchIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AgentActionLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgentActionLogEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      agentName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agent_name'])!,
      actionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_type'])!,
      inputSummary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input_summary']),
      outputSummary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}output_summary']),
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation']),
      relatedTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}related_transaction_id']),
      relatedImportBatchId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}related_import_batch_id']),
      createdAt: $AgentActionLogsTable.$convertercreatedAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
    );
  }

  @override
  $AgentActionLogsTable createAlias(String alias) {
    return $AgentActionLogsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
}

class AgentActionLogEntry extends DataClass
    implements Insertable<AgentActionLogEntry> {
  final String id;
  final String agentName;
  final String actionType;
  final String? inputSummary;
  final String? outputSummary;
  final double confidence;
  final String? explanation;
  final String? relatedTransactionId;
  final String? relatedImportBatchId;
  final DateTime? createdAt;
  const AgentActionLogEntry(
      {required this.id,
      required this.agentName,
      required this.actionType,
      this.inputSummary,
      this.outputSummary,
      required this.confidence,
      this.explanation,
      this.relatedTransactionId,
      this.relatedImportBatchId,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['agent_name'] = Variable<String>(agentName);
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || inputSummary != null) {
      map['input_summary'] = Variable<String>(inputSummary);
    }
    if (!nullToAbsent || outputSummary != null) {
      map['output_summary'] = Variable<String>(outputSummary);
    }
    map['confidence'] = Variable<double>(confidence);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    if (!nullToAbsent || relatedTransactionId != null) {
      map['related_transaction_id'] = Variable<String>(relatedTransactionId);
    }
    if (!nullToAbsent || relatedImportBatchId != null) {
      map['related_import_batch_id'] = Variable<String>(relatedImportBatchId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(
          $AgentActionLogsTable.$convertercreatedAtn.toSql(createdAt));
    }
    return map;
  }

  AgentActionLogsCompanion toCompanion(bool nullToAbsent) {
    return AgentActionLogsCompanion(
      id: Value(id),
      agentName: Value(agentName),
      actionType: Value(actionType),
      inputSummary: inputSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(inputSummary),
      outputSummary: outputSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(outputSummary),
      confidence: Value(confidence),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      relatedTransactionId: relatedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedTransactionId),
      relatedImportBatchId: relatedImportBatchId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedImportBatchId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory AgentActionLogEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgentActionLogEntry(
      id: serializer.fromJson<String>(json['id']),
      agentName: serializer.fromJson<String>(json['agentName']),
      actionType: serializer.fromJson<String>(json['actionType']),
      inputSummary: serializer.fromJson<String?>(json['inputSummary']),
      outputSummary: serializer.fromJson<String?>(json['outputSummary']),
      confidence: serializer.fromJson<double>(json['confidence']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      relatedTransactionId:
          serializer.fromJson<String?>(json['relatedTransactionId']),
      relatedImportBatchId:
          serializer.fromJson<String?>(json['relatedImportBatchId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'agentName': serializer.toJson<String>(agentName),
      'actionType': serializer.toJson<String>(actionType),
      'inputSummary': serializer.toJson<String?>(inputSummary),
      'outputSummary': serializer.toJson<String?>(outputSummary),
      'confidence': serializer.toJson<double>(confidence),
      'explanation': serializer.toJson<String?>(explanation),
      'relatedTransactionId': serializer.toJson<String?>(relatedTransactionId),
      'relatedImportBatchId': serializer.toJson<String?>(relatedImportBatchId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  AgentActionLogEntry copyWith(
          {String? id,
          String? agentName,
          String? actionType,
          Value<String?> inputSummary = const Value.absent(),
          Value<String?> outputSummary = const Value.absent(),
          double? confidence,
          Value<String?> explanation = const Value.absent(),
          Value<String?> relatedTransactionId = const Value.absent(),
          Value<String?> relatedImportBatchId = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent()}) =>
      AgentActionLogEntry(
        id: id ?? this.id,
        agentName: agentName ?? this.agentName,
        actionType: actionType ?? this.actionType,
        inputSummary:
            inputSummary.present ? inputSummary.value : this.inputSummary,
        outputSummary:
            outputSummary.present ? outputSummary.value : this.outputSummary,
        confidence: confidence ?? this.confidence,
        explanation: explanation.present ? explanation.value : this.explanation,
        relatedTransactionId: relatedTransactionId.present
            ? relatedTransactionId.value
            : this.relatedTransactionId,
        relatedImportBatchId: relatedImportBatchId.present
            ? relatedImportBatchId.value
            : this.relatedImportBatchId,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  AgentActionLogEntry copyWithCompanion(AgentActionLogsCompanion data) {
    return AgentActionLogEntry(
      id: data.id.present ? data.id.value : this.id,
      agentName: data.agentName.present ? data.agentName.value : this.agentName,
      actionType:
          data.actionType.present ? data.actionType.value : this.actionType,
      inputSummary: data.inputSummary.present
          ? data.inputSummary.value
          : this.inputSummary,
      outputSummary: data.outputSummary.present
          ? data.outputSummary.value
          : this.outputSummary,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      relatedTransactionId: data.relatedTransactionId.present
          ? data.relatedTransactionId.value
          : this.relatedTransactionId,
      relatedImportBatchId: data.relatedImportBatchId.present
          ? data.relatedImportBatchId.value
          : this.relatedImportBatchId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgentActionLogEntry(')
          ..write('id: $id, ')
          ..write('agentName: $agentName, ')
          ..write('actionType: $actionType, ')
          ..write('inputSummary: $inputSummary, ')
          ..write('outputSummary: $outputSummary, ')
          ..write('confidence: $confidence, ')
          ..write('explanation: $explanation, ')
          ..write('relatedTransactionId: $relatedTransactionId, ')
          ..write('relatedImportBatchId: $relatedImportBatchId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      agentName,
      actionType,
      inputSummary,
      outputSummary,
      confidence,
      explanation,
      relatedTransactionId,
      relatedImportBatchId,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgentActionLogEntry &&
          other.id == this.id &&
          other.agentName == this.agentName &&
          other.actionType == this.actionType &&
          other.inputSummary == this.inputSummary &&
          other.outputSummary == this.outputSummary &&
          other.confidence == this.confidence &&
          other.explanation == this.explanation &&
          other.relatedTransactionId == this.relatedTransactionId &&
          other.relatedImportBatchId == this.relatedImportBatchId &&
          other.createdAt == this.createdAt);
}

class AgentActionLogsCompanion extends UpdateCompanion<AgentActionLogEntry> {
  final Value<String> id;
  final Value<String> agentName;
  final Value<String> actionType;
  final Value<String?> inputSummary;
  final Value<String?> outputSummary;
  final Value<double> confidence;
  final Value<String?> explanation;
  final Value<String?> relatedTransactionId;
  final Value<String?> relatedImportBatchId;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const AgentActionLogsCompanion({
    this.id = const Value.absent(),
    this.agentName = const Value.absent(),
    this.actionType = const Value.absent(),
    this.inputSummary = const Value.absent(),
    this.outputSummary = const Value.absent(),
    this.confidence = const Value.absent(),
    this.explanation = const Value.absent(),
    this.relatedTransactionId = const Value.absent(),
    this.relatedImportBatchId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AgentActionLogsCompanion.insert({
    this.id = const Value.absent(),
    required String agentName,
    required String actionType,
    this.inputSummary = const Value.absent(),
    this.outputSummary = const Value.absent(),
    this.confidence = const Value.absent(),
    this.explanation = const Value.absent(),
    this.relatedTransactionId = const Value.absent(),
    this.relatedImportBatchId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : agentName = Value(agentName),
        actionType = Value(actionType);
  static Insertable<AgentActionLogEntry> custom({
    Expression<String>? id,
    Expression<String>? agentName,
    Expression<String>? actionType,
    Expression<String>? inputSummary,
    Expression<String>? outputSummary,
    Expression<double>? confidence,
    Expression<String>? explanation,
    Expression<String>? relatedTransactionId,
    Expression<String>? relatedImportBatchId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (agentName != null) 'agent_name': agentName,
      if (actionType != null) 'action_type': actionType,
      if (inputSummary != null) 'input_summary': inputSummary,
      if (outputSummary != null) 'output_summary': outputSummary,
      if (confidence != null) 'confidence': confidence,
      if (explanation != null) 'explanation': explanation,
      if (relatedTransactionId != null)
        'related_transaction_id': relatedTransactionId,
      if (relatedImportBatchId != null)
        'related_import_batch_id': relatedImportBatchId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AgentActionLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? agentName,
      Value<String>? actionType,
      Value<String?>? inputSummary,
      Value<String?>? outputSummary,
      Value<double>? confidence,
      Value<String?>? explanation,
      Value<String?>? relatedTransactionId,
      Value<String?>? relatedImportBatchId,
      Value<DateTime?>? createdAt,
      Value<int>? rowid}) {
    return AgentActionLogsCompanion(
      id: id ?? this.id,
      agentName: agentName ?? this.agentName,
      actionType: actionType ?? this.actionType,
      inputSummary: inputSummary ?? this.inputSummary,
      outputSummary: outputSummary ?? this.outputSummary,
      confidence: confidence ?? this.confidence,
      explanation: explanation ?? this.explanation,
      relatedTransactionId: relatedTransactionId ?? this.relatedTransactionId,
      relatedImportBatchId: relatedImportBatchId ?? this.relatedImportBatchId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (agentName.present) {
      map['agent_name'] = Variable<String>(agentName.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (inputSummary.present) {
      map['input_summary'] = Variable<String>(inputSummary.value);
    }
    if (outputSummary.present) {
      map['output_summary'] = Variable<String>(outputSummary.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (relatedTransactionId.present) {
      map['related_transaction_id'] =
          Variable<String>(relatedTransactionId.value);
    }
    if (relatedImportBatchId.present) {
      map['related_import_batch_id'] =
          Variable<String>(relatedImportBatchId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $AgentActionLogsTable.$convertercreatedAtn.toSql(createdAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgentActionLogsCompanion(')
          ..write('id: $id, ')
          ..write('agentName: $agentName, ')
          ..write('actionType: $actionType, ')
          ..write('inputSummary: $inputSummary, ')
          ..write('outputSummary: $outputSummary, ')
          ..write('confidence: $confidence, ')
          ..write('explanation: $explanation, ')
          ..write('relatedTransactionId: $relatedTransactionId, ')
          ..write('relatedImportBatchId: $relatedImportBatchId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => 'default');
  static const VerificationMeta _appLockEnabledMeta =
      const VerificationMeta('appLockEnabled');
  @override
  late final GeneratedColumn<int> appLockEnabled = GeneratedColumn<int>(
      'app_lock_enabled', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('INR'));
  static const VerificationMeta _firstLaunchCompletedMeta =
      const VerificationMeta('firstLaunchCompleted');
  @override
  late final GeneratedColumn<int> firstLaunchCompleted = GeneratedColumn<int>(
      'first_launch_completed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _privacyModeEnabledMeta =
      const VerificationMeta('privacyModeEnabled');
  @override
  late final GeneratedColumn<int> privacyModeEnabled = GeneratedColumn<int>(
      'privacy_mode_enabled', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _debugModeEnabledMeta =
      const VerificationMeta('debugModeEnabled');
  @override
  late final GeneratedColumn<int> debugModeEnabled = GeneratedColumn<int>(
      'debug_mode_enabled', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $UserSettingsTableTable.$convertercreatedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $UserSettingsTableTable.$converterupdatedAtn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        appLockEnabled,
        currency,
        firstLaunchCompleted,
        privacyModeEnabled,
        debugModeEnabled,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserSettingsEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('app_lock_enabled')) {
      context.handle(
          _appLockEnabledMeta,
          appLockEnabled.isAcceptableOrUnknown(
              data['app_lock_enabled']!, _appLockEnabledMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('first_launch_completed')) {
      context.handle(
          _firstLaunchCompletedMeta,
          firstLaunchCompleted.isAcceptableOrUnknown(
              data['first_launch_completed']!, _firstLaunchCompletedMeta));
    }
    if (data.containsKey('privacy_mode_enabled')) {
      context.handle(
          _privacyModeEnabledMeta,
          privacyModeEnabled.isAcceptableOrUnknown(
              data['privacy_mode_enabled']!, _privacyModeEnabledMeta));
    }
    if (data.containsKey('debug_mode_enabled')) {
      context.handle(
          _debugModeEnabledMeta,
          debugModeEnabled.isAcceptableOrUnknown(
              data['debug_mode_enabled']!, _debugModeEnabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      appLockEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}app_lock_enabled'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      firstLaunchCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}first_launch_completed'])!,
      privacyModeEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}privacy_mode_enabled'])!,
      debugModeEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}debug_mode_enabled'])!,
      createdAt: $UserSettingsTableTable.$convertercreatedAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
      updatedAt: $UserSettingsTableTable.$converterupdatedAtn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])),
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterupdatedAtn =
      NullAwareTypeConverter.wrap($converterupdatedAt);
}

class UserSettingsEntry extends DataClass
    implements Insertable<UserSettingsEntry> {
  final String id;
  final int appLockEnabled;
  final String currency;
  final int firstLaunchCompleted;
  final int privacyModeEnabled;
  final int debugModeEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const UserSettingsEntry(
      {required this.id,
      required this.appLockEnabled,
      required this.currency,
      required this.firstLaunchCompleted,
      required this.privacyModeEnabled,
      required this.debugModeEnabled,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['app_lock_enabled'] = Variable<int>(appLockEnabled);
    map['currency'] = Variable<String>(currency);
    map['first_launch_completed'] = Variable<int>(firstLaunchCompleted);
    map['privacy_mode_enabled'] = Variable<int>(privacyModeEnabled);
    map['debug_mode_enabled'] = Variable<int>(debugModeEnabled);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(
          $UserSettingsTableTable.$convertercreatedAtn.toSql(createdAt));
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(
          $UserSettingsTableTable.$converterupdatedAtn.toSql(updatedAt));
    }
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      id: Value(id),
      appLockEnabled: Value(appLockEnabled),
      currency: Value(currency),
      firstLaunchCompleted: Value(firstLaunchCompleted),
      privacyModeEnabled: Value(privacyModeEnabled),
      debugModeEnabled: Value(debugModeEnabled),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserSettingsEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsEntry(
      id: serializer.fromJson<String>(json['id']),
      appLockEnabled: serializer.fromJson<int>(json['appLockEnabled']),
      currency: serializer.fromJson<String>(json['currency']),
      firstLaunchCompleted:
          serializer.fromJson<int>(json['firstLaunchCompleted']),
      privacyModeEnabled: serializer.fromJson<int>(json['privacyModeEnabled']),
      debugModeEnabled: serializer.fromJson<int>(json['debugModeEnabled']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appLockEnabled': serializer.toJson<int>(appLockEnabled),
      'currency': serializer.toJson<String>(currency),
      'firstLaunchCompleted': serializer.toJson<int>(firstLaunchCompleted),
      'privacyModeEnabled': serializer.toJson<int>(privacyModeEnabled),
      'debugModeEnabled': serializer.toJson<int>(debugModeEnabled),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  UserSettingsEntry copyWith(
          {String? id,
          int? appLockEnabled,
          String? currency,
          int? firstLaunchCompleted,
          int? privacyModeEnabled,
          int? debugModeEnabled,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      UserSettingsEntry(
        id: id ?? this.id,
        appLockEnabled: appLockEnabled ?? this.appLockEnabled,
        currency: currency ?? this.currency,
        firstLaunchCompleted: firstLaunchCompleted ?? this.firstLaunchCompleted,
        privacyModeEnabled: privacyModeEnabled ?? this.privacyModeEnabled,
        debugModeEnabled: debugModeEnabled ?? this.debugModeEnabled,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  UserSettingsEntry copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsEntry(
      id: data.id.present ? data.id.value : this.id,
      appLockEnabled: data.appLockEnabled.present
          ? data.appLockEnabled.value
          : this.appLockEnabled,
      currency: data.currency.present ? data.currency.value : this.currency,
      firstLaunchCompleted: data.firstLaunchCompleted.present
          ? data.firstLaunchCompleted.value
          : this.firstLaunchCompleted,
      privacyModeEnabled: data.privacyModeEnabled.present
          ? data.privacyModeEnabled.value
          : this.privacyModeEnabled,
      debugModeEnabled: data.debugModeEnabled.present
          ? data.debugModeEnabled.value
          : this.debugModeEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsEntry(')
          ..write('id: $id, ')
          ..write('appLockEnabled: $appLockEnabled, ')
          ..write('currency: $currency, ')
          ..write('firstLaunchCompleted: $firstLaunchCompleted, ')
          ..write('privacyModeEnabled: $privacyModeEnabled, ')
          ..write('debugModeEnabled: $debugModeEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      appLockEnabled,
      currency,
      firstLaunchCompleted,
      privacyModeEnabled,
      debugModeEnabled,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsEntry &&
          other.id == this.id &&
          other.appLockEnabled == this.appLockEnabled &&
          other.currency == this.currency &&
          other.firstLaunchCompleted == this.firstLaunchCompleted &&
          other.privacyModeEnabled == this.privacyModeEnabled &&
          other.debugModeEnabled == this.debugModeEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserSettingsTableCompanion extends UpdateCompanion<UserSettingsEntry> {
  final Value<String> id;
  final Value<int> appLockEnabled;
  final Value<String> currency;
  final Value<int> firstLaunchCompleted;
  final Value<int> privacyModeEnabled;
  final Value<int> debugModeEnabled;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const UserSettingsTableCompanion({
    this.id = const Value.absent(),
    this.appLockEnabled = const Value.absent(),
    this.currency = const Value.absent(),
    this.firstLaunchCompleted = const Value.absent(),
    this.privacyModeEnabled = const Value.absent(),
    this.debugModeEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.appLockEnabled = const Value.absent(),
    this.currency = const Value.absent(),
    this.firstLaunchCompleted = const Value.absent(),
    this.privacyModeEnabled = const Value.absent(),
    this.debugModeEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<UserSettingsEntry> custom({
    Expression<String>? id,
    Expression<int>? appLockEnabled,
    Expression<String>? currency,
    Expression<int>? firstLaunchCompleted,
    Expression<int>? privacyModeEnabled,
    Expression<int>? debugModeEnabled,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appLockEnabled != null) 'app_lock_enabled': appLockEnabled,
      if (currency != null) 'currency': currency,
      if (firstLaunchCompleted != null)
        'first_launch_completed': firstLaunchCompleted,
      if (privacyModeEnabled != null)
        'privacy_mode_enabled': privacyModeEnabled,
      if (debugModeEnabled != null) 'debug_mode_enabled': debugModeEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsTableCompanion copyWith(
      {Value<String>? id,
      Value<int>? appLockEnabled,
      Value<String>? currency,
      Value<int>? firstLaunchCompleted,
      Value<int>? privacyModeEnabled,
      Value<int>? debugModeEnabled,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return UserSettingsTableCompanion(
      id: id ?? this.id,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      currency: currency ?? this.currency,
      firstLaunchCompleted: firstLaunchCompleted ?? this.firstLaunchCompleted,
      privacyModeEnabled: privacyModeEnabled ?? this.privacyModeEnabled,
      debugModeEnabled: debugModeEnabled ?? this.debugModeEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appLockEnabled.present) {
      map['app_lock_enabled'] = Variable<int>(appLockEnabled.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (firstLaunchCompleted.present) {
      map['first_launch_completed'] = Variable<int>(firstLaunchCompleted.value);
    }
    if (privacyModeEnabled.present) {
      map['privacy_mode_enabled'] = Variable<int>(privacyModeEnabled.value);
    }
    if (debugModeEnabled.present) {
      map['debug_mode_enabled'] = Variable<int>(debugModeEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $UserSettingsTableTable.$convertercreatedAtn.toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
          $UserSettingsTableTable.$converterupdatedAtn.toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('appLockEnabled: $appLockEnabled, ')
          ..write('currency: $currency, ')
          ..write('firstLaunchCompleted: $firstLaunchCompleted, ')
          ..write('privacyModeEnabled: $privacyModeEnabled, ')
          ..write('debugModeEnabled: $debugModeEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionLabelsTable extends TransactionLabels
    with TableInfo<$TransactionLabelsTable, TransactionLabelEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionLabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF9E9E9E));
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<int> isSystem = GeneratedColumn<int>(
      'is_system', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, color, isSystem];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_labels';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionLabelEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionLabelEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionLabelEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_system'])!,
    );
  }

  @override
  $TransactionLabelsTable createAlias(String alias) {
    return $TransactionLabelsTable(attachedDatabase, alias);
  }
}

class TransactionLabelEntry extends DataClass
    implements Insertable<TransactionLabelEntry> {
  final String id;
  final String name;
  final int color;
  final int isSystem;
  const TransactionLabelEntry(
      {required this.id,
      required this.name,
      required this.color,
      required this.isSystem});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['is_system'] = Variable<int>(isSystem);
    return map;
  }

  TransactionLabelsCompanion toCompanion(bool nullToAbsent) {
    return TransactionLabelsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      isSystem: Value(isSystem),
    );
  }

  factory TransactionLabelEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionLabelEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      isSystem: serializer.fromJson<int>(json['isSystem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'isSystem': serializer.toJson<int>(isSystem),
    };
  }

  TransactionLabelEntry copyWith(
          {String? id, String? name, int? color, int? isSystem}) =>
      TransactionLabelEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        isSystem: isSystem ?? this.isSystem,
      );
  TransactionLabelEntry copyWithCompanion(TransactionLabelsCompanion data) {
    return TransactionLabelEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionLabelEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isSystem: $isSystem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, isSystem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionLabelEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.isSystem == this.isSystem);
}

class TransactionLabelsCompanion
    extends UpdateCompanion<TransactionLabelEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> color;
  final Value<int> isSystem;
  final Value<int> rowid;
  const TransactionLabelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionLabelsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TransactionLabelEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? isSystem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (isSystem != null) 'is_system': isSystem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionLabelsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? color,
      Value<int>? isSystem,
      Value<int>? rowid}) {
    return TransactionLabelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      isSystem: isSystem ?? this.isSystem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<int>(isSystem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionLabelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isSystem: $isSystem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditCardsTable extends CreditCards
    with TableInfo<$CreditCardsTable, CreditCardEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _issuerMeta = const VerificationMeta('issuer');
  @override
  late final GeneratedColumn<String> issuer = GeneratedColumn<String>(
      'issuer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastFourMeta =
      const VerificationMeta('lastFour');
  @override
  late final GeneratedColumn<String> lastFour = GeneratedColumn<String>(
      'last_four', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creditLimitMeta =
      const VerificationMeta('creditLimit');
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
      'credit_limit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _availableCreditMeta =
      const VerificationMeta('availableCredit');
  @override
  late final GeneratedColumn<double> availableCredit = GeneratedColumn<double>(
      'available_credit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _billingDayMeta =
      const VerificationMeta('billingDay');
  @override
  late final GeneratedColumn<int> billingDay = GeneratedColumn<int>(
      'billing_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
      'due_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(15));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
      'is_active', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($CreditCardsTable.$convertercreatedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($CreditCardsTable.$converterupdatedAtn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        issuer,
        lastFour,
        creditLimit,
        availableCredit,
        billingDay,
        dueDay,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_cards';
  @override
  VerificationContext validateIntegrity(Insertable<CreditCardEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('issuer')) {
      context.handle(_issuerMeta,
          issuer.isAcceptableOrUnknown(data['issuer']!, _issuerMeta));
    }
    if (data.containsKey('last_four')) {
      context.handle(_lastFourMeta,
          lastFour.isAcceptableOrUnknown(data['last_four']!, _lastFourMeta));
    } else if (isInserting) {
      context.missing(_lastFourMeta);
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
          _creditLimitMeta,
          creditLimit.isAcceptableOrUnknown(
              data['credit_limit']!, _creditLimitMeta));
    } else if (isInserting) {
      context.missing(_creditLimitMeta);
    }
    if (data.containsKey('available_credit')) {
      context.handle(
          _availableCreditMeta,
          availableCredit.isAcceptableOrUnknown(
              data['available_credit']!, _availableCreditMeta));
    }
    if (data.containsKey('billing_day')) {
      context.handle(
          _billingDayMeta,
          billingDay.isAcceptableOrUnknown(
              data['billing_day']!, _billingDayMeta));
    }
    if (data.containsKey('due_day')) {
      context.handle(_dueDayMeta,
          dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditCardEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditCardEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      issuer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}issuer']),
      lastFour: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_four'])!,
      creditLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_limit'])!,
      availableCredit: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}available_credit'])!,
      billingDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}billing_day'])!,
      dueDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_day'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_active'])!,
      createdAt: $CreditCardsTable.$convertercreatedAtn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
      updatedAt: $CreditCardsTable.$converterupdatedAtn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])),
    );
  }

  @override
  $CreditCardsTable createAlias(String alias) {
    return $CreditCardsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterupdatedAtn =
      NullAwareTypeConverter.wrap($converterupdatedAt);
}

class CreditCardEntry extends DataClass implements Insertable<CreditCardEntry> {
  final String id;
  final String name;
  final String? issuer;
  final String lastFour;
  final double creditLimit;
  final double availableCredit;
  final int billingDay;
  final int dueDay;
  final int isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const CreditCardEntry(
      {required this.id,
      required this.name,
      this.issuer,
      required this.lastFour,
      required this.creditLimit,
      required this.availableCredit,
      required this.billingDay,
      required this.dueDay,
      required this.isActive,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || issuer != null) {
      map['issuer'] = Variable<String>(issuer);
    }
    map['last_four'] = Variable<String>(lastFour);
    map['credit_limit'] = Variable<double>(creditLimit);
    map['available_credit'] = Variable<double>(availableCredit);
    map['billing_day'] = Variable<int>(billingDay);
    map['due_day'] = Variable<int>(dueDay);
    map['is_active'] = Variable<int>(isActive);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(
          $CreditCardsTable.$convertercreatedAtn.toSql(createdAt));
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(
          $CreditCardsTable.$converterupdatedAtn.toSql(updatedAt));
    }
    return map;
  }

  CreditCardsCompanion toCompanion(bool nullToAbsent) {
    return CreditCardsCompanion(
      id: Value(id),
      name: Value(name),
      issuer:
          issuer == null && nullToAbsent ? const Value.absent() : Value(issuer),
      lastFour: Value(lastFour),
      creditLimit: Value(creditLimit),
      availableCredit: Value(availableCredit),
      billingDay: Value(billingDay),
      dueDay: Value(dueDay),
      isActive: Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory CreditCardEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditCardEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      issuer: serializer.fromJson<String?>(json['issuer']),
      lastFour: serializer.fromJson<String>(json['lastFour']),
      creditLimit: serializer.fromJson<double>(json['creditLimit']),
      availableCredit: serializer.fromJson<double>(json['availableCredit']),
      billingDay: serializer.fromJson<int>(json['billingDay']),
      dueDay: serializer.fromJson<int>(json['dueDay']),
      isActive: serializer.fromJson<int>(json['isActive']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'issuer': serializer.toJson<String?>(issuer),
      'lastFour': serializer.toJson<String>(lastFour),
      'creditLimit': serializer.toJson<double>(creditLimit),
      'availableCredit': serializer.toJson<double>(availableCredit),
      'billingDay': serializer.toJson<int>(billingDay),
      'dueDay': serializer.toJson<int>(dueDay),
      'isActive': serializer.toJson<int>(isActive),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  CreditCardEntry copyWith(
          {String? id,
          String? name,
          Value<String?> issuer = const Value.absent(),
          String? lastFour,
          double? creditLimit,
          double? availableCredit,
          int? billingDay,
          int? dueDay,
          int? isActive,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      CreditCardEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        issuer: issuer.present ? issuer.value : this.issuer,
        lastFour: lastFour ?? this.lastFour,
        creditLimit: creditLimit ?? this.creditLimit,
        availableCredit: availableCredit ?? this.availableCredit,
        billingDay: billingDay ?? this.billingDay,
        dueDay: dueDay ?? this.dueDay,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  CreditCardEntry copyWithCompanion(CreditCardsCompanion data) {
    return CreditCardEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      issuer: data.issuer.present ? data.issuer.value : this.issuer,
      lastFour: data.lastFour.present ? data.lastFour.value : this.lastFour,
      creditLimit:
          data.creditLimit.present ? data.creditLimit.value : this.creditLimit,
      availableCredit: data.availableCredit.present
          ? data.availableCredit.value
          : this.availableCredit,
      billingDay:
          data.billingDay.present ? data.billingDay.value : this.billingDay,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('issuer: $issuer, ')
          ..write('lastFour: $lastFour, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('availableCredit: $availableCredit, ')
          ..write('billingDay: $billingDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, issuer, lastFour, creditLimit,
      availableCredit, billingDay, dueDay, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditCardEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.issuer == this.issuer &&
          other.lastFour == this.lastFour &&
          other.creditLimit == this.creditLimit &&
          other.availableCredit == this.availableCredit &&
          other.billingDay == this.billingDay &&
          other.dueDay == this.dueDay &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CreditCardsCompanion extends UpdateCompanion<CreditCardEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> issuer;
  final Value<String> lastFour;
  final Value<double> creditLimit;
  final Value<double> availableCredit;
  final Value<int> billingDay;
  final Value<int> dueDay;
  final Value<int> isActive;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const CreditCardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.issuer = const Value.absent(),
    this.lastFour = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.availableCredit = const Value.absent(),
    this.billingDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditCardsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.issuer = const Value.absent(),
    required String lastFour,
    required double creditLimit,
    this.availableCredit = const Value.absent(),
    this.billingDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        lastFour = Value(lastFour),
        creditLimit = Value(creditLimit);
  static Insertable<CreditCardEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? issuer,
    Expression<String>? lastFour,
    Expression<double>? creditLimit,
    Expression<double>? availableCredit,
    Expression<int>? billingDay,
    Expression<int>? dueDay,
    Expression<int>? isActive,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (issuer != null) 'issuer': issuer,
      if (lastFour != null) 'last_four': lastFour,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (availableCredit != null) 'available_credit': availableCredit,
      if (billingDay != null) 'billing_day': billingDay,
      if (dueDay != null) 'due_day': dueDay,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditCardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? issuer,
      Value<String>? lastFour,
      Value<double>? creditLimit,
      Value<double>? availableCredit,
      Value<int>? billingDay,
      Value<int>? dueDay,
      Value<int>? isActive,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return CreditCardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      lastFour: lastFour ?? this.lastFour,
      creditLimit: creditLimit ?? this.creditLimit,
      availableCredit: availableCredit ?? this.availableCredit,
      billingDay: billingDay ?? this.billingDay,
      dueDay: dueDay ?? this.dueDay,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (issuer.present) {
      map['issuer'] = Variable<String>(issuer.value);
    }
    if (lastFour.present) {
      map['last_four'] = Variable<String>(lastFour.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (availableCredit.present) {
      map['available_credit'] = Variable<double>(availableCredit.value);
    }
    if (billingDay.present) {
      map['billing_day'] = Variable<int>(billingDay.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $CreditCardsTable.$convertercreatedAtn.toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
          $CreditCardsTable.$converterupdatedAtn.toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('issuer: $issuer, ')
          ..write('lastFour: $lastFour, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('availableCredit: $availableCredit, ')
          ..write('billingDay: $billingDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bankNameMeta =
      const VerificationMeta('bankName');
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
      'bank_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('INR'));
  static const VerificationMeta _lastFourMeta =
      const VerificationMeta('lastFour');
  @override
  late final GeneratedColumn<String> lastFour = GeneratedColumn<String>(
      'last_four', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
      'is_active', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> createdAt =
      GeneratedColumn<int>('created_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($AccountsTable.$convertercreatedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> updatedAt =
      GeneratedColumn<int>('updated_at', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<DateTime?>($AccountsTable.$converterupdatedAtn);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        bankName,
        type,
        balance,
        currency,
        lastFour,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<AccountEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(_bankNameMeta,
          bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('last_four')) {
      context.handle(_lastFourMeta,
          lastFour.isAcceptableOrUnknown(data['last_four']!, _lastFourMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      bankName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_name']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      lastFour: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_four']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_active'])!,
      createdAt: $AccountsTable.$convertercreatedAtn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])),
      updatedAt: $AccountsTable.$converterupdatedAtn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])),
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $convertercreatedAtn =
      NullAwareTypeConverter.wrap($convertercreatedAt);
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeConverter();
  static TypeConverter<DateTime?, int?> $converterupdatedAtn =
      NullAwareTypeConverter.wrap($converterupdatedAt);
}

class AccountEntry extends DataClass implements Insertable<AccountEntry> {
  final String id;
  final String name;
  final String? bankName;
  final String type;
  final double balance;
  final String currency;
  final String? lastFour;
  final int isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const AccountEntry(
      {required this.id,
      required this.name,
      this.bankName,
      required this.type,
      required this.balance,
      required this.currency,
      this.lastFour,
      required this.isActive,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    map['type'] = Variable<String>(type);
    map['balance'] = Variable<double>(balance);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || lastFour != null) {
      map['last_four'] = Variable<String>(lastFour);
    }
    map['is_active'] = Variable<int>(isActive);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] =
          Variable<int>($AccountsTable.$convertercreatedAtn.toSql(createdAt));
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] =
          Variable<int>($AccountsTable.$converterupdatedAtn.toSql(updatedAt));
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      type: Value(type),
      balance: Value(balance),
      currency: Value(currency),
      lastFour: lastFour == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFour),
      isActive: Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory AccountEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      type: serializer.fromJson<String>(json['type']),
      balance: serializer.fromJson<double>(json['balance']),
      currency: serializer.fromJson<String>(json['currency']),
      lastFour: serializer.fromJson<String?>(json['lastFour']),
      isActive: serializer.fromJson<int>(json['isActive']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'bankName': serializer.toJson<String?>(bankName),
      'type': serializer.toJson<String>(type),
      'balance': serializer.toJson<double>(balance),
      'currency': serializer.toJson<String>(currency),
      'lastFour': serializer.toJson<String?>(lastFour),
      'isActive': serializer.toJson<int>(isActive),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  AccountEntry copyWith(
          {String? id,
          String? name,
          Value<String?> bankName = const Value.absent(),
          String? type,
          double? balance,
          String? currency,
          Value<String?> lastFour = const Value.absent(),
          int? isActive,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      AccountEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        bankName: bankName.present ? bankName.value : this.bankName,
        type: type ?? this.type,
        balance: balance ?? this.balance,
        currency: currency ?? this.currency,
        lastFour: lastFour.present ? lastFour.value : this.lastFour,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  AccountEntry copyWithCompanion(AccountsCompanion data) {
    return AccountEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      type: data.type.present ? data.type.value : this.type,
      balance: data.balance.present ? data.balance.value : this.balance,
      currency: data.currency.present ? data.currency.value : this.currency,
      lastFour: data.lastFour.present ? data.lastFour.value : this.lastFour,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bankName: $bankName, ')
          ..write('type: $type, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('lastFour: $lastFour, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, bankName, type, balance, currency,
      lastFour, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.bankName == this.bankName &&
          other.type == this.type &&
          other.balance == this.balance &&
          other.currency == this.currency &&
          other.lastFour == this.lastFour &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsCompanion extends UpdateCompanion<AccountEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> bankName;
  final Value<String> type;
  final Value<double> balance;
  final Value<String> currency;
  final Value<String?> lastFour;
  final Value<int> isActive;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bankName = const Value.absent(),
    this.type = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.lastFour = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.bankName = const Value.absent(),
    required String type,
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.lastFour = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        type = Value(type);
  static Insertable<AccountEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? bankName,
    Expression<String>? type,
    Expression<double>? balance,
    Expression<String>? currency,
    Expression<String>? lastFour,
    Expression<int>? isActive,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bankName != null) 'bank_name': bankName,
      if (type != null) 'type': type,
      if (balance != null) 'balance': balance,
      if (currency != null) 'currency': currency,
      if (lastFour != null) 'last_four': lastFour,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? bankName,
      Value<String>? type,
      Value<double>? balance,
      Value<String>? currency,
      Value<String?>? lastFour,
      Value<int>? isActive,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bankName: bankName ?? this.bankName,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      lastFour: lastFour ?? this.lastFour,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (lastFour.present) {
      map['last_four'] = Variable<String>(lastFour.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
          $AccountsTable.$convertercreatedAtn.toSql(createdAt.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
          $AccountsTable.$converterupdatedAtn.toSql(updatedAt.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bankName: $bankName, ')
          ..write('type: $type, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('lastFour: $lastFour, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ImportBatchesTable importBatches = $ImportBatchesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $CategorizationRulesTable categorizationRules =
      $CategorizationRulesTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $RecurringPaymentsTable recurringPayments =
      $RecurringPaymentsTable(this);
  late final $ReviewItemsTable reviewItems = $ReviewItemsTable(this);
  late final $AgentActionLogsTable agentActionLogs =
      $AgentActionLogsTable(this);
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  late final $TransactionLabelsTable transactionLabels =
      $TransactionLabelsTable(this);
  late final $CreditCardsTable creditCards = $CreditCardsTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        importBatches,
        categories,
        transactions,
        categorizationRules,
        budgets,
        recurringPayments,
        reviewItems,
        agentActionLogs,
        userSettingsTable,
        transactionLabels,
        creditCards,
        accounts
      ];
}

typedef $$ImportBatchesTableCreateCompanionBuilder = ImportBatchesCompanion
    Function({
  Value<String> id,
  required String fileName,
  required String fileType,
  Value<DateTime?> importedAt,
  required String parserVersion,
  required String status,
  Value<int> totalRows,
  Value<int> importedCount,
  Value<int> duplicateCount,
  Value<int> failedCount,
  Value<int> reviewCount,
  Value<int> rowid,
});
typedef $$ImportBatchesTableUpdateCompanionBuilder = ImportBatchesCompanion
    Function({
  Value<String> id,
  Value<String> fileName,
  Value<String> fileType,
  Value<DateTime?> importedAt,
  Value<String> parserVersion,
  Value<String> status,
  Value<int> totalRows,
  Value<int> importedCount,
  Value<int> duplicateCount,
  Value<int> failedCount,
  Value<int> reviewCount,
  Value<int> rowid,
});

final class $$ImportBatchesTableReferences extends BaseReferences<_$AppDatabase,
    $ImportBatchesTable, ImportBatchEntry> {
  $$ImportBatchesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<TransactionEntry>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: 'import_batches__id__transactions__import_batch_id');

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter(
            (f) => f.importBatchId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ImportBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get importedAt =>
      $composableBuilder(
          column: $table.importedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get parserVersion => $composableBuilder(
      column: $table.parserVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalRows => $composableBuilder(
      column: $table.totalRows, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get importedCount => $composableBuilder(
      column: $table.importedCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duplicateCount => $composableBuilder(
      column: $table.duplicateCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get failedCount => $composableBuilder(
      column: $table.failedCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.importBatchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ImportBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get importedAt => $composableBuilder(
      column: $table.importedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parserVersion => $composableBuilder(
      column: $table.parserVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalRows => $composableBuilder(
      column: $table.totalRows, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get importedCount => $composableBuilder(
      column: $table.importedCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duplicateCount => $composableBuilder(
      column: $table.duplicateCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get failedCount => $composableBuilder(
      column: $table.failedCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnOrderings(column));
}

class $$ImportBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get importedAt =>
      $composableBuilder(
          column: $table.importedAt, builder: (column) => column);

  GeneratedColumn<String> get parserVersion => $composableBuilder(
      column: $table.parserVersion, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalRows =>
      $composableBuilder(column: $table.totalRows, builder: (column) => column);

  GeneratedColumn<int> get importedCount => $composableBuilder(
      column: $table.importedCount, builder: (column) => column);

  GeneratedColumn<int> get duplicateCount => $composableBuilder(
      column: $table.duplicateCount, builder: (column) => column);

  GeneratedColumn<int> get failedCount => $composableBuilder(
      column: $table.failedCount, builder: (column) => column);

  GeneratedColumn<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.importBatchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ImportBatchesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ImportBatchesTable,
    ImportBatchEntry,
    $$ImportBatchesTableFilterComposer,
    $$ImportBatchesTableOrderingComposer,
    $$ImportBatchesTableAnnotationComposer,
    $$ImportBatchesTableCreateCompanionBuilder,
    $$ImportBatchesTableUpdateCompanionBuilder,
    (ImportBatchEntry, $$ImportBatchesTableReferences),
    ImportBatchEntry,
    PrefetchHooks Function({bool transactionsRefs})> {
  $$ImportBatchesTableTableManager(_$AppDatabase db, $ImportBatchesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> fileType = const Value.absent(),
            Value<DateTime?> importedAt = const Value.absent(),
            Value<String> parserVersion = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> totalRows = const Value.absent(),
            Value<int> importedCount = const Value.absent(),
            Value<int> duplicateCount = const Value.absent(),
            Value<int> failedCount = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ImportBatchesCompanion(
            id: id,
            fileName: fileName,
            fileType: fileType,
            importedAt: importedAt,
            parserVersion: parserVersion,
            status: status,
            totalRows: totalRows,
            importedCount: importedCount,
            duplicateCount: duplicateCount,
            failedCount: failedCount,
            reviewCount: reviewCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String fileName,
            required String fileType,
            Value<DateTime?> importedAt = const Value.absent(),
            required String parserVersion,
            required String status,
            Value<int> totalRows = const Value.absent(),
            Value<int> importedCount = const Value.absent(),
            Value<int> duplicateCount = const Value.absent(),
            Value<int> failedCount = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ImportBatchesCompanion.insert(
            id: id,
            fileName: fileName,
            fileType: fileType,
            importedAt: importedAt,
            parserVersion: parserVersion,
            status: status,
            totalRows: totalRows,
            importedCount: importedCount,
            duplicateCount: duplicateCount,
            failedCount: failedCount,
            reviewCount: reviewCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ImportBatchesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<ImportBatchEntry,
                            $ImportBatchesTable, TransactionEntry>(
                        currentTable: table,
                        referencedTable: $$ImportBatchesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ImportBatchesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.importBatchId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ImportBatchesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ImportBatchesTable,
    ImportBatchEntry,
    $$ImportBatchesTableFilterComposer,
    $$ImportBatchesTableOrderingComposer,
    $$ImportBatchesTableAnnotationComposer,
    $$ImportBatchesTableCreateCompanionBuilder,
    $$ImportBatchesTableUpdateCompanionBuilder,
    (ImportBatchEntry, $$ImportBatchesTableReferences),
    ImportBatchEntry,
    PrefetchHooks Function({bool transactionsRefs})>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  required String name,
  Value<String?> parentCategoryId,
  required String icon,
  required String type,
  Value<int> isSystem,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> parentCategoryId,
  Value<String> icon,
  Value<String> type,
  Value<int> isSystem,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryEntry> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentCategoryIdTable(_$AppDatabase db) =>
      db.categories
          .createAlias('categories__parent_category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get parentCategoryId {
    final $_column = $_itemColumn<String>('parent_category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionsTable, List<TransactionEntry>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: 'categories__id__transactions__category_id');

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$CategoriesTableFilterComposer get parentCategoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentCategoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get parentCategoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentCategoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get parentCategoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentCategoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    CategoryEntry,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (CategoryEntry, $$CategoriesTableReferences),
    CategoryEntry,
    PrefetchHooks Function({bool parentCategoryId, bool transactionsRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> parentCategoryId = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> isSystem = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            parentCategoryId: parentCategoryId,
            icon: icon,
            type: type,
            isSystem: isSystem,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String?> parentCategoryId = const Value.absent(),
            required String icon,
            required String type,
            Value<int> isSystem = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            parentCategoryId: parentCategoryId,
            icon: icon,
            type: type,
            isSystem: isSystem,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {parentCategoryId = false, transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: <
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
                      dynamic>>(state) {
                if (parentCategoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentCategoryId,
                    referencedTable:
                        $$CategoriesTableReferences._parentCategoryIdTable(db),
                    referencedColumn: $$CategoriesTableReferences
                        ._parentCategoryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<CategoryEntry, $CategoriesTable,
                            TransactionEntry>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    CategoryEntry,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (CategoryEntry, $$CategoriesTableReferences),
    CategoryEntry,
    PrefetchHooks Function({bool parentCategoryId, bool transactionsRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  required String importBatchId,
  Value<String?> accountId,
  Value<DateTime?> transactionDate,
  Value<DateTime?> postedDate,
  required String rawDescription,
  Value<String?> merchantName,
  required double amount,
  required String direction,
  Value<String> currency,
  Value<double?> balanceAfter,
  Value<String?> categoryId,
  Value<String?> categoryName,
  Value<double> categorizationConfidence,
  Value<String?> categorizationExplanation,
  Value<List<String>> tags,
  Value<List<String>> labelIds,
  Value<String?> notes,
  required String fingerprint,
  Value<int> isDuplicate,
  Value<int> needsReview,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> importBatchId,
  Value<String?> accountId,
  Value<DateTime?> transactionDate,
  Value<DateTime?> postedDate,
  Value<String> rawDescription,
  Value<String?> merchantName,
  Value<double> amount,
  Value<String> direction,
  Value<String> currency,
  Value<double?> balanceAfter,
  Value<String?> categoryId,
  Value<String?> categoryName,
  Value<double> categorizationConfidence,
  Value<String?> categorizationExplanation,
  Value<List<String>> tags,
  Value<List<String>> labelIds,
  Value<String?> notes,
  Value<String> fingerprint,
  Value<int> isDuplicate,
  Value<int> needsReview,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$TransactionsTableReferences extends BaseReferences<_$AppDatabase,
    $TransactionsTable, TransactionEntry> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ImportBatchesTable _importBatchIdTable(_$AppDatabase db) =>
      db.importBatches
          .createAlias('transactions__import_batch_id__import_batches__id');

  $$ImportBatchesTableProcessedTableManager get importBatchId {
    final $_column = $_itemColumn<String>('import_batch_id')!;

    final manager = $$ImportBatchesTableTableManager($_db, $_db.importBatches)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_importBatchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int>
      get transactionDate => $composableBuilder(
          column: $table.transactionDate,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get postedDate =>
      $composableBuilder(
          column: $table.postedDate,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get rawDescription => $composableBuilder(
      column: $table.rawDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchantName => $composableBuilder(
      column: $table.merchantName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get categorizationConfidence => $composableBuilder(
      column: $table.categorizationConfidence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categorizationExplanation => $composableBuilder(
      column: $table.categorizationExplanation,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
          column: $table.tags,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get labelIds => $composableBuilder(
          column: $table.labelIds,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fingerprint => $composableBuilder(
      column: $table.fingerprint, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDuplicate => $composableBuilder(
      column: $table.isDuplicate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get needsReview => $composableBuilder(
      column: $table.needsReview, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$ImportBatchesTableFilterComposer get importBatchId {
    final $$ImportBatchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.importBatchId,
        referencedTable: $db.importBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImportBatchesTableFilterComposer(
              $db: $db,
              $table: $db.importBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get postedDate => $composableBuilder(
      column: $table.postedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawDescription => $composableBuilder(
      column: $table.rawDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchantName => $composableBuilder(
      column: $table.merchantName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get categorizationConfidence => $composableBuilder(
      column: $table.categorizationConfidence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categorizationExplanation => $composableBuilder(
      column: $table.categorizationExplanation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelIds => $composableBuilder(
      column: $table.labelIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fingerprint => $composableBuilder(
      column: $table.fingerprint, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDuplicate => $composableBuilder(
      column: $table.isDuplicate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get needsReview => $composableBuilder(
      column: $table.needsReview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ImportBatchesTableOrderingComposer get importBatchId {
    final $$ImportBatchesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.importBatchId,
        referencedTable: $db.importBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImportBatchesTableOrderingComposer(
              $db: $db,
              $table: $db.importBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get transactionDate =>
      $composableBuilder(
          column: $table.transactionDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get postedDate =>
      $composableBuilder(
          column: $table.postedDate, builder: (column) => column);

  GeneratedColumn<String> get rawDescription => $composableBuilder(
      column: $table.rawDescription, builder: (column) => column);

  GeneratedColumn<String> get merchantName => $composableBuilder(
      column: $table.merchantName, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<double> get categorizationConfidence => $composableBuilder(
      column: $table.categorizationConfidence, builder: (column) => column);

  GeneratedColumn<String> get categorizationExplanation => $composableBuilder(
      column: $table.categorizationExplanation, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get labelIds =>
      $composableBuilder(column: $table.labelIds, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
      column: $table.fingerprint, builder: (column) => column);

  GeneratedColumn<int> get isDuplicate => $composableBuilder(
      column: $table.isDuplicate, builder: (column) => column);

  GeneratedColumn<int> get needsReview => $composableBuilder(
      column: $table.needsReview, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ImportBatchesTableAnnotationComposer get importBatchId {
    final $$ImportBatchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.importBatchId,
        referencedTable: $db.importBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImportBatchesTableAnnotationComposer(
              $db: $db,
              $table: $db.importBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    TransactionEntry,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (TransactionEntry, $$TransactionsTableReferences),
    TransactionEntry,
    PrefetchHooks Function({bool importBatchId, bool categoryId})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> importBatchId = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<DateTime?> transactionDate = const Value.absent(),
            Value<DateTime?> postedDate = const Value.absent(),
            Value<String> rawDescription = const Value.absent(),
            Value<String?> merchantName = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> direction = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double?> balanceAfter = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> categoryName = const Value.absent(),
            Value<double> categorizationConfidence = const Value.absent(),
            Value<String?> categorizationExplanation = const Value.absent(),
            Value<List<String>> tags = const Value.absent(),
            Value<List<String>> labelIds = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> fingerprint = const Value.absent(),
            Value<int> isDuplicate = const Value.absent(),
            Value<int> needsReview = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            importBatchId: importBatchId,
            accountId: accountId,
            transactionDate: transactionDate,
            postedDate: postedDate,
            rawDescription: rawDescription,
            merchantName: merchantName,
            amount: amount,
            direction: direction,
            currency: currency,
            balanceAfter: balanceAfter,
            categoryId: categoryId,
            categoryName: categoryName,
            categorizationConfidence: categorizationConfidence,
            categorizationExplanation: categorizationExplanation,
            tags: tags,
            labelIds: labelIds,
            notes: notes,
            fingerprint: fingerprint,
            isDuplicate: isDuplicate,
            needsReview: needsReview,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String importBatchId,
            Value<String?> accountId = const Value.absent(),
            Value<DateTime?> transactionDate = const Value.absent(),
            Value<DateTime?> postedDate = const Value.absent(),
            required String rawDescription,
            Value<String?> merchantName = const Value.absent(),
            required double amount,
            required String direction,
            Value<String> currency = const Value.absent(),
            Value<double?> balanceAfter = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> categoryName = const Value.absent(),
            Value<double> categorizationConfidence = const Value.absent(),
            Value<String?> categorizationExplanation = const Value.absent(),
            Value<List<String>> tags = const Value.absent(),
            Value<List<String>> labelIds = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required String fingerprint,
            Value<int> isDuplicate = const Value.absent(),
            Value<int> needsReview = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            importBatchId: importBatchId,
            accountId: accountId,
            transactionDate: transactionDate,
            postedDate: postedDate,
            rawDescription: rawDescription,
            merchantName: merchantName,
            amount: amount,
            direction: direction,
            currency: currency,
            balanceAfter: balanceAfter,
            categoryId: categoryId,
            categoryName: categoryName,
            categorizationConfidence: categorizationConfidence,
            categorizationExplanation: categorizationExplanation,
            tags: tags,
            labelIds: labelIds,
            notes: notes,
            fingerprint: fingerprint,
            isDuplicate: isDuplicate,
            needsReview: needsReview,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({importBatchId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (importBatchId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.importBatchId,
                    referencedTable:
                        $$TransactionsTableReferences._importBatchIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._importBatchIdTable(db)
                        .id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$TransactionsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    TransactionEntry,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (TransactionEntry, $$TransactionsTableReferences),
    TransactionEntry,
    PrefetchHooks Function({bool importBatchId, bool categoryId})>;
typedef $$CategorizationRulesTableCreateCompanionBuilder
    = CategorizationRulesCompanion Function({
  Value<String> id,
  required String pattern,
  required String matchType,
  required String categoryId,
  Value<String?> categoryName,
  Value<String?> merchantName,
  Value<int> priority,
  Value<int> createdByUser,
  Value<int> usageCount,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$CategorizationRulesTableUpdateCompanionBuilder
    = CategorizationRulesCompanion Function({
  Value<String> id,
  Value<String> pattern,
  Value<String> matchType,
  Value<String> categoryId,
  Value<String?> categoryName,
  Value<String?> merchantName,
  Value<int> priority,
  Value<int> createdByUser,
  Value<int> usageCount,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$CategorizationRulesTableFilterComposer
    extends Composer<_$AppDatabase, $CategorizationRulesTable> {
  $$CategorizationRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pattern => $composableBuilder(
      column: $table.pattern, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get matchType => $composableBuilder(
      column: $table.matchType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchantName => $composableBuilder(
      column: $table.merchantName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdByUser => $composableBuilder(
      column: $table.createdByUser, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$CategorizationRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategorizationRulesTable> {
  $$CategorizationRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pattern => $composableBuilder(
      column: $table.pattern, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get matchType => $composableBuilder(
      column: $table.matchType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchantName => $composableBuilder(
      column: $table.merchantName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdByUser => $composableBuilder(
      column: $table.createdByUser,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CategorizationRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategorizationRulesTable> {
  $$CategorizationRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<String> get matchType =>
      $composableBuilder(column: $table.matchType, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<String> get merchantName => $composableBuilder(
      column: $table.merchantName, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get createdByUser => $composableBuilder(
      column: $table.createdByUser, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategorizationRulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategorizationRulesTable,
    CategorizationRuleEntry,
    $$CategorizationRulesTableFilterComposer,
    $$CategorizationRulesTableOrderingComposer,
    $$CategorizationRulesTableAnnotationComposer,
    $$CategorizationRulesTableCreateCompanionBuilder,
    $$CategorizationRulesTableUpdateCompanionBuilder,
    (
      CategorizationRuleEntry,
      BaseReferences<_$AppDatabase, $CategorizationRulesTable,
          CategorizationRuleEntry>
    ),
    CategorizationRuleEntry,
    PrefetchHooks Function()> {
  $$CategorizationRulesTableTableManager(
      _$AppDatabase db, $CategorizationRulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategorizationRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategorizationRulesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategorizationRulesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> pattern = const Value.absent(),
            Value<String> matchType = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String?> categoryName = const Value.absent(),
            Value<String?> merchantName = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> createdByUser = const Value.absent(),
            Value<int> usageCount = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategorizationRulesCompanion(
            id: id,
            pattern: pattern,
            matchType: matchType,
            categoryId: categoryId,
            categoryName: categoryName,
            merchantName: merchantName,
            priority: priority,
            createdByUser: createdByUser,
            usageCount: usageCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String pattern,
            required String matchType,
            required String categoryId,
            Value<String?> categoryName = const Value.absent(),
            Value<String?> merchantName = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> createdByUser = const Value.absent(),
            Value<int> usageCount = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategorizationRulesCompanion.insert(
            id: id,
            pattern: pattern,
            matchType: matchType,
            categoryId: categoryId,
            categoryName: categoryName,
            merchantName: merchantName,
            priority: priority,
            createdByUser: createdByUser,
            usageCount: usageCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategorizationRulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategorizationRulesTable,
    CategorizationRuleEntry,
    $$CategorizationRulesTableFilterComposer,
    $$CategorizationRulesTableOrderingComposer,
    $$CategorizationRulesTableAnnotationComposer,
    $$CategorizationRulesTableCreateCompanionBuilder,
    $$CategorizationRulesTableUpdateCompanionBuilder,
    (
      CategorizationRuleEntry,
      BaseReferences<_$AppDatabase, $CategorizationRulesTable,
          CategorizationRuleEntry>
    ),
    CategorizationRuleEntry,
    PrefetchHooks Function()>;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  Value<String> id,
  required String categoryId,
  Value<String?> categoryName,
  required int month,
  required int year,
  required double amount,
  Value<double> spent,
  Value<String> currency,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> id,
  Value<String> categoryId,
  Value<String?> categoryName,
  Value<int> month,
  Value<int> year,
  Value<double> amount,
  Value<double> spent,
  Value<String> currency,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get spent => $composableBuilder(
      column: $table.spent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get spent => $composableBuilder(
      column: $table.spent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get spent =>
      $composableBuilder(column: $table.spent, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetsTable,
    BudgetEntry,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (BudgetEntry, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetEntry>),
    BudgetEntry,
    PrefetchHooks Function()> {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String?> categoryName = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> spent = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion(
            id: id,
            categoryId: categoryId,
            categoryName: categoryName,
            month: month,
            year: year,
            amount: amount,
            spent: spent,
            currency: currency,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String categoryId,
            Value<String?> categoryName = const Value.absent(),
            required int month,
            required int year,
            required double amount,
            Value<double> spent = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion.insert(
            id: id,
            categoryId: categoryId,
            categoryName: categoryName,
            month: month,
            year: year,
            amount: amount,
            spent: spent,
            currency: currency,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetsTable,
    BudgetEntry,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (BudgetEntry, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetEntry>),
    BudgetEntry,
    PrefetchHooks Function()>;
typedef $$RecurringPaymentsTableCreateCompanionBuilder
    = RecurringPaymentsCompanion Function({
  Value<String> id,
  required String merchantName,
  Value<String?> categoryId,
  Value<String?> categoryName,
  required double expectedAmount,
  required String frequency,
  Value<double> confidence,
  required String status,
  Value<DateTime?> nextExpectedDate,
  Value<DateTime?> lastTransactionDate,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$RecurringPaymentsTableUpdateCompanionBuilder
    = RecurringPaymentsCompanion Function({
  Value<String> id,
  Value<String> merchantName,
  Value<String?> categoryId,
  Value<String?> categoryName,
  Value<double> expectedAmount,
  Value<String> frequency,
  Value<double> confidence,
  Value<String> status,
  Value<DateTime?> nextExpectedDate,
  Value<DateTime?> lastTransactionDate,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$RecurringPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchantName => $composableBuilder(
      column: $table.merchantName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get expectedAmount => $composableBuilder(
      column: $table.expectedAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int>
      get nextExpectedDate => $composableBuilder(
          column: $table.nextExpectedDate,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int>
      get lastTransactionDate => $composableBuilder(
          column: $table.lastTransactionDate,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$RecurringPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchantName => $composableBuilder(
      column: $table.merchantName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get expectedAmount => $composableBuilder(
      column: $table.expectedAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextExpectedDate => $composableBuilder(
      column: $table.nextExpectedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastTransactionDate => $composableBuilder(
      column: $table.lastTransactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RecurringPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get merchantName => $composableBuilder(
      column: $table.merchantName, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<double> get expectedAmount => $composableBuilder(
      column: $table.expectedAmount, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get nextExpectedDate =>
      $composableBuilder(
          column: $table.nextExpectedDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get lastTransactionDate =>
      $composableBuilder(
          column: $table.lastTransactionDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecurringPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringPaymentsTable,
    RecurringPaymentEntry,
    $$RecurringPaymentsTableFilterComposer,
    $$RecurringPaymentsTableOrderingComposer,
    $$RecurringPaymentsTableAnnotationComposer,
    $$RecurringPaymentsTableCreateCompanionBuilder,
    $$RecurringPaymentsTableUpdateCompanionBuilder,
    (
      RecurringPaymentEntry,
      BaseReferences<_$AppDatabase, $RecurringPaymentsTable,
          RecurringPaymentEntry>
    ),
    RecurringPaymentEntry,
    PrefetchHooks Function()> {
  $$RecurringPaymentsTableTableManager(
      _$AppDatabase db, $RecurringPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringPaymentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> merchantName = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> categoryName = const Value.absent(),
            Value<double> expectedAmount = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> nextExpectedDate = const Value.absent(),
            Value<DateTime?> lastTransactionDate = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringPaymentsCompanion(
            id: id,
            merchantName: merchantName,
            categoryId: categoryId,
            categoryName: categoryName,
            expectedAmount: expectedAmount,
            frequency: frequency,
            confidence: confidence,
            status: status,
            nextExpectedDate: nextExpectedDate,
            lastTransactionDate: lastTransactionDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String merchantName,
            Value<String?> categoryId = const Value.absent(),
            Value<String?> categoryName = const Value.absent(),
            required double expectedAmount,
            required String frequency,
            Value<double> confidence = const Value.absent(),
            required String status,
            Value<DateTime?> nextExpectedDate = const Value.absent(),
            Value<DateTime?> lastTransactionDate = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringPaymentsCompanion.insert(
            id: id,
            merchantName: merchantName,
            categoryId: categoryId,
            categoryName: categoryName,
            expectedAmount: expectedAmount,
            frequency: frequency,
            confidence: confidence,
            status: status,
            nextExpectedDate: nextExpectedDate,
            lastTransactionDate: lastTransactionDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecurringPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecurringPaymentsTable,
    RecurringPaymentEntry,
    $$RecurringPaymentsTableFilterComposer,
    $$RecurringPaymentsTableOrderingComposer,
    $$RecurringPaymentsTableAnnotationComposer,
    $$RecurringPaymentsTableCreateCompanionBuilder,
    $$RecurringPaymentsTableUpdateCompanionBuilder,
    (
      RecurringPaymentEntry,
      BaseReferences<_$AppDatabase, $RecurringPaymentsTable,
          RecurringPaymentEntry>
    ),
    RecurringPaymentEntry,
    PrefetchHooks Function()>;
typedef $$ReviewItemsTableCreateCompanionBuilder = ReviewItemsCompanion
    Function({
  Value<String> id,
  required String transactionId,
  required String reason,
  Value<String?> suggestedCategoryId,
  Value<String?> suggestedCategoryName,
  Value<String?> suggestedMerchant,
  Value<double> confidence,
  Value<String?> explanation,
  Value<DateTime?> createdAt,
  Value<int> rowid,
});
typedef $$ReviewItemsTableUpdateCompanionBuilder = ReviewItemsCompanion
    Function({
  Value<String> id,
  Value<String> transactionId,
  Value<String> reason,
  Value<String?> suggestedCategoryId,
  Value<String?> suggestedCategoryName,
  Value<String?> suggestedMerchant,
  Value<double> confidence,
  Value<String?> explanation,
  Value<DateTime?> createdAt,
  Value<int> rowid,
});

class $$ReviewItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewItemsTable> {
  $$ReviewItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get suggestedCategoryId => $composableBuilder(
      column: $table.suggestedCategoryId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get suggestedCategoryName => $composableBuilder(
      column: $table.suggestedCategoryName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get suggestedMerchant => $composableBuilder(
      column: $table.suggestedMerchant,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$ReviewItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewItemsTable> {
  $$ReviewItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get suggestedCategoryId => $composableBuilder(
      column: $table.suggestedCategoryId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get suggestedCategoryName => $composableBuilder(
      column: $table.suggestedCategoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get suggestedMerchant => $composableBuilder(
      column: $table.suggestedMerchant,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ReviewItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewItemsTable> {
  $$ReviewItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get suggestedCategoryId => $composableBuilder(
      column: $table.suggestedCategoryId, builder: (column) => column);

  GeneratedColumn<String> get suggestedCategoryName => $composableBuilder(
      column: $table.suggestedCategoryName, builder: (column) => column);

  GeneratedColumn<String> get suggestedMerchant => $composableBuilder(
      column: $table.suggestedMerchant, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReviewItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReviewItemsTable,
    ReviewItemsEntry,
    $$ReviewItemsTableFilterComposer,
    $$ReviewItemsTableOrderingComposer,
    $$ReviewItemsTableAnnotationComposer,
    $$ReviewItemsTableCreateCompanionBuilder,
    $$ReviewItemsTableUpdateCompanionBuilder,
    (
      ReviewItemsEntry,
      BaseReferences<_$AppDatabase, $ReviewItemsTable, ReviewItemsEntry>
    ),
    ReviewItemsEntry,
    PrefetchHooks Function()> {
  $$ReviewItemsTableTableManager(_$AppDatabase db, $ReviewItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> transactionId = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String?> suggestedCategoryId = const Value.absent(),
            Value<String?> suggestedCategoryName = const Value.absent(),
            Value<String?> suggestedMerchant = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String?> explanation = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReviewItemsCompanion(
            id: id,
            transactionId: transactionId,
            reason: reason,
            suggestedCategoryId: suggestedCategoryId,
            suggestedCategoryName: suggestedCategoryName,
            suggestedMerchant: suggestedMerchant,
            confidence: confidence,
            explanation: explanation,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String transactionId,
            required String reason,
            Value<String?> suggestedCategoryId = const Value.absent(),
            Value<String?> suggestedCategoryName = const Value.absent(),
            Value<String?> suggestedMerchant = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String?> explanation = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReviewItemsCompanion.insert(
            id: id,
            transactionId: transactionId,
            reason: reason,
            suggestedCategoryId: suggestedCategoryId,
            suggestedCategoryName: suggestedCategoryName,
            suggestedMerchant: suggestedMerchant,
            confidence: confidence,
            explanation: explanation,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReviewItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReviewItemsTable,
    ReviewItemsEntry,
    $$ReviewItemsTableFilterComposer,
    $$ReviewItemsTableOrderingComposer,
    $$ReviewItemsTableAnnotationComposer,
    $$ReviewItemsTableCreateCompanionBuilder,
    $$ReviewItemsTableUpdateCompanionBuilder,
    (
      ReviewItemsEntry,
      BaseReferences<_$AppDatabase, $ReviewItemsTable, ReviewItemsEntry>
    ),
    ReviewItemsEntry,
    PrefetchHooks Function()>;
typedef $$AgentActionLogsTableCreateCompanionBuilder = AgentActionLogsCompanion
    Function({
  Value<String> id,
  required String agentName,
  required String actionType,
  Value<String?> inputSummary,
  Value<String?> outputSummary,
  Value<double> confidence,
  Value<String?> explanation,
  Value<String?> relatedTransactionId,
  Value<String?> relatedImportBatchId,
  Value<DateTime?> createdAt,
  Value<int> rowid,
});
typedef $$AgentActionLogsTableUpdateCompanionBuilder = AgentActionLogsCompanion
    Function({
  Value<String> id,
  Value<String> agentName,
  Value<String> actionType,
  Value<String?> inputSummary,
  Value<String?> outputSummary,
  Value<double> confidence,
  Value<String?> explanation,
  Value<String?> relatedTransactionId,
  Value<String?> relatedImportBatchId,
  Value<DateTime?> createdAt,
  Value<int> rowid,
});

class $$AgentActionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AgentActionLogsTable> {
  $$AgentActionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agentName => $composableBuilder(
      column: $table.agentName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inputSummary => $composableBuilder(
      column: $table.inputSummary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outputSummary => $composableBuilder(
      column: $table.outputSummary, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedTransactionId => $composableBuilder(
      column: $table.relatedTransactionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedImportBatchId => $composableBuilder(
      column: $table.relatedImportBatchId,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$AgentActionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AgentActionLogsTable> {
  $$AgentActionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agentName => $composableBuilder(
      column: $table.agentName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inputSummary => $composableBuilder(
      column: $table.inputSummary,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outputSummary => $composableBuilder(
      column: $table.outputSummary,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedTransactionId => $composableBuilder(
      column: $table.relatedTransactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedImportBatchId => $composableBuilder(
      column: $table.relatedImportBatchId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AgentActionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AgentActionLogsTable> {
  $$AgentActionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get agentName =>
      $composableBuilder(column: $table.agentName, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => column);

  GeneratedColumn<String> get inputSummary => $composableBuilder(
      column: $table.inputSummary, builder: (column) => column);

  GeneratedColumn<String> get outputSummary => $composableBuilder(
      column: $table.outputSummary, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);

  GeneratedColumn<String> get relatedTransactionId => $composableBuilder(
      column: $table.relatedTransactionId, builder: (column) => column);

  GeneratedColumn<String> get relatedImportBatchId => $composableBuilder(
      column: $table.relatedImportBatchId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AgentActionLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AgentActionLogsTable,
    AgentActionLogEntry,
    $$AgentActionLogsTableFilterComposer,
    $$AgentActionLogsTableOrderingComposer,
    $$AgentActionLogsTableAnnotationComposer,
    $$AgentActionLogsTableCreateCompanionBuilder,
    $$AgentActionLogsTableUpdateCompanionBuilder,
    (
      AgentActionLogEntry,
      BaseReferences<_$AppDatabase, $AgentActionLogsTable, AgentActionLogEntry>
    ),
    AgentActionLogEntry,
    PrefetchHooks Function()> {
  $$AgentActionLogsTableTableManager(
      _$AppDatabase db, $AgentActionLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgentActionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AgentActionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgentActionLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> agentName = const Value.absent(),
            Value<String> actionType = const Value.absent(),
            Value<String?> inputSummary = const Value.absent(),
            Value<String?> outputSummary = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String?> explanation = const Value.absent(),
            Value<String?> relatedTransactionId = const Value.absent(),
            Value<String?> relatedImportBatchId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgentActionLogsCompanion(
            id: id,
            agentName: agentName,
            actionType: actionType,
            inputSummary: inputSummary,
            outputSummary: outputSummary,
            confidence: confidence,
            explanation: explanation,
            relatedTransactionId: relatedTransactionId,
            relatedImportBatchId: relatedImportBatchId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String agentName,
            required String actionType,
            Value<String?> inputSummary = const Value.absent(),
            Value<String?> outputSummary = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String?> explanation = const Value.absent(),
            Value<String?> relatedTransactionId = const Value.absent(),
            Value<String?> relatedImportBatchId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgentActionLogsCompanion.insert(
            id: id,
            agentName: agentName,
            actionType: actionType,
            inputSummary: inputSummary,
            outputSummary: outputSummary,
            confidence: confidence,
            explanation: explanation,
            relatedTransactionId: relatedTransactionId,
            relatedImportBatchId: relatedImportBatchId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AgentActionLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AgentActionLogsTable,
    AgentActionLogEntry,
    $$AgentActionLogsTableFilterComposer,
    $$AgentActionLogsTableOrderingComposer,
    $$AgentActionLogsTableAnnotationComposer,
    $$AgentActionLogsTableCreateCompanionBuilder,
    $$AgentActionLogsTableUpdateCompanionBuilder,
    (
      AgentActionLogEntry,
      BaseReferences<_$AppDatabase, $AgentActionLogsTable, AgentActionLogEntry>
    ),
    AgentActionLogEntry,
    PrefetchHooks Function()>;
typedef $$UserSettingsTableTableCreateCompanionBuilder
    = UserSettingsTableCompanion Function({
  Value<String> id,
  Value<int> appLockEnabled,
  Value<String> currency,
  Value<int> firstLaunchCompleted,
  Value<int> privacyModeEnabled,
  Value<int> debugModeEnabled,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$UserSettingsTableTableUpdateCompanionBuilder
    = UserSettingsTableCompanion Function({
  Value<String> id,
  Value<int> appLockEnabled,
  Value<String> currency,
  Value<int> firstLaunchCompleted,
  Value<int> privacyModeEnabled,
  Value<int> debugModeEnabled,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get appLockEnabled => $composableBuilder(
      column: $table.appLockEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get firstLaunchCompleted => $composableBuilder(
      column: $table.firstLaunchCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get privacyModeEnabled => $composableBuilder(
      column: $table.privacyModeEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get debugModeEnabled => $composableBuilder(
      column: $table.debugModeEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get appLockEnabled => $composableBuilder(
      column: $table.appLockEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get firstLaunchCompleted => $composableBuilder(
      column: $table.firstLaunchCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get privacyModeEnabled => $composableBuilder(
      column: $table.privacyModeEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get debugModeEnabled => $composableBuilder(
      column: $table.debugModeEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get appLockEnabled => $composableBuilder(
      column: $table.appLockEnabled, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get firstLaunchCompleted => $composableBuilder(
      column: $table.firstLaunchCompleted, builder: (column) => column);

  GeneratedColumn<int> get privacyModeEnabled => $composableBuilder(
      column: $table.privacyModeEnabled, builder: (column) => column);

  GeneratedColumn<int> get debugModeEnabled => $composableBuilder(
      column: $table.debugModeEnabled, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSettingsTableTable,
    UserSettingsEntry,
    $$UserSettingsTableTableFilterComposer,
    $$UserSettingsTableTableOrderingComposer,
    $$UserSettingsTableTableAnnotationComposer,
    $$UserSettingsTableTableCreateCompanionBuilder,
    $$UserSettingsTableTableUpdateCompanionBuilder,
    (
      UserSettingsEntry,
      BaseReferences<_$AppDatabase, $UserSettingsTableTable, UserSettingsEntry>
    ),
    UserSettingsEntry,
    PrefetchHooks Function()> {
  $$UserSettingsTableTableTableManager(
      _$AppDatabase db, $UserSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> appLockEnabled = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<int> firstLaunchCompleted = const Value.absent(),
            Value<int> privacyModeEnabled = const Value.absent(),
            Value<int> debugModeEnabled = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSettingsTableCompanion(
            id: id,
            appLockEnabled: appLockEnabled,
            currency: currency,
            firstLaunchCompleted: firstLaunchCompleted,
            privacyModeEnabled: privacyModeEnabled,
            debugModeEnabled: debugModeEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> appLockEnabled = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<int> firstLaunchCompleted = const Value.absent(),
            Value<int> privacyModeEnabled = const Value.absent(),
            Value<int> debugModeEnabled = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSettingsTableCompanion.insert(
            id: id,
            appLockEnabled: appLockEnabled,
            currency: currency,
            firstLaunchCompleted: firstLaunchCompleted,
            privacyModeEnabled: privacyModeEnabled,
            debugModeEnabled: debugModeEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserSettingsTableTable,
    UserSettingsEntry,
    $$UserSettingsTableTableFilterComposer,
    $$UserSettingsTableTableOrderingComposer,
    $$UserSettingsTableTableAnnotationComposer,
    $$UserSettingsTableTableCreateCompanionBuilder,
    $$UserSettingsTableTableUpdateCompanionBuilder,
    (
      UserSettingsEntry,
      BaseReferences<_$AppDatabase, $UserSettingsTableTable, UserSettingsEntry>
    ),
    UserSettingsEntry,
    PrefetchHooks Function()>;
typedef $$TransactionLabelsTableCreateCompanionBuilder
    = TransactionLabelsCompanion Function({
  Value<String> id,
  required String name,
  Value<int> color,
  Value<int> isSystem,
  Value<int> rowid,
});
typedef $$TransactionLabelsTableUpdateCompanionBuilder
    = TransactionLabelsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> color,
  Value<int> isSystem,
  Value<int> rowid,
});

class $$TransactionLabelsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionLabelsTable> {
  $$TransactionLabelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));
}

class $$TransactionLabelsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionLabelsTable> {
  $$TransactionLabelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));
}

class $$TransactionLabelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionLabelsTable> {
  $$TransactionLabelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);
}

class $$TransactionLabelsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionLabelsTable,
    TransactionLabelEntry,
    $$TransactionLabelsTableFilterComposer,
    $$TransactionLabelsTableOrderingComposer,
    $$TransactionLabelsTableAnnotationComposer,
    $$TransactionLabelsTableCreateCompanionBuilder,
    $$TransactionLabelsTableUpdateCompanionBuilder,
    (
      TransactionLabelEntry,
      BaseReferences<_$AppDatabase, $TransactionLabelsTable,
          TransactionLabelEntry>
    ),
    TransactionLabelEntry,
    PrefetchHooks Function()> {
  $$TransactionLabelsTableTableManager(
      _$AppDatabase db, $TransactionLabelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionLabelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionLabelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionLabelsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> color = const Value.absent(),
            Value<int> isSystem = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionLabelsCompanion(
            id: id,
            name: name,
            color: color,
            isSystem: isSystem,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<int> color = const Value.absent(),
            Value<int> isSystem = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionLabelsCompanion.insert(
            id: id,
            name: name,
            color: color,
            isSystem: isSystem,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionLabelsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionLabelsTable,
    TransactionLabelEntry,
    $$TransactionLabelsTableFilterComposer,
    $$TransactionLabelsTableOrderingComposer,
    $$TransactionLabelsTableAnnotationComposer,
    $$TransactionLabelsTableCreateCompanionBuilder,
    $$TransactionLabelsTableUpdateCompanionBuilder,
    (
      TransactionLabelEntry,
      BaseReferences<_$AppDatabase, $TransactionLabelsTable,
          TransactionLabelEntry>
    ),
    TransactionLabelEntry,
    PrefetchHooks Function()>;
typedef $$CreditCardsTableCreateCompanionBuilder = CreditCardsCompanion
    Function({
  Value<String> id,
  required String name,
  Value<String?> issuer,
  required String lastFour,
  required double creditLimit,
  Value<double> availableCredit,
  Value<int> billingDay,
  Value<int> dueDay,
  Value<int> isActive,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$CreditCardsTableUpdateCompanionBuilder = CreditCardsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> issuer,
  Value<String> lastFour,
  Value<double> creditLimit,
  Value<double> availableCredit,
  Value<int> billingDay,
  Value<int> dueDay,
  Value<int> isActive,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$CreditCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get issuer => $composableBuilder(
      column: $table.issuer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastFour => $composableBuilder(
      column: $table.lastFour, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get availableCredit => $composableBuilder(
      column: $table.availableCredit,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get billingDay => $composableBuilder(
      column: $table.billingDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueDay => $composableBuilder(
      column: $table.dueDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$CreditCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get issuer => $composableBuilder(
      column: $table.issuer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastFour => $composableBuilder(
      column: $table.lastFour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get availableCredit => $composableBuilder(
      column: $table.availableCredit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get billingDay => $composableBuilder(
      column: $table.billingDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueDay => $composableBuilder(
      column: $table.dueDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CreditCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get issuer =>
      $composableBuilder(column: $table.issuer, builder: (column) => column);

  GeneratedColumn<String> get lastFour =>
      $composableBuilder(column: $table.lastFour, builder: (column) => column);

  GeneratedColumn<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => column);

  GeneratedColumn<double> get availableCredit => $composableBuilder(
      column: $table.availableCredit, builder: (column) => column);

  GeneratedColumn<int> get billingDay => $composableBuilder(
      column: $table.billingDay, builder: (column) => column);

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CreditCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CreditCardsTable,
    CreditCardEntry,
    $$CreditCardsTableFilterComposer,
    $$CreditCardsTableOrderingComposer,
    $$CreditCardsTableAnnotationComposer,
    $$CreditCardsTableCreateCompanionBuilder,
    $$CreditCardsTableUpdateCompanionBuilder,
    (
      CreditCardEntry,
      BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCardEntry>
    ),
    CreditCardEntry,
    PrefetchHooks Function()> {
  $$CreditCardsTableTableManager(_$AppDatabase db, $CreditCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> issuer = const Value.absent(),
            Value<String> lastFour = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<double> availableCredit = const Value.absent(),
            Value<int> billingDay = const Value.absent(),
            Value<int> dueDay = const Value.absent(),
            Value<int> isActive = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardsCompanion(
            id: id,
            name: name,
            issuer: issuer,
            lastFour: lastFour,
            creditLimit: creditLimit,
            availableCredit: availableCredit,
            billingDay: billingDay,
            dueDay: dueDay,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String?> issuer = const Value.absent(),
            required String lastFour,
            required double creditLimit,
            Value<double> availableCredit = const Value.absent(),
            Value<int> billingDay = const Value.absent(),
            Value<int> dueDay = const Value.absent(),
            Value<int> isActive = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardsCompanion.insert(
            id: id,
            name: name,
            issuer: issuer,
            lastFour: lastFour,
            creditLimit: creditLimit,
            availableCredit: availableCredit,
            billingDay: billingDay,
            dueDay: dueDay,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CreditCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CreditCardsTable,
    CreditCardEntry,
    $$CreditCardsTableFilterComposer,
    $$CreditCardsTableOrderingComposer,
    $$CreditCardsTableAnnotationComposer,
    $$CreditCardsTableCreateCompanionBuilder,
    $$CreditCardsTableUpdateCompanionBuilder,
    (
      CreditCardEntry,
      BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCardEntry>
    ),
    CreditCardEntry,
    PrefetchHooks Function()>;
typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  required String name,
  Value<String?> bankName,
  required String type,
  Value<double> balance,
  Value<String> currency,
  Value<String?> lastFour,
  Value<int> isActive,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> bankName,
  Value<String> type,
  Value<double> balance,
  Value<String> currency,
  Value<String?> lastFour,
  Value<int> isActive,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastFour => $composableBuilder(
      column: $table.lastFour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get createdAt =>
      $composableBuilder(
          column: $table.createdAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get updatedAt =>
      $composableBuilder(
          column: $table.updatedAt,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastFour => $composableBuilder(
      column: $table.lastFour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get lastFour =>
      $composableBuilder(column: $table.lastFour, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    AccountEntry,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (AccountEntry, BaseReferences<_$AppDatabase, $AccountsTable, AccountEntry>),
    AccountEntry,
    PrefetchHooks Function()> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> bankName = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> lastFour = const Value.absent(),
            Value<int> isActive = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            name: name,
            bankName: bankName,
            type: type,
            balance: balance,
            currency: currency,
            lastFour: lastFour,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String?> bankName = const Value.absent(),
            required String type,
            Value<double> balance = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> lastFour = const Value.absent(),
            Value<int> isActive = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            name: name,
            bankName: bankName,
            type: type,
            balance: balance,
            currency: currency,
            lastFour: lastFour,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    AccountEntry,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (AccountEntry, BaseReferences<_$AppDatabase, $AccountsTable, AccountEntry>),
    AccountEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ImportBatchesTableTableManager get importBatches =>
      $$ImportBatchesTableTableManager(_db, _db.importBatches);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$CategorizationRulesTableTableManager get categorizationRules =>
      $$CategorizationRulesTableTableManager(_db, _db.categorizationRules);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$RecurringPaymentsTableTableManager get recurringPayments =>
      $$RecurringPaymentsTableTableManager(_db, _db.recurringPayments);
  $$ReviewItemsTableTableManager get reviewItems =>
      $$ReviewItemsTableTableManager(_db, _db.reviewItems);
  $$AgentActionLogsTableTableManager get agentActionLogs =>
      $$AgentActionLogsTableTableManager(_db, _db.agentActionLogs);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
  $$TransactionLabelsTableTableManager get transactionLabels =>
      $$TransactionLabelsTableTableManager(_db, _db.transactionLabels);
  $$CreditCardsTableTableManager get creditCards =>
      $$CreditCardsTableTableManager(_db, _db.creditCards);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
}
